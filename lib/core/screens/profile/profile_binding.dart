import 'package:get/get.dart';
import 'package:sales_man/core/screens/profile/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProfileController>(ProfileController());
  }
}

