import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({
    super.key,
    this.onSurfaceVariantColor,
    required this.text,
    required this.icon,
  });

  final IconData icon;
  final Color? onSurfaceVariantColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: onSurfaceVariantColor ?? cs.onSurfaceVariant,
          size: 20.h,
        ),
        SizedBox(width: 4.w),

        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: onSurfaceVariantColor ?? cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
