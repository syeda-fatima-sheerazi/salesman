import 'package:flutter/material.dart';
import 'package:practices/core/themes/dark_theme.dart';
import 'package:practices/core/themes/light_theme.dart';

/// SalesMan distribution app — palette aligned with drawer / marketing UI
/// (deep cadet teal header, light grey scaffold, navy menu text).
class AppTheme {
  /// Main brand teal (app bars, buttons, selected nav).
  static const Color primaryColor = Color(0xFF3D6F80);

  /// Gradient / depth (drawer header, hero surfaces).
  static const Color primaryDark = Color(0xFF2D5664);
  static const Color primaryLight = Color(0xFF4F8FA3);

  static const Color secondaryColor = Color(0xFFE8ECEF);
  static const Color backgroundColor = Color(0xFFF2F5F7);
  static const Color cardBackgroundColor = Color(0xFFE8ECEF);

  /// Menu / body text (dark navy-grey).
  static const Color textPrimary = Color(0xFF1E3A42);
  static const Color textSecondary = Color(0xFF5C6B73);

  /// Drawer menu icons (slightly blue-teal, screenshot style).
  static const Color drawerMenuIcon = Color(0xFF2E7D9A);

  static const Color error = Color(0xFFE53935);
  static const Color badgeRed = Color(0xFFE53935);

  static ThemeData light = LightTheme.light;
  static ThemeData dark = DarkTheme.dark;
}

