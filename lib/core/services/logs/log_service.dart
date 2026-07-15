import 'dart:developer';

import 'package:isar_plus/isar_plus.dart';
import 'package:mistpos/data/models/system_log.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/services/api/network_wrapper.dart';
import 'package:mistpos/core/services/api/auth_interceptor.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mistpos/main.dart';

class LogService {
  static Future<void> logEvent({
    required String actionType,
    required String description,
    String? metadata,
  }) async {
    try {
      final isar = IsarStatic.getInstance();
      if (isar == null) return;

      final packageInfo = await PackageInfo.fromPlatform();
      final user = User.fromStorage();
      final deviceId = await getDeviceId();

      final log = SystemLog(
        actionType: actionType,
        description: description,
        appVersion: '${packageInfo.version}+${packageInfo.buildNumber}',
        userId: user?.hexId,
        deviceId: deviceId,
        occurredAt: DateTime.now(),
        metadata: metadata,
      );

      await isar.write((isar) async {
        isar.systemLogs.put(log);
      });

      // Attempt to sync immediately
      syncLogs();
    } catch (e) {
      log("Failed to save log: $e");
    }
  }

  static Future<void> syncLogs() async {
    try {
      final isar = IsarStatic.getInstance();
      if (isar == null) return;

      final unsyncedLogs = isar.systemLogs
          .where()
          .syncedToServerEqualTo(false)
          .findAll();

      if (unsyncedLogs.isEmpty) return;

      final payload = unsyncedLogs.map((l) => l.toMap()).toList();

      final response = await Net.post('/logs/sync', data: payload);

      if (!response.hasError) {
        // Mark as synced or delete them
        await isar.write((isar) async {
          // To save space, we can just delete synced logs from local storage
          isar.systemLogs.deleteAll(unsyncedLogs.map((l) => l.id).toList());
        });
      }
    } catch (e) {
      log("Failed to sync logs: $e");
    }
  }
}
