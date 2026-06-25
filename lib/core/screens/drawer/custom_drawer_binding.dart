import 'package:get/get.dart';
import 'package:practices/core/screens/drawer/custom_drawer_controller.dart';

class CustomDrawerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomDrawerController>(() => CustomDrawerController());
  }
}
