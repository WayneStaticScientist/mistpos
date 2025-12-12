import 'package:flutter/services.dart';

class UrlLauncherService {
  // Use the new channel name defined in the Kotlin file!
  static const MethodChannel _channel = MethodChannel(
    'com.mistpos/url_launcher',
  );

  /// Invokes the native code to launch a URL.
  static Future<void> launchUrl(String url) async {
    try {
      // Use the method name 'launchUrl' which is checked in the Kotlin file.
      await _channel.invokeMethod('launchUrl', {'url': url});
    } catch (e) {
      rethrow;
      // You can show a user-friendly error dialog here
    }
  }
}
