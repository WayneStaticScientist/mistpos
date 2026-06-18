import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mistpos/core/services/api/network_wrapper.dart';
import 'package:mistpos/data/models/token_model.dart';

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
      
      final dio = Dio();
      final response = await dio.post(
        '${Net.baseUrl}/ai/client-chat',
        data: {
          "messages": messages.map((m) => {
            "role": m['role'],
            "content": m['content']
          }).toList(),
          "clientDate": DateTime.now().toIso8601String(),
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
      messages.add({
        "role": "assistant",
        "content": currentStreamingMessage.value,
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
