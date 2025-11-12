import 'package:isar/isar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mistpos/models/notification_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void addMessage(RemoteMessage message) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    Isar? isarInstance = Isar.getInstance();
    isarInstance ??= await Isar.open([
      NotificationModelSchema,
    ], directory: dir.path);
    final model = NotificationModel(
      title: message.notification?.title ?? "-",
      message: message.notification?.body ?? 'no message body',
      updatedAt: DateTime.now(),
    );
    await isarInstance.writeTxn(() async {
      isarInstance?.notificationModels.put(model);
    });
    GetStorage storage = GetStorage();
    int notificationSize = storage.read("notifications") ?? 0;
    storage.write("notifications", notificationSize + 1);
  } catch (_) {}
}

Future<void> initializeLocalNotifications() async {
  // 1. ANDROID NOTIFICATION CHANNEL SETUP (CRITICAL FOR FCM)
  // This channel ID MUST match the 'android_channel_id' used in your FCM message payload.
  // If no 'android_channel_id' is specified in the payload, the 'default' channel is used.
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id - MUST BE UNIQUE
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  // CREATE THE CHANNEL
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  // 2. INITIALIZATION SETTINGS
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  // 3. INITIALIZE PLUGIN
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      // Handle navigation/deep-linking here when user taps a notification
    },
  );

  // 4. FOREGROUND MESSAGE HANDLING (Required to display notifications when app is open)
  // This listens for incoming FCM messages while the app is active.
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = message.notification?.android;

    // If the notification payload is present and we're on Android, show a local notification
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode, // Unique ID for the notification
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id, // Use the same channel ID defined above
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
          ),
        ),
        // Include payload data for tap handling if needed
        payload: message.data.toString(),
      );
    }
    // For Data Messages in foreground, you'd still process 'message.data' here.
  });
}
