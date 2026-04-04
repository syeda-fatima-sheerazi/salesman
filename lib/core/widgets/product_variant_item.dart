import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductVariantItem extends StatelessWidget {
  const ProductVariantItem({
    super.key,
    required this.weight,
    required this.price,
    this.onEdit,
    this.onDelete,
  });

  final String weight;
  final String price;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 45.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Weight text
          Expanded(
            flex: 2,
            child: Text(
              weight,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                color: Colors.black87,
              ),
            ),
          ),
          // Price text
          Expanded(
            flex: 2,
            child: Text(
              price,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                color: Colors.black87,
              ),
            ),
          ),
          // Edit button
          GestureDetector(
            onTap: onEdit,
            child: Container(
              width: 35.w,
              height: 35.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Icon(
                Icons.edit,
                size: 18.sp,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // Delete button
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 35.w,
              height: 35.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
              ),
              child: Icon(
                Icons.delete_outline,
                size: 18.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
