import 'package:get/get.dart';
import 'package:sales_man/core/screens/signUp/sign_up_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SignUpController>(SignUpController());
  }
}

