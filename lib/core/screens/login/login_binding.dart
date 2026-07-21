import 'package:get/get.dart';
import 'package:sales_man/core/screens/login/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController());
  }
}

