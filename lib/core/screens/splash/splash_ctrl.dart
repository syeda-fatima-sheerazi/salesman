import 'package:get/get.dart';
import 'dart:async';

import 'package:practices/core/screens/signUp/sign_up_view.dart';

class SplashCtrl extends GetxController {
  @override
  void onInit() {
    super.onInit();
    gotoSignUp();
  }

  void gotoSignUp() {
    Timer(const Duration(seconds: 8), () {
      Get.off(() => const SignUpView()); // navigate to login after 3 seconds
    });
  }
}
