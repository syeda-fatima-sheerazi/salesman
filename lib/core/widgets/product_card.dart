import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practices/core/screens/products/widgets/add_variant_button.dart';
import 'package:practices/core/utils/product_image_provider.dart';
import 'package:practices/core/widgets/product_variant_item.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.productName,
    required this.productImage,
    required this.variants,
    this.onAddVariant,
    this.onEditVariant,
    this.onDeleteVariant,
  });

  final String productName;
  final String productImage;
  final List<Map<String, String>> variants;
  final void Function()? onAddVariant;
  final void Function(int index)? onEditVariant;
  final void Function(int index)? onDeleteVariant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Product Header with name and image
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
            ),
            child: Row(
              children: [
                // Product Image
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(4.r),
                    image: DecorationImage(
                      image: productImageProvider(productImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Product Name
                Text(
                  productName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          // Variants List
          ...variants.asMap().entries.map((entry) {
            final index = entry.key;
            final variant = entry.value;
            return ProductVariantItem(
              weight: variant['weight'] ?? '',
              price: variant['price'] ?? '',
              // Agar onEditVariant null nahi hai to edit button ko enabled kia jayega (yani onEdit callback assign hoga),
              // warna null hoga to edit button disabled ho jayega (ya kuch bhi nahi hoga):
              onEdit: onEditVariant != null
                  ? () => onEditVariant!(index)
                  : null,
              onDelete: onDeleteVariant != null
                  ? () => onDeleteVariant!(index)
                  : null,
            );
          }),
          AddVariantButton(onTap: onAddVariant),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
