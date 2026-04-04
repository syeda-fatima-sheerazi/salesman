import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/backup/backup_view.dart';
import 'package:practices/core/screens/home/home_view.dart';
import 'package:practices/core/screens/products/products_view.dart';
import 'package:practices/core/screens/statement/statement_view.dart';
import 'package:practices/core/screens/today/views/today_order_view.dart';

class DashboardController extends GetxController {
  final RxInt currentIndex = 0.obs;
  void changeTab(int index) {
    currentIndex.value = index;
    update();
  }

  List<Widget> tabs = [
    HomeView(),
    ProductsView(),
    TodayOrderView(),
    StatementView(),
    BackupView(),
  ];
}
