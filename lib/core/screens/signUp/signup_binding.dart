import 'package:get/get.dart';
import 'package:practices/core/screens/signUp/sign_up_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SignUpController>(SignUpController());
  }
}
