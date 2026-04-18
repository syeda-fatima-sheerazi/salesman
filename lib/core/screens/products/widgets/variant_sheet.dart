import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/models/product_model.dart';
import 'package:practices/core/screens/products/product_controller.dart';
import 'package:practices/core/screens/products/widgets/variant_sheet_controller.dart';

/// Floating card — add or edit variant ([StatelessWidget] + [VariantSheetController]).
class VariantSheet extends StatelessWidget {
  const VariantSheet({super.key, required this.controllerTag});

  final String controllerTag;

  static ProductModel? _productById(ProductController pc, String id) {
    try {
      return pc.products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// [variantIndex] null = add; non-null = edit existing row (prefilled).
  static void show(
    BuildContext context,
    String productId, {
    int? variantIndex,
  }) {
    final pc = Get.find<ProductController>();
    String? iw;
    String? ip;
    if (variantIndex != null) {
      final product = _productById(pc, productId);
      if (product != null &&
          variantIndex >= 0 &&
          variantIndex < product.variants.length) {
        final v = product.variants[variantIndex];
        iw = v.weight;
        ip = v.price;
      }
    }

    final sheetCtrl = VariantSheetController(
      productId: productId,
      productController: pc,
      variantIndex: variantIndex,
      initialWeight: iw,
      initialPrice: ip,
    );
    Get.put(sheetCtrl, tag: sheetCtrl.tag);

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.32),
      useRootNavigator: true,
      builder: (dialogContext) {
        final screenW = MediaQuery.sizeOf(dialogContext).width;
        final maxW = math.min(380.0, screenW - 28.0);
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(dialogContext).bottom,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxW),
              child: VariantSheet(controllerTag: sheetCtrl.tag),
            ),
          ),
        );
      },
    ).whenComplete(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.isRegistered<VariantSheetController>(tag: sheetCtrl.tag)) {
          Get.delete<VariantSheetController>(tag: sheetCtrl.tag);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<VariantSheetController>(tag: controllerTag);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: cs.outlineVariant),
    );

    final title = c.isEdit ? 'Edit Variant' : 'Add Variant';
    final actionLabel = c.isEdit ? 'Update' : 'Add';

    return Card(
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      color: cs.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.65)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 17.sp,
                color: cs.onSurface,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: c.weightController,
              textInputAction: TextInputAction.next,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: cs.onSurface,
                fontSize: 15.sp,
              ),
              decoration: InputDecoration(
                labelText: 'Weight',
                hintText: 'e.g. 500g',
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
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.8),
                  fontSize: 14.sp,
                ),
              ),
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: c.priceController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: cs.onSurface,
                fontSize: 15.sp,
              ),
              decoration: InputDecoration(
                labelText: 'Price',
                hintText: 'e.g. Rs 200',
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
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.8),
                  fontSize: 14.sp,
                ),
              ),
              onSubmitted: (_) => c.submit(context),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => c.cancel(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: BorderSide(color: cs.outline),
                      foregroundColor: cs.onSurface,
                    ),
                    child: Text(
                      'Cancel',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: FilledButton(
                    onPressed: () => c.submit(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: Text(
                      actionLabel,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: cs.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
