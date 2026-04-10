import 'package:flutter/material.dart';

/// Reusable empty-state widget that shows an icon and a message.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.text,
    this.iconSize = 48.0,
    this.spacing = 12.0,
    this.textStyle,
    this.iconColor,
  });

  final IconData icon;
  final Color? iconColor;
  final String text;
  final double iconSize;
  final double spacing;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final effectiveTextStyle = textStyle ?? theme.textTheme.bodyLarge;
    final color = iconColor ?? cs.onSurfaceVariant;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(icon, size: iconSize, color: color),
        SizedBox(height: spacing),
        Text(text, style: effectiveTextStyle),
      ],
    );
  }
}
