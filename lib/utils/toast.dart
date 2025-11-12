import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class Toaster {
  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
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
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.green,
      colorText: Get.theme.colorScheme.onPrimary,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
