// In lib/services/tls_service.dart or similar
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:mistpos/utils/sdk_int.dart'; // Assuming this function exists

class TlsService {
  static const MethodChannel _channel = MethodChannel(
    'com.mistpos/ttls_security',
  );
  static bool _isTlsProviderInstalled = false;

  static Future<void> ensureTlsProviderIsInstalled() async {
    if (_isTlsProviderInstalled ||
        !Platform.isAndroid ||
        await getAndroidSdkInt() >= 24) {
      return; // Already done, not Android, or new enough Android version (>= N)
    }

    try {
      // Call the native method to install the provider
      final bool? success = await _channel.invokeMethod('installProvider');

      if (success == true) {
        _isTlsProviderInstalled = true;
        print("TLS Provider successfully installed/verified.");
      } else {
        // This case handles a non-recoverable native error
        print("TLS Provider failed installation (non-recoverable).");
      }
    } on PlatformException catch (e) {
      // This catches the 'RECOVERABLE_ERROR' or 'FATAL_ERROR' from Kotlin
      if (e.code == "RECOVERABLE_ERROR") {
        // Log or show a message to the user asking them to check Play Services
        print(
          "TLS Provider update needed, follow on-screen prompt (Play Services).",
        );
      } else {
        print("Error installing TLS Provider: ${e.message}");
      }
      // CRITICAL: Even if it failed, we must proceed as it was the best attempt.
      _isTlsProviderInstalled = true;
    }
  }
}
