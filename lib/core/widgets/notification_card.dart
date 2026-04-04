import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practices/core/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  final NotificationModel notification;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: cs.outlineVariant.withOpacity(isDark ? 0.65 : 0.4),
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading Icon
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: notification.iconBackgroundColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                notification.iconData,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: notification.isRead
                          ? FontWeight.normal
                          : FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  if (notification.subtitle.isNotEmpty)
                    SizedBox(height: 4.h),
                  if (notification.subtitle.isNotEmpty)
                    Text(
                      notification.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 13.sp,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),

            // Time and Arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  notification.time,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 8.h),
                Icon(
                  Icons.chevron_right,
                  color: cs.onSurfaceVariant.withOpacity(0.85),
                  size: 20.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
