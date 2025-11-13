import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<bool> joinTopic(String groupId) async {
  try {
    await FirebaseMessaging.instance.subscribeToTopic(groupId);
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> leaveTopic(String groupId) async {
  try {
    await FirebaseMessaging.instance.unsubscribeFromTopic(groupId);
    return true;
  } catch (e) {
    log("FCM Topic Uns Subscription Error: $e");

    return false;
  }
}
