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
            title: Text("Sales Man"),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
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
                icon: Icon(Icons.task_alt),
                label: "Today",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.signal_cellular_alt),
                label: "Statement",
              ),
            ],
          ),
        );
      },
    );
  }
}
