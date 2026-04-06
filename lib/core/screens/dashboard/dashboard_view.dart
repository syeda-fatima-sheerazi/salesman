import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/dashboard/dashboard_controller.dart';
import 'package:practices/core/screens/drawer/custom_drawer_view.dart';
import 'package:practices/core/screens/notifications/notifications_controller.dart';
import 'package:practices/core/themes/app_theme.dart';
import 'package:practices/core/screens/notifications/notifications_view.dart';
import 'package:practices/core/widgets/notification_icon_widget.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize notifications controller for global access
    final notificationsController = Get.put(NotificationsController());

    return GetBuilder<DashboardController>(
      init: DashboardController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("SalesMan"),
            actions: [
              // Notification icon with dynamic badge
              Obx(
                () => NotificationIconWidget(
                  unreadCount: notificationsController.unreadCount.value,
                  onPressed: () {
                    Get.to(() => NotificationsView());
                  },
                ),
              ),
              Builder(
                builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.menu),
                ),
              ),
            ],
          ),
          drawer: CustomDrawerView(),
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: controller.tabs,
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: controller.changeTab,
            currentIndex: controller.currentIndex.value,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                icon: Icon(Icons.view_agenda),
                label: "Products",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: "Today",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: "Statement",
              ),
            ],
          ),
        );
      },
    );
  }
}
