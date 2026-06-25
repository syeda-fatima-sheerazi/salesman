import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practices/core/models/shop.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({
    super.key,
    this.cardOnTap,
    this.visitedOnTap,
    required this.shop,
  });

  final void Function()? cardOnTap;
  final void Function()? visitedOnTap;
  final Shop shop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: cardOnTap,
      child: Card(
        color: cs.surface,

        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: cs.onSurfaceVariant.withValues(alpha: 0.2)),
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

                      Text(
                        shop.shopOwner,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
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
                    TextButton(
                      onPressed: visitedOnTap,
                      style: TextButton.styleFrom(
                        backgroundColor: shop.isVisited
                            ? Colors.green.shade600
                            : cs.error,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 4,
                        ),
                        // minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                      child: Text(
                        shop.isVisited ? 'Visited' : 'Pending',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
