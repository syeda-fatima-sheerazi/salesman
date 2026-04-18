import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsSearchBar extends StatelessWidget {
  const ProductsSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
    this.hintText = 'Search products...',
  });

  final TextEditingController controller;
  final void Function(String)? onChanged;
  final VoidCallback? onClear;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final hasText = controller.text.isNotEmpty;

        return Container(
          height: 45.h,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: cs.outlineVariant.withValues(alpha: isDark ? 0.7 : 0.35),
            ),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => FocusScope.of(context).unfocus(),// when user press search button, the focus is removed from the text field
            style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface),
            cursorColor: cs.primary,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: cs.onSurfaceVariant,
                size: 22.sp,
              ),
              suffixIcon: hasText
                  ? IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: cs.onSurfaceVariant,
                        size: 20.sp,
                      ),
                      onPressed: onClear ?? () => controller.clear(),
                      tooltip: 'Clear',
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 12.h,
              ),
            ),
          ),
        );
      },
    );
  }
}
