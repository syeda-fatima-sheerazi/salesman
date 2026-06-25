import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared row for Todo Orders & Collections: shop image, name, subtitle line
/// (prefix + bold value), primary Chip + underlined link text below (Edit / View).
class ToDoCard extends StatelessWidget {
  const ToDoCard({
    super.key,
    required this.shopName,
    required this.image,
    required this.subtitle,
    required this.subtitleValue,
    required this.isCompleted,
    required this.inCompletedText,
    required this.completedText,
    required this.onTap,
    required this.onTrailingTap,
    required this.trailingLabel,
    required this.trailingTooltip,
    required this.theme,
    required this.cs,
  });

  final String shopName;
  final String image;

  /// e.g. `Qty ` or `Collecting `
  final String subtitle;

  /// Bold segment (quantity number or `Rs …`).
  final String subtitleValue;

  /// `true` → show completed chip (Delivered / Paid).
  final bool isCompleted;

  /// Tappable chip when not complete (Pending / Collect).
  final String inCompletedText;
  final String completedText;
  final VoidCallback? onTap;
  final VoidCallback onTrailingTap;
  final String trailingLabel;
  final String trailingTooltip;
  final ThemeData theme;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cs.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _ShopThumb(assetPath: image, cs: cs),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    shopName,
                    style: theme.textTheme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),

                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: subtitle,
                          style: theme.textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: subtitleValue,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: onTap,
                    child: Chip(
                      label: Text(
                        isCompleted ? completedText : inCompletedText,
                        style: TextStyle(color: cs.outlineVariant),
                      ),

                      backgroundColor: isCompleted
                          ? Colors.green.shade600
                          : cs.primary,
                    ),
                  ),

                  SizedBox(height: 4.h),
                  Tooltip(
                    message: trailingTooltip,
                    child: InkWell(
                      onTap: onTrailingTap,
                      borderRadius: BorderRadius.circular(6.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 6.h,
                        ),
                        child: Text(
                          trailingLabel,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: cs.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: cs.primary.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopThumb extends StatelessWidget {
  const _ShopThumb({required this.assetPath, required this.cs});

  final String assetPath;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: SizedBox(
        width: 52.w,
        height: 52.w,
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => ColoredBox(
            color: cs.surfaceContainerHighest,
            child: Icon(
              Icons.storefront_rounded,
              color: cs.primary,
              size: 26.sp,
            ),
          ),
        ),
      ),
    );
  }
}
