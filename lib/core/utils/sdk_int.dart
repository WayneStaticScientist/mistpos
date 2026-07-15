import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

Future<int> getAndroidSdkInt() async {
  if (Platform.isAndroid) {
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      // The sdkInt property provides the API Level (e.g., 23 for Marshmallow, 34 for Android 14)
      return androidInfo.version.sdkInt;
    } catch (e) {
      // Log error if device info could not be retrieved
      log('Error getting Android SDK version: $e');
      return -1;
    }
  }
  // Return a non-Android indicator if not running on Android
  return 0;
}
