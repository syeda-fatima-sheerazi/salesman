import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Ek row: weight + price text fields (theme / ScreenUtil).
class VariantFieldsRow extends StatelessWidget {
  const VariantFieldsRow({
    super.key,
    required this.weightController,
    required this.priceController,
    this.onAnyChange,
  });

  final TextEditingController weightController;
  final TextEditingController priceController;
  final ValueChanged<String>? onAnyChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: cs.outlineVariant),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: weightController,
            onChanged: onAnyChange,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface,
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              hintText: 'Weight',
              filled: true,
              fillColor: cs.surface,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
              enabledBorder: border,
              focusedBorder: border.copyWith(
                borderSide: BorderSide(color: cs.primary, width: 1.2),
              ),
              hintStyle: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: TextField(
            controller: priceController,
            onChanged: onAnyChange,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface,
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              hintText: 'Price',
              filled: true,
              fillColor: cs.surface,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
              enabledBorder: border,
              focusedBorder: border.copyWith(
                borderSide: BorderSide(color: cs.primary, width: 1.2),
              ),
              hintStyle: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
