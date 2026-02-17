import 'package:isar_plus/isar_plus.dart';
import 'package:mistpos/main.dart';
part 'notification_model.g.dart';

@collection
class NotificationModel {
  late int id = IdGen.id;
  String title;
  String message;
  DateTime updatedAt;
  bool read = false;
  NotificationModel({
    this.read = false,
    required this.title,
    required this.message,
    required this.updatedAt,
  });
}
