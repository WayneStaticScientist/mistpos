import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/models/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mistpos/firebase-messanging/firebase_topics_subscription.dart';
import 'package:mistpos/firebase-messanging/firebase_bg_notification_handler.dart';

class FirebaseController extends GetxController {
  RxInt notificationSize = RxInt(0);
  @override
  void onInit() {
    GetStorage storage = GetStorage();
    notificationSize.value = storage.read("notifications") ?? 0;
    super.onInit();
  }

  @override
  void dispose() {
    GetStorage storage = GetStorage();
    storage.write("notifications", notificationSize);
    super.dispose();
  }

  void initUser() async {
    final user = User.fromStorage();
    if (user == null) {
      return;
    }
    if (!user.subscriptions.contains(user.company)) {
      await joinTopic(user.companyName);
    }
    if (!user.subscriptions.contains("inventory_${user.company}")) {
      if (user.permissions.contains("inventory-*") ||
          user.role.toLowerCase() == "admin") {
        await joinTopic("inventory_${user.company}");
        User.saveToStorage(user);
      }
    } else {
      await leaveTopic("inventory_${user.company}");
    }
  }

  Future<void> initFirebase(String storedToken) async {
    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    await fcm.requestPermission(alert: true, badge: true, sound: true);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      addFirebaseMessage(message);
    });
  }

  Future<void> addFirebaseMessage(RemoteMessage message) async {
    try {
      final isar = Isar.getInstance();
      if (isar == null) {
        return;
      }

      final model = NotificationModel(
        title: message.notification?.title ?? "-",
        message: message.notification?.body ?? 'no message body',
        updatedAt: DateTime.now(),
      );
      await isar.writeTxn(() async {
        isar.notificationModels.put(model);
      });
      notificationSize.value = notificationSize.value + 1;
      showLocalNotification(message);
    } catch (_) {}
  }

  void showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode, // Unique ID for the notification
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            icon: android.smallIcon,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }
}
