import 'package:isar/isar.dart';
part 'notification_model.g.dart';

@collection
class NotificationModel {
  Id id = Isar.autoIncrement;
  String title;
  String message;
  DateTime updatedAt;
  NotificationModel({
    required this.title,
    required this.message,
    required this.updatedAt,
  });
}
