import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsSearchBar extends StatelessWidget {
  const ProductsSearchBar({super.key, this.onChanged});

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: cs.outlineVariant.withOpacity(isDark ? 0.7 : 0.35),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface),
        cursorColor: cs.primary,
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: cs.onSurfaceVariant,
            size: 22.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }
}
