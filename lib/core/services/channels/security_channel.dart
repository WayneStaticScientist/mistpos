import 'dart:developer';

import 'package:flutter/services.dart';

class SecurityProviderService {
  static const MethodChannel _channel = MethodChannel(
    'com.mistpos/ttls_security',
  );

  Future<void> updateSecurityProvider() async {
    try {
      await _channel.invokeMethod('installProvider');
    } on PlatformException catch (e) {
      log("Failed to install security provider: '${e.message}'.");
    }
  }
}
