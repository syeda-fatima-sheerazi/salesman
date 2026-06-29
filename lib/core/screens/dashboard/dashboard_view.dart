import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practices/core/models/user_model.dart';
import 'package:practices/core/screens/dashboard/dashboard_controller.dart';
import 'package:practices/core/screens/drawer/custom_drawer_view.dart';
import 'package:practices/core/screens/notifications/notifications_controller.dart';
import 'package:practices/core/widgets/notification_icon_widget.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    // Initialize notifications controller for global access
    final notificationsController = Get.find<NotificationsController>();
    final dashboardController = Get.find<DashboardController>();
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
                dashboardController.gotoNotifications();
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
      drawer: CustomDrawerView(user: user),
      body: Obx(() {
        return IndexedStack(
          index: dashboardController.currentIndex.value,
          children: dashboardController.tabs,
        );
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: dashboardController.changeTab,
          currentIndex: dashboardController.currentIndex.value,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_agenda),
              label: "Products",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "Todo",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: "Analytics",
            ),
          ],
        );
      }),
    );
  }
}
