import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practices/core/themes/app_theme.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final String? errorText;
  final bool obscureText;
  final bool isVisible;
  final VoidCallback? onVisibilityToggle;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.obscureText = false,
    this.isVisible = true,
    this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = errorText != null && errorText!.isNotEmpty;
    final isPasswordField = obscureText || onVisibilityToggle != null;
    final showText = isPasswordField ? isVisible : true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: !showText,
          keyboardType: keyboardType,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontSize: 14.sp,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            hintText: hintText,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              fontSize: 14.sp,
            ),
            prefixIcon: Icon(
              prefixIcon,
              size: 20.w,
              color: AppTheme.textSecondary,
            ),
            suffixIcon: isPasswordField && onVisibilityToggle != null
                ? GestureDetector(
                    onTap: onVisibilityToggle,
                    child: Icon(
                      showText ? Icons.visibility : Icons.visibility_off,
                      size: 20.w,
                      color: showText
                          ? AppTheme.primaryColor
                          : AppTheme.textSecondary,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 16.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: hasError ? AppTheme.error : Colors.transparent,
                width: 1.w,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: hasError ? AppTheme.error : Colors.transparent,
                width: 1.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: hasError ? AppTheme.error : AppTheme.primaryColor,
                width: 1.w,
              ),
            ),
            errorText: hasError ? errorText : null,
          ),
        ),
      ],
    );
  }
}
