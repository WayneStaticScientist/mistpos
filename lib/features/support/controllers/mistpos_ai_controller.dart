import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mistpos/core/services/api/network_wrapper.dart';
import 'package:mistpos/data/models/token_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mistpos/main.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:mistpos/data/models/item_receit_model.dart';
import 'package:mistpos/data/models/shifts_model.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';

class MistposAiController extends GetxController {
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxBool isWaiting = false.obs;
  final RxString currentStreamingMessage = "".obs;

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    messages.add({
      "role": "user",
      "content": text.trim(),
    });

    isWaiting.value = true;
    currentStreamingMessage.value = "";

    try {
      final token = TokenModel.fromStorage().accessToken;
      final packageInfo = await PackageInfo.fromPlatform();
      
      final isar = IsarStatic.getInstance();
      int unsyncedReceipts = 0;
      int unsyncedShifts = 0;
      if (isar != null) {
        unsyncedReceipts = isar.itemReceitModels.where().syncedEqualTo(false).count();
        unsyncedShifts = isar.shiftsModels.where().syncedEqualTo(false).count();
      }

      final dio = Dio();
      final response = await dio.post(
        '${Net.baseUrl}/ai/client-chat',
        data: {
          "messages": messages.map((m) => {
            "role": m['role'],
            "content": m['content']
          }).toList(),
          "clientDate": DateTime.now().toIso8601String(),
          "mistposAppVersion": packageInfo.version + '+' + packageInfo.buildNumber,
          "unsyncedReceipts": unsyncedReceipts,
          "unsyncedShifts": unsyncedShifts,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "text/event-stream",
          },
          responseType: ResponseType.stream,
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to connect: ${response.statusCode}");
      }

      final stream = response.data.stream as Stream<List<int>>;

      stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            (String line) {
              if (line.startsWith('data: ')) {
                final dataString = line.substring(6).trim();
                if (dataString == '[DONE]') {
                  _finalizeMessage();
                  return;
                }
                
                try {
                  final data = jsonDecode(dataString);
                  if (data['error'] != null) {
                    currentStreamingMessage.value += "\n\n**Error:** ${data['error']}";
                    _finalizeMessage();
                  } else if (data['text'] != null) {
                    currentStreamingMessage.value += data['text'];
                  }
                } catch (e) {
                  // Ignore malformed JSON chunks
                }
              }
            },
            onDone: () {
              if (isWaiting.value) {
                _finalizeMessage();
              }
            },
            onError: (error) {
              currentStreamingMessage.value = "An error occurred: $error";
              _finalizeMessage();
            },
            cancelOnError: true,
          );

    } catch (e) {
      currentStreamingMessage.value = "Error connecting to AI: $e";
      _finalizeMessage();
    }
  }

  void _finalizeMessage() {
    isWaiting.value = false;
    if (currentStreamingMessage.value.isNotEmpty) {
      String finalMsg = currentStreamingMessage.value;
      
      if (finalMsg.contains('[SYNC_LOCAL_DATA]')) {
        finalMsg = finalMsg.replaceAll('[SYNC_LOCAL_DATA]', '').trim();
        if (Get.isRegistered<ItemsController>()) {
          final itemsController = Get.find<ItemsController>();
          itemsController.updateUnsyncedReceits();
          itemsController.syncAllShifts();
        }
      }

      messages.add({
        "role": "assistant",
        "content": finalMsg,
      });
      currentStreamingMessage.value = "";
    }
  }

  void clearChat() {
    messages.clear();
    currentStreamingMessage.value = "";
    isWaiting.value = false;
  }
}
