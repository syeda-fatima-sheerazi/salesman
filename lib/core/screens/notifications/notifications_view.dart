import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/notifications/notifications_controller.dart';
import 'package:practices/core/widgets/notification_card.dart';
import 'package:practices/core/widgets/products_search_bar.dart';
import 'package:practices/core/screens/notifications/widgets/notification_tab_button.dart';
import 'package:practices/core/screens/notifications/widgets/mark_all_read_button.dart';

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
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: ProductsSearchBar(
                    controller: controller.searchFieldController,
                    hintText: 'Search notifications...',
                    onChanged: controller.onSearchQueryChanged,
                    onClear: controller.clearSearch,
                  ),
                ),

                // Tab Bar
                Obx(() {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainer,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: NotificationTabButton(
                            label: const Text('Notifications'),
                            isSelected: controller.selectedTabIndex.value == 0,
                            onTap: () => controller.changeTab(0),
                          ),
                        ),
                        Expanded(
                          child: NotificationTabButton(
                            label: Text('New (${controller.unreadCount.value})'),
                            isSelected: controller.selectedTabIndex.value == 1,
                            onTap: () => controller.changeTab(1),
                            selectedColor: cs.primary,
                            selectedTextColor: cs.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

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
                  child: Obx(
                    () => controller.unreadCount.value > 0
                        ? MarkAllReadButton(
                            onTap: () => controller.markAllAsRead(),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
