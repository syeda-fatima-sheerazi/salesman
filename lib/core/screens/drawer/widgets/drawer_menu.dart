import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/widgets/drawer_item.dart';

class DrawerMenuWidget extends StatelessWidget {
  const DrawerMenuWidget({super.key, this.onTap, this.title = '1.0.0'});

  final void Function()? onTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.07),
              blurRadius: 18,
              offset: Offset(0, -4.h),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 8.h),
                children: [
                  DrawerItem(
                    icon: Icons.home_rounded,
                    title: 'Home',
                    onTap: () => Get.back(),
                  ),
                  DrawerItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () => Get.back(),
                  ),
                  DrawerItem(
                    icon: Icons.pie_chart_outline_rounded,
                    title: 'BackUp',
                    onTap: () => Get.back(),
                  ),
                  // DrawerItem(
                  //   icon: Icons.inventory_2_outlined,
                  //   title: 'Products',
                  //   onTap: () => Get.back(),
                  // ),
                  // DrawerItem(
                  //   icon: Icons.calendar_today_outlined,
                  //   title: 'Meetings',
                  //   onTap: () => Get.back(),
                  // ),
                  // DrawerItem(
                  //   icon: Icons.pie_chart_outline_rounded,
                  //   title: 'Sales Reports',
                  //   onTap: () => Get.back(),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    child: Divider(
                      indent: 20.w,
                      endIndent: 20.w,
                      height: 1,
                      color: theme.dividerTheme.color ?? cs.outlineVariant,
                    ),
                  ),
                  DrawerItem(
                    icon: Icons.headset_mic_outlined,
                    title: 'Support',
                    onTap: () => Get.back(),
                  ),
                  DrawerItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () => Get.back(),
                  ),
                  DrawerItem(
                    icon: Icons.power_settings_new_rounded,
                    title: 'Logout',
                    iconColor: cs.error,
                    textColor: cs.error,
                    onTap: onTap,
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: theme.dividerTheme.color ?? cs.outlineVariant,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              child: Obx(
                () => Text(
                  'App Version: $title',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
