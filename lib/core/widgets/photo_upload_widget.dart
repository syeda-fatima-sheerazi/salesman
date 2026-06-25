import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practices/core/themes/app_theme.dart';

class PhotoUploadWidget extends StatelessWidget {
  final File? photo;
  final VoidCallback onCapture;
  final String title;
  final String subtitle;
  final String buttonText;
  final IconData placeholderIcon;
  final double size;

  const PhotoUploadWidget({
    super.key,
    required this.photo,
    required this.onCapture,
    this.title = 'Photo',
    this.subtitle = 'Add a clear photo for better identification.',
    this.buttonText = 'Capture Photo',
    this.placeholderIcon = Icons.camera_alt,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: size.w,
              height: size.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  width: 2,
                ),
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
              ),
              child: () {
                if (photo != null) {
                  return ClipOval(
                    child: Image.file(
                      photo!,
                      fit: BoxFit.cover,
                    ),
                  );
                }
                return Icon(
                  placeholderIcon,
                  size: (size * 0.45).w,
                  color: AppTheme.primaryColor,
                );
              }(),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onCapture,
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 18.w,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 38.h,
                child: OutlinedButton.icon(
                  onPressed: onCapture,
                  icon: Icon(
                    Icons.camera_alt,
                    size: 18.w,
                    color: AppTheme.primaryColor,
                  ),
                  label: Text(
                    buttonText,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.primaryColor,
                      fontSize: 13.sp,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
