import 'package:flutter/material.dart';
import 'package:practices/core/themes/app_theme.dart';
import 'package:practices/core/themes/app_typography.dart';

class DarkTheme {
  static ColorScheme get _scheme {
    return ColorScheme.fromSeed(
      seedColor: AppTheme.primaryLight,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppTheme.primaryLight,
      onPrimary: const Color(0xFF0D1518),
      primaryContainer: const Color(0xFF2A4A56),
      onPrimaryContainer: const Color(0xFFBFD8E3),
      surface: const Color(0xFF0F1418),
      onSurface: const Color(0xFFE8EEF2),
      onSurfaceVariant: const Color(0xFFA8B6C0),
      surfaceContainerLowest: const Color(0xFF0C1014),
      surfaceContainerLow: const Color(0xFF12181E),
      surfaceContainer: const Color(0xFF171E25),
      surfaceContainerHigh: const Color(0xFF1C252D),
      surfaceContainerHighest: const Color(0xFF232D37),
      outline: const Color(0xFF3D4D5A),
      outlineVariant: const Color(0xFF2A3540),
      error: AppTheme.error,
      onError: Colors.white,
    );
  }

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: AppTypography.fontFamily,
    colorScheme: _scheme,

    scaffoldBackgroundColor: _scheme.surface,

    textTheme: TextTheme(
      displayLarge: AppTypography.apply(
        TextStyle(
          color: _scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      titleLarge: AppTypography.apply(
        TextStyle(
          color: _scheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),
      ),
      titleMedium: AppTypography.apply(
        TextStyle(
          color: _scheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      titleSmall: AppTypography.apply(
        TextStyle(
          color: _scheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      bodyLarge: AppTypography.apply(
        TextStyle(
          color: _scheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      bodyMedium: AppTypography.apply(
        TextStyle(
          color: _scheme.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      bodySmall: AppTypography.apply(
        TextStyle(
          color: _scheme.onSurfaceVariant,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
      labelLarge: AppTypography.apply(
        TextStyle(
          color: _scheme.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      labelMedium: AppTypography.apply(
        TextStyle(
          color: _scheme.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      labelSmall: AppTypography.apply(
        TextStyle(
          color: _scheme.onSurfaceVariant,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: _scheme.surfaceContainerHigh,
      foregroundColor: _scheme.onSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTypography.apply(
        TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w600,
          color: _scheme.onSurface,
        ),
      ),
      iconTheme: IconThemeData(color: _scheme.onSurface),
    ),

    cardTheme: CardThemeData(
      color: _scheme.surfaceContainerHigh,
      elevation: 0,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _scheme.outlineVariant.withValues(alpha: .55)),
      ),
    ),

    dividerTheme: DividerThemeData(color: _scheme.outlineVariant, thickness: 1),

    dividerColor: _scheme.outlineVariant,

    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          _scheme.surfaceContainerHighest,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _scheme.surfaceContainerHigh,
      hintStyle: AppTypography.apply(
        TextStyle(color: _scheme.onSurfaceVariant),
      ),
      labelStyle: AppTypography.apply(
        TextStyle(color: _scheme.onSurfaceVariant),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _scheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _scheme.outlineVariant),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        maximumSize: const Size(double.infinity, 50),
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _scheme.surfaceContainerHigh,
      selectedItemColor: AppTheme.primaryLight,
      unselectedItemColor: _scheme.onSurfaceVariant,
      selectedLabelStyle: AppTypography.apply(
        const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      unselectedLabelStyle: AppTypography.apply(
        const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 12,
    ),

    listTileTheme: ListTileThemeData(
      iconColor: _scheme.primary,
      textColor: _scheme.onSurface,
    ),

    iconTheme: IconThemeData(color: _scheme.onSurfaceVariant),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppTheme.primaryLight,
    ),
  );
}
