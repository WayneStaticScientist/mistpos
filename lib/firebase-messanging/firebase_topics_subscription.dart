import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> joinTopic(String groupId) async {
  try {
    await FirebaseMessaging.instance.subscribeToTopic(groupId);
  } catch (e) {
    rethrow;
  }
}

Future<void> leaveTopic(String groupId) async {
  try {
    await FirebaseMessaging.instance.unsubscribeFromTopic(groupId);
  } catch (e) {
    rethrow;
  }
}
