import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';

class Toaster {
  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      icon: Iconify(Bx.error, color: Colors.white),
      duration: const Duration(seconds: 1),
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      icon: Iconify(Bx.check_circle, color: Colors.white),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
