import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.green,
      ),
      headlineSmall: TextStyle(fontSize: 14, color: Colors.red),
      bodyLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
  );
}
