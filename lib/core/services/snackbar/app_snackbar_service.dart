import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Predefined snackbar types with consistent styling across the app.
enum SnackbarType { success, error, warning, info }

/// A reusable snackbar service that provides consistent styling
/// and easy-to-use methods for showing different types of snackbars.
class AppSnackbarService {
  AppSnackbarService._(); // Private constructor to prevent instantiation

  /// Default duration for snackbars
  static const Duration defaultDuration = Duration(seconds: 3);

  /// Longer duration for important messages
  static const Duration longDuration = Duration(seconds: 4);

  /// Shows a snackbar with the specified type and message.
  static void show({
    required String title,
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration? duration,
    SnackPosition position = SnackPosition.BOTTOM,
    EdgeInsets? margin,
  }) {
    final (backgroundColor, colorText) = _getColors(type);

    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor,
      colorText: colorText,
      duration: duration ?? defaultDuration,
      margin: margin ?? const EdgeInsets.all(12),
    );
  }

  /// Shows a success snackbar (green).
  static void success(
    String message, {
    String title = 'Success',
    Duration? duration,
    SnackPosition position = SnackPosition.BOTTOM,
    EdgeInsets? margin,
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.success,
      duration: duration,
      position: position,
      margin: margin,
    );
  }

  /// Shows an error snackbar (red).
  static void error(
    String message, {
    String title = 'Error',
    Duration? duration,
    SnackPosition position = SnackPosition.BOTTOM,
    EdgeInsets? margin,
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.error,
      duration: duration,
      position: position,
      margin: margin,
    );
  }

  /// Shows a warning snackbar (orange).
  static void warning(
    String message, {
    String title = 'Warning',
    Duration? duration,
    SnackPosition position = SnackPosition.BOTTOM,
    EdgeInsets? margin,
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.warning,
      duration: duration,
      position: position,
      margin: margin,
    );
  }

  /// Shows an info snackbar (blue).
  static void info(
    String message, {
    String title = 'Info',
    Duration? duration,
    SnackPosition position = SnackPosition.BOTTOM,
    EdgeInsets? margin,
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.info,
      duration: duration,
      position: position,
      margin: margin,
    );
  }

  /// Gets the appropriate colors for each snackbar type.
  static (Color background, Color text) _getColors(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return (
          Colors.green.withValues(alpha: 0.1),
          Colors.green,
        );
      case SnackbarType.error:
        return (
          Colors.red.withValues(alpha: 0.1),
          Colors.red,
        );
      case SnackbarType.warning:
        return (
          Colors.orange.withValues(alpha: 0.1),
          Colors.orange,
        );
      case SnackbarType.info:
        return (
          Colors.blue.withValues(alpha: 0.1),
          Colors.blue,
        );
    }
  }
}
