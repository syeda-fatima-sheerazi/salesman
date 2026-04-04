import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practices/core/widgets/product_variant_item.dart';
import 'package:practices/core/widgets/add_variant_button.dart';

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
  final VoidCallback? onAddVariant;
  final Function(int index)? onEditVariant;
  final Function(int index)? onDeleteVariant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(8.r),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                    image: DecorationImage(
                      image: NetworkImage(productImage),
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
              onEdit: onEditVariant != null ? () => onEditVariant!(index) : null,
              onDelete: onDeleteVariant != null
                  ? () => onDeleteVariant!(index)
                  : null,
            );
          }),
          // Add Variant Button
          AddVariantButton(onTap: onAddVariant),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
