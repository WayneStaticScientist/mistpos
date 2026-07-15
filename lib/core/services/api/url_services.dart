import 'dart:io';
import 'package:flutter/services.dart';

class UrlLauncherService {
  // Use the new channel name defined in the Kotlin file!
  static const MethodChannel _channel = MethodChannel(
    'com.mistpos/url_launcher',
  );

  /// Invokes the native code or shell command to launch a URL.
  static Future<void> launchUrl(String url) async {
    try {
      if (Platform.isAndroid) {
        // Use the method name 'launchUrl' which is checked in the Kotlin file.
        await _channel.invokeMethod('launchUrl', {'url': url});
      } else if (Platform.isWindows) {
        // Launch URL on Windows using start command in shell
        await Process.run('start', [url], runInShell: true);
      } else if (Platform.isMacOS) {
        // Launch URL on macOS
        await Process.run('open', [url]);
      } else if (Platform.isLinux) {
        // Launch URL on Linux
        await Process.run('xdg-open', [url]);
      } else {
        // Fallback for other platforms
        await _channel.invokeMethod('launchUrl', {'url': url});
      }
    } catch (e) {
      rethrow;
    }
  }
}
