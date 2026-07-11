import 'package:isar_plus/isar_plus.dart';
import 'package:mistpos/main.dart';

part 'system_log.g.dart';

@collection
class SystemLog {
  late int id = IdGen.id;
  
  final String actionType;
  final String description;
  final String appVersion;
  final String? userId;
  final String? deviceId;
  final DateTime occurredAt;
  final String? metadata;
  bool syncedToServer;

  SystemLog({
    required this.actionType,
    required this.description,
    required this.appVersion,
    this.userId,
    this.deviceId,
    required this.occurredAt,
    this.metadata,
    this.syncedToServer = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'actionType': actionType,
      'description': description,
      'appVersion': appVersion,
      'userId': userId,
      'deviceId': deviceId,
      'occurredAt': occurredAt.toIso8601String(),
      'metadata': metadata,
    };
  }
}
