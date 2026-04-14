import 'package:get/get.dart';
import 'dart:async';

class SplashCtrl extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToHome();
  }

  void _navigateToHome() {
    Timer(const Duration(seconds: 3), () {
      Get.offAllNamed('/login'); // navigate to login after 3 seconds
    });
  }
}
