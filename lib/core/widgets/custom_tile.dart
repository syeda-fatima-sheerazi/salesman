import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({
    super.key,
    required this.cs,
    required this.text,
    required this.theme,
    required this.icon,
  });

  final IconData icon;

  final ColorScheme cs;
  final String text;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: cs.onSurfaceVariant, size: 20.h),
        SizedBox(width: 4.w),

        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

