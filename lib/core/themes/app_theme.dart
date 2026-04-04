import 'package:flutter/material.dart';
import 'package:practices/core/themes/dark_theme.dart';
import 'package:practices/core/themes/light_theme.dart';

class AppTheme {
  // Teal color from screenshot UI
  static const Color primaryColor = Color(0xFF4A8B9F);
  static const Color secondaryColor = Color(0xFFE8E8E8);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardBackgroundColor = Color(0xFFE8E8E8);

  static ThemeData light = LightTheme.light;
  static ThemeData dark = DarkTheme.dark;
}
