import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practices/core/models/order_item.dart';
import 'package:practices/core/themes/app_theme.dart';

class OrderCartItem extends StatelessWidget {
  const OrderCartItem({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final OrderItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final lineTotal = (item.price * item.qty).toInt();

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: Image.asset(
              item.imageUrl ?? 'assets/images/shop.png',
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

          // Name + unit price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Rs ${item.price.toInt()} / Unit',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Quantity controls
          _QuantityControls(
            quantity: item.qty,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
          ),
          SizedBox(width: 8.w),

          // Line total
          Text(
            'Rs $lineTotal',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
          SizedBox(width: 6.w),

          // Delete
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.delete_outline,
              size: 20.sp,
              color: cs.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityControls extends StatelessWidget {
  const _QuantityControls({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CircleButton(
          icon: Icons.remove,
          onTap: onDecrement,
          color: cs.outlineVariant,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            '$quantity',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _CircleButton(
          icon: Icons.add,
          onTap: onIncrement,
          color: cs.primaryContainer,
        ),
      ],
    );
  }
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
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16.sp),
      ),
    );
  }
}
