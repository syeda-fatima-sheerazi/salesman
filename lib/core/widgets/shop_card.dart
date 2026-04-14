import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practices/core/models/shop.dart';
import 'package:practices/core/widgets/custom_tile.dart';

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
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Container(
                    height: 60.h,
                    width: 60.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: cs.surfaceContainerLow,
                      image: DecorationImage(
                        image: shop.shopImagUrl.startsWith('http')
                            ? NetworkImage(shop.shopImagUrl)
                            : AssetImage(shop.shopImagUrl),
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

                      CustomTile(
                        text: shop.shopOwner,
                        icon: Icons.person,
                      ),
                      SizedBox(height: 2.h),

                      CustomTile(
                        text: shop.cellPhone,
                        icon: Icons.phone,
                      ),
                      SizedBox(height: 2.h),
                      CustomTile(
                        text: shop.address,
                        icon: Icons.place_outlined,
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
                      label: shop.isVisited
                          ? Text(
                              'Visited',
                              style: TextStyle(color: cs.outlineVariant),
                            )
                          : Text(
                              'Pending',
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
