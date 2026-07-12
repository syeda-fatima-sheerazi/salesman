import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:practices/core/models/shop.dart';

class ShopInfoSection extends StatelessWidget {
  const ShopInfoSection({
    super.key,
    required this.shop,
    required this.orderDate,
  });

  final Shop shop;
  final DateTime orderDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shop Name', style: theme.textTheme.bodyMedium?.copyWith()),
        SizedBox(height: 4.h),
        Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.store,
                size: 18.sp,
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Text(
                shop.shopName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text('Order Date', style: theme.textTheme.bodyMedium?.copyWith()),
        SizedBox(height: 5.h),
        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16.sp,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 8.w),
            Text(
              DateFormat('d MMMM yyyy').format(orderDate),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
