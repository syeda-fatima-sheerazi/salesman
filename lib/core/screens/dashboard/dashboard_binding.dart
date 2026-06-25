import 'package:get/get.dart';
import 'package:practices/core/screens/dashboard/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DashboardController>(DashboardController());
  }
}
