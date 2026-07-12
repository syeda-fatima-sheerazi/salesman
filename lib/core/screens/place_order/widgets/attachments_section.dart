import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:practices/core/themes/app_theme.dart';

class AttachmentsSection extends StatelessWidget {
  const AttachmentsSection({
    super.key,
    required this.attachments,
    required this.onAdd,
    required this.onRemove,
  });

  final RxList<String> attachments;
  final ValueChanged<String> onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachments',
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 8.h),

        // Action buttons
        Row(
          children: [
            _ActionButton(
              icon: Icons.camera_alt_outlined,
              label: 'Camera',
              onTap: () => _pickImage(context, ImageSource.camera),
            ),
            SizedBox(width: 12.w),
            _ActionButton(
              icon: Icons.photo_library_outlined,
              label: 'Gallery',
              onTap: () => _pickImage(context, ImageSource.gallery),
            ),
          ],
        ),

        // Thumbnails row
        Obx(() {
          if (attachments.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: SizedBox(
              height: 70.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: attachments.length,
                separatorBuilder: (_, _) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: Image.file(
                          File(attachments[index]),
                          width: 60.w,
                          height: 60.w,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 60.w,
                            height: 60.w,
                            decoration: BoxDecoration(
                              color: cs.errorContainer,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: cs.error,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => onRemove(index),
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: cs.error,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 12.sp,
                              color: cs.onError,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (image == null) return;

      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          'order_${DateTime.now().millisecondsSinceEpoch}${p.extension(image.path)}';
      final savedImage = await File(image.path).copy('${appDir.path}/$fileName');

      onAdd(savedImage.path);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: cs.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: cs.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18.sp, color: AppTheme.primaryColor),
            SizedBox(width: 6.w),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
