import 'package:get/get.dart';
import 'package:practices/core/screens/dashboard/dashboard_controller.dart';
import 'package:practices/core/screens/home/home_controller.dart';
import 'package:practices/core/screens/notifications/notifications_controller.dart';
import 'package:practices/core/screens/products/product_controller.dart';
import 'package:practices/core/screens/analytics/analytics_controller.dart';
import 'package:practices/core/screens/todo/todo_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DashboardController>(DashboardController());
    Get.lazyPut<NotificationsController>(() => NotificationsController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<TodoController>(() => TodoController());
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<AnalyticsController>(() => AnalyticsController());
  }
}
