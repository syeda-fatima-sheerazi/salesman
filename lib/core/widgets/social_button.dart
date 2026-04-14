import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practices/core/themes/app_theme.dart';

class SocialButton extends StatelessWidget {
  final VoidCallback onTap;
  final String icon;
  final String text;

  const SocialButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 44.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: 20.w,
              height: 20.w,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  icon.contains('google') ? Icons.g_mobiledata : Icons.facebook,
                  size: 20.w,
                  color: icon.contains('google') ? Colors.red : Colors.blue,
                );
              },
            ),
            SizedBox(width: 12.w),
            Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
