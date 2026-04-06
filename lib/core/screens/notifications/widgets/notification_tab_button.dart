import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationTabButton extends StatelessWidget {
  const NotificationTabButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.selectedColor,
    this.selectedTextColor,
  });

  final Widget label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;
  final Color? selectedTextColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final bgColor = isSelected ? (selectedColor ?? cs.surfaceContainerHighest) : Colors.transparent;
    final textColor = isSelected ? (selectedTextColor ?? cs.onSurface) : cs.onSurfaceVariant;
    final boxShadow = isSelected
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ]
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: boxShadow,
        ),
        child: Center(
          child: DefaultTextStyle.merge(
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
            child: label,
          ),
        ),
      ),
    );
  }
}

