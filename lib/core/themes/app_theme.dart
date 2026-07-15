import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(255, 20, 89, 180),
      secondary: Colors.orange,
      surface: Color.fromARGB(255, 245, 245, 245),
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

  static Color color(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? Colors.white
      : Colors.black;

  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? const Color.fromARGB(255, 55, 55, 55).withAlpha(100)
      : Colors.white;
}
