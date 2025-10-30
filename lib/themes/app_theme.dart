import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(255, 20, 89, 180),
      secondary: Colors.orange,
      surface: Color.fromARGB(248, 255, 255, 255),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 20, 89, 180),
      secondary: Colors.orange,
      surface: Color.fromARGB(255, 16, 16, 16),
    ),
  );

  static var color = Get.isDarkMode ? Colors.white : Colors.black;

  static var surface = Get.isDarkMode
      ? const Color.fromARGB(255, 55, 55, 55).withAlpha(100)
      : Colors.white;
}
