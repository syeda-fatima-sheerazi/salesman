import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/models/product_model.dart';
import 'package:practices/core/screens/place_order/select_product/select_product_controller.dart';
import 'package:practices/core/themes/app_theme.dart';

class SelectProductView extends GetView<SelectProductController> {
  const SelectProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Products'),
        centerTitle: true,
        actions: [
          Obx(() {
            if (controller.totalSelected > 0) {
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '${controller.totalSelected}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search product by name or code',
                prefixIcon: Icon(Icons.search, size: 20.sp),
                suffixIcon: Obx(
                  () => controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          onPressed: controller.clearSearch,
                          icon: Icon(Icons.clear, size: 20.sp),
                        )
                      : const SizedBox.shrink(),
                ),
                filled: true,
                fillColor: cs.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: cs.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: cs.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: cs.primary),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),

          // Product list
          Expanded(
            child: Obx(() {
              final list = controller.filteredProducts;
              if (list.isEmpty) {
                return Center(
                  child: Text(
                    controller.searchQuery.value.isNotEmpty
                        ? 'No products match your search'
                        : 'No products available',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: list.length,
                separatorBuilder: (_, i) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final product = list[index];
                  return _ProductInlineTile(
                    product: product,
                    controller: controller,
                  );
                },
              );
            }),
          ),

          // Bottom bar
          Obx(
            () => Container(
              padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 16.w + MediaQuery.of(context).viewPadding.bottom),
              decoration: BoxDecoration(
                color: cs.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: AppTheme.primaryColor,
                    size: 24.sp,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${controller.selectedCount} Items Selected',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Total: Rs ${controller.totalAmount}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: controller.selectedCount > 0
                          ? controller.confirmSelection
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Done (${controller.selectedCount})',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductInlineTile extends StatelessWidget {
  const _ProductInlineTile({required this.product, required this.controller});

  final ProductModel product;
  final SelectProductController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          // Product header with image
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: Image.asset(
                  product.imageUrl,
                  width: 40.w,
                  height: 40.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 20.sp,
                      color: cs.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Variants
          SizedBox(height: 8.h),
          ...product.variants.map((variant) {
            return _VariantInlineRow(
              product: product,
              variant: variant,
              controller: controller,
            );
          }),
        ],
      ),
    );
  }
}

class _VariantInlineRow extends StatelessWidget {
  const _VariantInlineRow({
    required this.product,
    required this.variant,
    required this.controller,
  });

  final ProductModel product;
  final ProductVariantModel variant;
  final SelectProductController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      // Find if this variant is already selected
      final existingIndex = controller.tempSelectedItems.indexWhere(
        (i) => i.productId == product.id && i.variant == variant.weight,
      );
      final qty = existingIndex >= 0
          ? controller.tempSelectedItems[existingIndex].qty
          : 0;

      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            // Variant info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    variant.weight,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Rs ${variant.numericPrice.toInt()}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity controls (always visible)
            if (qty > 0) ...[
              _CircleButton(
                icon: Icons.remove,
                onTap: () {
                  if (existingIndex >= 0) {
                    controller.decrementTempItem(existingIndex);
                  }
                },
                color: cs.outlineVariant,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  '$qty',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            _CircleButton(
              icon: Icons.add,
              onTap: () {
                controller.addProductToSelection(product, variant);
              },
              color: qty > 0 ? AppTheme.primaryColor : cs.primaryContainer,
            ),
          ],
        ),
      );
    });
  }

  ColorScheme get cs => Get.theme.colorScheme;
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, size: 16.sp, color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}
