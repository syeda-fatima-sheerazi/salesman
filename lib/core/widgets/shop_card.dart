import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practices/core/models/shop.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({super.key, this.onTap, required this.shop});

  final void Function()? onTap;
  final Shop shop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: cs.surfaceContainerHigh,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.6)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: cs.surfaceContainerLow,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        'https://img.freepik.com/premium-vector/shops-stores-icons-set-flat-design-style-vector-illustration_498048-1862.jpg?semt=ais_hybrid&w=740&q=80',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.shopName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),

                      Text(
                        'Owner : ${shop.shopOwner}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 2.h),

                      Text(
                        'Cell : ${shop.cellPhone}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        'Address : ${shop.address}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.h),
                child: Column(
                  children: [
                    Chip(
                      avatar: Icon(
                        shop.isVisited ? Icons.done : Icons.close,
                        size: 18,
                        color: cs.outlineVariant,
                      ),
                      label: shop.isVisited
                          ? Text(
                              'Visited',
                              style: TextStyle(color: cs.outlineVariant),
                            )
                          : Text(
                              'Not Visited',
                              style: TextStyle(color: cs.outlineVariant),
                            ),
                      backgroundColor: shop.isVisited
                          ? Colors.green.shade600
                          : cs.error,
                    ),

                    Tooltip(
                      message: 'Go to the shop',
                      child: Icon(Icons.location_on, color: cs.primary),
                      onTriggered: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
