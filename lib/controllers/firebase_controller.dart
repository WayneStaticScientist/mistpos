import 'dart:developer';

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/models/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mistpos/firebase-messanging/firebase_topics_subscription.dart';
import 'package:mistpos/firebase-messanging/firebase_bg_notification_handler.dart';

class FirebaseController extends GetxController {
  RxInt notificationSize = RxInt(0);
  RxList<NotificationModel> notifications = RxList([]);
  @override
  void onInit() {
    GetStorage storage = GetStorage();
    notificationSize.value = storage.read("notifications") ?? 0;
    initUser();
    super.onInit();
  }

  @override
  void dispose() {
    GetStorage storage = GetStorage();
    storage.write("notifications", notificationSize);
    super.dispose();
  }

  void readModel(NotificationModel model) async {
    if (model.read) return;
    model.read = true;
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    await isar.writeTxn(() async {
      await isar.notificationModels.put(model);
    });
    int index = notifications.indexWhere((e) => e.id == model.id);
    if (index >= 0) {
      notifications[index] = model;
      notifications.refresh();
    }
  }

  void listAllNotifications({String search = ""}) async {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    final notifyAsync = await isar.notificationModels
        .filter()
        .titleContains(search, caseSensitive: false)
        .or()
        .messageContains(search, caseSensitive: false)
        .findAll();
    notifications.assignAll(notifyAsync);
  }

  void deleteAllNotifications() async {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }

    int count = 0;
    await isar.writeTxn(() async {
      count = await isar.notificationModels.where().deleteAll();
    });
    notifications.clear();
    Toaster.showSuccess("deleted $count notifications");
  }

  void initUser() async {
    final user = User.fromStorage();
    if (user == null) {
      return;
    }
    if (!user.subscriptions.contains(user.company)) {
      if (await joinTopic(user.company)) {
        user.subscriptions.add(user.company);
      }
    }
    if (!user.subscriptions.contains("inventory_${user.company}")) {
      if (user.permissions.contains("inventory-*") ||
          user.role.toLowerCase() == "admin") {
        if (await joinTopic("inventory_${user.company}")) {
          user.subscriptions.add("inventory_${user.company}");
          User.saveToStorage(user);
          log("User is ${user.toMap()}");
        }
      }
    } else {
      user.subscriptions.remove("inventory_${user.company}");
      await leaveTopic("inventory_${user.company}");
    }
    await initFirebase();
  }

  Future<void> initFirebase() async {
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
      listAllNotifications();
    } catch (_) {
      log("errror sssssssss");
    }
  }

  void showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      final String smallIcon = android.smallIcon ?? '@mipmap/ic_launcher';
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
            icon: smallIcon,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }
}
