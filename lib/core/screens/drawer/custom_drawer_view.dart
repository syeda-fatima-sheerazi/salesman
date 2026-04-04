import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/drawer/drawer_controller.dart';
import 'package:practices/core/themes/app_theme.dart';
import 'package:practices/core/widgets/drawer_item.dart';

class CustomDrawerView extends StatelessWidget {
  const CustomDrawerView({super.key});

  static const _headerOnGradient = Colors.white;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final drawerController = Get.put(CustomDrawerController());

    return Drawer(
      width: 0.75.sw,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Brand header (teal gradient — same on light & dark)
            DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryDark,
                    AppTheme.primaryColor,
                    AppTheme.primaryLight,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 100.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _headerOnGradient,
                            border: Border.all(
                              color: _headerOnGradient,
                              width: 3.w,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.22),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Obx(() {
                              final user = drawerController.currentUser.value;
                              if (user?.avatarUrl != null) {
                                return Image.network(
                                  user!.avatarUrl!,
                                  fit: BoxFit.cover,
                                );
                              }
                              return Icon(
                                Icons.person,
                                size: 50.sp,
                                color: AppTheme.primaryColor,
                              );
                            }),
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Obx(() {
                        final user = drawerController.currentUser.value;
                        return Text(
                          user?.name ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: _headerOnGradient,
                          ),
                        );
                      }),
                      SizedBox(height: 6.h),
                      Obx(() {
                        final user = drawerController.currentUser.value;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                user?.email ?? '',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: _headerOnGradient.withValues(
                                    alpha: 0.88,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.edit_outlined,
                                color: _headerOnGradient.withValues(
                                  alpha: 0.95,
                                ),
                                size: 18.sp,
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),

            // Menu sheet — follows theme surface (light white / dark elevated)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28.r)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.35 : 0.07,
                      ),
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
                            icon: Icons.storefront_rounded,
                            title: 'My Shops',
                            onTap: () => Get.back(),
                          ),
                          DrawerItem(
                            icon: Icons.shopping_cart_outlined,
                            title: 'Orders',
                            onTap: () => Get.back(),
                          ),
                          DrawerItem(
                            icon: Icons.inventory_2_outlined,
                            title: 'Products',
                            onTap: () => Get.back(),
                          ),
                          DrawerItem(
                            icon: Icons.calendar_today_outlined,
                            title: 'Meetings',
                            onTap: () => Get.back(),
                          ),
                          DrawerItem(
                            icon: Icons.pie_chart_outline_rounded,
                            title: 'Sales Reports',
                            onTap: () => Get.back(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.h),
                            child: Divider(
                              indent: 20.w,
                              endIndent: 20.w,
                              height: 1,
                              color: theme.dividerTheme.color ??
                                  cs.outlineVariant,
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
                            iconColor: cs.onSurfaceVariant,
                            textColor: cs.onSurface,
                            onTap: () => Get.back(),
                          ),
                          DrawerItem(
                            icon: Icons.power_settings_new_rounded,
                            title: 'Logout',
                            iconColor: cs.error,
                            textColor: cs.error,
                            onTap: () {
                              Get.back();
                              drawerController.logout();
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color:
                          theme.dividerTheme.color ?? cs.outlineVariant,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      child: Obx(
                        () => Text(
                          'App Version ${drawerController.appVersion.value}',
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
            ),
          ],
        ),
      ),
    );
  }
}
