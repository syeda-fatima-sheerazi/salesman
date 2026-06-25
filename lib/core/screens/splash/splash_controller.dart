import 'package:get/get.dart';
import 'package:practices/core/routes/route_names.dart';
import 'dart:async';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    gotoSignUp();
  }

  void gotoSignUp() {
    Timer(const Duration(seconds: 5), () {
      Get.toNamed(Routes.signup); 
    });
  }
}
