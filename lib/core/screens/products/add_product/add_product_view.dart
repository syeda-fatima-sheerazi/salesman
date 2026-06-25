import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/products/add_product/add_product_controller.dart';
import 'package:practices/core/screens/products/widgets/variant_fields_row.dart';

/// Add product — name, required image, variants (≥1 complete row), save to [ProductController].
class AddProductView extends GetView<AddProductController> {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: cs.outlineVariant),
    );

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop && Get.isRegistered<AddProductController>()) {
          Get.delete<AddProductController>();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Product',
            style: theme.textTheme.titleMedium?.copyWith(
              color: cs.onPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.h),
                Text(
                  'Product name',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => TextField(
                    controller: controller.productNameController,
                    onChanged: controller.onProductNameChanged,
                    textCapitalization: TextCapitalization.words,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: cs.onSurface,
                      fontSize: 15.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter product name',
                      filled: true,
                      fillColor: cs.surface,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      enabledBorder: fieldBorder,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: cs.primary, width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: cs.error, width: 1.2),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: cs.error, width: 1.5),
                      ),
                      errorText: controller.nameErrorMessage.value.isEmpty
                          ? null
                          : controller.nameErrorMessage.value,
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant.withValues(alpha: 0.85),
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Product image',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(() {
                  final String? path = controller.pickedImagePath.value;
                  final String imageErr = controller.imageErrorMessage.value;
                  final bool hasImageErr = imageErr.isNotEmpty;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => controller.pickProductImageFromGallery(),
                          borderRadius: BorderRadius.circular(12.r),
                          child: Ink(
                            height: 200.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: path == null
                                  ? cs.surfaceContainerLow
                                  : null,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: hasImageErr
                                    ? cs.error
                                    : cs.outlineVariant,
                                width: hasImageErr ? 2 : 1.5,
                              ),
                              image: path != null
                                  ? DecorationImage(
                                      image: FileImage(File(path)),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: path == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 48.sp,
                                        color: cs.primary.withValues(
                                          alpha: 0.85,
                                        ),
                                      ),
                                      SizedBox(height: 12.h),
                                      Text(
                                        'Add product image',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: cs.onSurfaceVariant,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'Tap to choose from gallery',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: cs.onSurfaceVariant
                                                  .withValues(alpha: 0.8),
                                              fontSize: 12.sp,
                                            ),
                                      ),
                                    ],
                                  )
                                : Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Positioned(
                                        top: 6.h,
                                        right: 6.w,
                                        child: Material(
                                          color: Colors.black54,
                                          shape: const CircleBorder(),
                                          clipBehavior: Clip.antiAlias,
                                          child: IconButton(
                                            visualDensity:
                                                VisualDensity.compact,
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(
                                              minWidth: 32.r,
                                              minHeight: 32.r,
                                            ),
                                            icon: Icon(
                                              Icons.close_rounded,
                                              color: Colors.white,
                                              size: 18.sp,
                                            ),
                                            onPressed:
                                                controller.clearPickedImage,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      if (hasImageErr) ...[
                        SizedBox(height: 6.h),
                        Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Text(
                            imageErr,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.error,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                }),
                SizedBox(height: 24.h),
                Text(
                  'Variants',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Weight and price for each pack / size',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                Obx(() {
                  final int  n = controller.variantRowCount.value;
                  final String variantErr = controller.variantErrorMessage.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int i = 0; i < n; i++) ...[
                        if (i > 0) SizedBox(height: 12.h),
                        VariantFieldsRow(
                          key: ValueKey('variant_$i'),
                          weightController: controller.weightControllerAt(i),
                          priceController: controller.priceControllerAt(i),
                          onAnyChange: controller.onVariantFieldChanged,
                        ),
                      ],
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: controller.canAddMoreVariants
                                ? controller.moreVariants
                                : null,
                            icon: Icon(
                              Icons.add_rounded,
                              size: 18.sp,
                              color: controller.canAddMoreVariants
                                  ? cs.primary
                                  : cs.onSurfaceVariant,
                            ),
                            label: Text(
                              'More variants',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: controller.canAddMoreVariants
                                    ? cs.primary
                                    : cs.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              alignment: Alignment.centerLeft,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          if (controller.canRemoveVariant)
                            TextButton.icon(
                              onPressed: controller.removeLastVariant,
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                size: 18.sp,
                                color: cs.error,
                              ),
                              label: Text(
                                'Delete variant',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: cs.error,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                alignment: Alignment.centerRight,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                        ],
                      ),
                      if (variantErr.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Text(
                            variantErr,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.error,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                }),
                SizedBox(height: 28.h),
                FilledButton(
                  onPressed: controller.saveProduct,
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: Text(
                    'Save',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: cs.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
