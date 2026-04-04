import 'package:get/get.dart';
import 'dart:async';

class SplashCtrl extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToHome();
  }

  void _navigateToHome() {
    Timer(Duration(seconds: 3), () {
      Get.offNamed('/home'); // navigate to home after 3 seconds
    });
  }
}