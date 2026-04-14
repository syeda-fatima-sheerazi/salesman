import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practices/core/themes/app_theme.dart';

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: const Color(0xFFBDBDBD),
            thickness: 0.5.h,
            indent: 24.w,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
              fontSize: 12.sp,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: const Color(0xFFBDBDBD),
            thickness: 0.5.h,
            endIndent: 24.w,
          ),
        ),
      ],
    );
  }
}
