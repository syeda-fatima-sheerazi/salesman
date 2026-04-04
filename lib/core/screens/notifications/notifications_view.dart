import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/notifications/notifications_controller.dart';
import 'package:practices/core/widgets/notification_card.dart';
import 'package:practices/core/widgets/products_search_bar.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GetBuilder<NotificationsController>(
      init: NotificationsController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Notifications"),
            centerTitle: true,
            elevation: 0,
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Search Bar Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: const ProductsSearchBar(),
                ),

                // Tab Bar
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainer,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Obx(() => Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.changeTab(0),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: controller.selectedTabIndex.value == 0
                                      ? cs.surfaceContainerHighest
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.r),
                                  boxShadow:
                                      controller.selectedTabIndex.value == 0
                                          ? [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withValues(alpha: 0.08),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                ),
                                child: Center(
                                  child: Text(
                                    'Notifications',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          controller.selectedTabIndex.value == 0
                                              ? cs.onSurface
                                              : cs.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.changeTab(1),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: controller.selectedTabIndex.value == 1
                                      ? cs.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.r),
                                  boxShadow:
                                      controller.selectedTabIndex.value == 1
                                          ? [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withValues(alpha: 0.12),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                ),
                                child: Center(
                                  child: Obx(() => Text(
                                        'New (${controller.unreadCount})',
                                        style:
                                            theme.textTheme.bodyMedium?.copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: controller
                                                      .selectedTabIndex.value ==
                                                  1
                                              ? cs.onPrimary
                                              : cs.onSurfaceVariant,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),

                SizedBox(height: 16.h),

                // Notifications List
                Expanded(
                  child: Obx(() {
                    final notifications = controller.filteredNotifications;

                    if (notifications.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_off_outlined,
                              size: 64.sp,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No notifications',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 16.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return NotificationCard(
                          notification: notification,
                          onTap: () {
                            controller.markAsRead(notification.id);
                          },
                        );
                      },
                    );
                  }),
                ),

                // Mark All as Read Button
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Obx(() => controller.unreadCount.value > 0
                      ? GestureDetector(
                          onTap: () => controller.markAllAsRead(),
                          child: Container(
                            width: double.infinity,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: Text(
                                'Mark All as Read',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: cs.onPrimary,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
