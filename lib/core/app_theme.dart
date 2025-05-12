import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Colors.deepPurple,
      secondary: Colors.amber,
      surface: Colors.white,
      background: Colors.grey[50]!,
    ),
    useMaterial3: true,
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: Colors.deepPurple[300]!,
      secondary: Colors.amber[200]!,
      surface: Colors.grey[900]!,
      background: Colors.grey[850]!,
    ),
    useMaterial3: true,
  );
}