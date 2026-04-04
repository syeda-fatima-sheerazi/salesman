import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/dashboard/dashboard_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      init: DashboardController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text("SalesMan"),
            actions: [
              // Notification icon with badge
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.notifications_outlined),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
            ],
          ),
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
              BottomNavigationBarItem(
                icon: Icon(Icons.cloud_upload),
                label: "Backup",
              ),
            ],
          ),
        );
      },
    );
  }
}
