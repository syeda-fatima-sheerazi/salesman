import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practices/core/enums/app_dialog_variant.dart';

/// Preset styles for [AppResultDialog].
/// Icon, title, message, optional circular progress, and optional primary button.
/// Use [AppResultDialog.show] from any screen (GetX).
///
/// [circularIcon] and [showPrimaryButton] are **mutually exclusive**:
/// when the circular progress is shown, the primary button is not, and vice versa.
/// If both are `true`, only the circular progress is shown.
///
/// Set [showPrimaryButton] to `false` when the dialog is closed by code / timeout
/// (e.g. auto-dismiss) and no OK button is needed.

class AppResultDialog extends StatelessWidget {
  const AppResultDialog({
    super.key,
    required this.title,
    required this.message,
    this.variant = AppDialogVariant.info,
    this.icon,
    this.showPrimaryButton = false,
    this.primaryLabel = 'OK',
    this.onPrimary,
    this.width = 280,
    this.circularIcon = false,
  });

  final String title;
  final String message;
  final AppDialogVariant variant;
  final IconData? icon;

  /// When `false`, no bottom button is shown — dismiss with [Get.back] from outside.
  final bool showPrimaryButton;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final double width;
  final bool circularIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final IconData resolvedIcon;
    final Color iconColor;
    final Color titleColor;
    final Color buttonBg;
    final Color buttonFg;

    final showCircular = circularIcon;
    final showButton = showPrimaryButton && !circularIcon;

    switch (variant) {
      case AppDialogVariant.success:
        resolvedIcon = icon ?? Icons.check_circle;
        iconColor = cs.primary;
        titleColor = cs.primary;
        buttonBg = cs.primary;
        buttonFg = cs.onPrimary;
      case AppDialogVariant.error:
        resolvedIcon = icon ?? Icons.error;
        iconColor = cs.error;
        titleColor = cs.error;
        buttonBg = cs.error;
        buttonFg = cs.onError;
      case AppDialogVariant.info:
        resolvedIcon = icon ?? Icons.info_outline;
        iconColor = cs.primary;
        titleColor = cs.primary;
        buttonBg = cs.primary;
        buttonFg = cs.onPrimary;
    }

    return Center(
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color:
              theme.dialogTheme.backgroundColor ??
              theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 18, spreadRadius: 1),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(resolvedIcon, color: iconColor, size: 48),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(color: titleColor),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            if (showCircular) ...[
              const SizedBox(height: 18),
              CircularProgressIndicator(color: cs.primary),
            ],
            if (showButton) ...[
              const SizedBox(height: 18),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: buttonBg,
                  foregroundColor: buttonFg,
                ),
                onPressed: () {
                  if (onPrimary != null) {
                    onPrimary!();
                  } else {
                    Get.back();
                  }
                },
                child: Text(primaryLabel.isEmpty ? 'OK' : primaryLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Shows this dialog via [Get.dialog]. Call from controllers or `context`.
  static Future<T?> show<T>({
    required String title,
    required String message,
    AppDialogVariant variant = AppDialogVariant.info,
    IconData? icon,
    bool showPrimaryButton = true,
    String primaryLabel = 'OK',
    VoidCallback? onPrimary,
    bool barrierDismissible = false,
    double width = 280,
    bool circularIcon = false,
  }) {
    return Get.dialog<T>(
      AppResultDialog(
        title: title,
        message: message,
        variant: variant,
        icon: icon,
        showPrimaryButton: showPrimaryButton,
        primaryLabel: primaryLabel,
        onPrimary: onPrimary,
        width: width,
        circularIcon: circularIcon,
      ),
      barrierDismissible: barrierDismissible,
    );
  }
}
