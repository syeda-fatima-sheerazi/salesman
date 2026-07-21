import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_man/core/routes/route_names.dart';
import 'package:sales_man/core/screens/home/home_view.dart';
import 'package:sales_man/core/screens/products/products_view.dart';
import 'package:sales_man/core/screens/analytics/analytics_view.dart';
import 'package:sales_man/core/screens/todo/todo_view.dart';

class DashboardController extends GetxController {
  final RxInt currentIndex = 0.obs;
  void changeTab(int index) {
    currentIndex.value = index;
    update();
  }

  List<Widget> tabs = [HomeView(), ProductsView(), TodoView(), AnalyticsView()];

  void gotoNotifications() {
    Get.toNamed(Routes.notifications);
  }
}

