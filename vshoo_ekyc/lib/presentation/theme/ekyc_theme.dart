import 'package:flutter/material.dart';

class EkycTheme {
  static const Color primary = Color(0xFF1565C0);
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFC62828);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;

  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        useMaterial3: true,
      );
}
