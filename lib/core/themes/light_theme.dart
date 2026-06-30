import 'package:flutter/material.dart';
import 'package:practices/core/themes/app_theme.dart';
import 'package:practices/core/themes/app_typography.dart';

class LightTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    fontFamily: AppTypography.fontFamily,
    colorScheme: ColorScheme.light(
      primary: AppTheme.primaryColor,
      onPrimary: Colors.white,

      primaryContainer: AppTheme.primaryLight.withValues(alpha: 0.22),
      onPrimaryContainer: AppTheme.textPrimary,
      secondary: AppTheme.secondaryColor,
      onSecondary: AppTheme.textPrimary,
      surface: Colors.white,
      onSurface: AppTheme.textPrimary,
      onSurfaceVariant: AppTheme.textSecondary,
      error: AppTheme.error,
      onError: Colors.white,
      outline: const Color(0xFFD0D8DC),
      outlineVariant: const Color(0xFFE8ECEF),
    ),

    scaffoldBackgroundColor: AppTheme.backgroundColor,

    textTheme: TextTheme(
      titleLarge: AppTypography.apply(
        const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
          letterSpacing: -0.3,
        ),
      ),
      titleMedium: AppTypography.apply(
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      bodyLarge: AppTypography.apply(
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimary,
        ),
      ),
      bodyMedium: AppTypography.apply(
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      bodySmall: AppTypography.apply(
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppTheme.textSecondary,
        ),
      ),
      labelLarge: AppTypography.apply(
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white),

    appBarTheme: AppBarTheme(
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTypography.apply(
        const TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.2,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    dividerTheme: const DividerThemeData(
      color: AppTheme.textPrimary,
      thickness: 1,
      space: 1,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        maximumSize: const Size(double.infinity, 50),
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: AppTheme.textSecondary,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppTheme.primaryColor,
    ),

    //
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white, // ye icon/text color control karega
      elevation: 8,
      focusElevation: 6,
      hoverElevation: 10,
      highlightElevation: 12,
      iconSize: 30,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
