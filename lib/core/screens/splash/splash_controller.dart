import 'package:get/get.dart';
import 'package:sales_man/core/routes/route_names.dart';
import 'package:sales_man/core/services/auth_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 5));
    final user = AuthService.instance.currentUser;
    if (user != null) {
      Get.offAllNamed(Routes.dashboard, arguments: user);
      return;
    }
    Get.offNamed(Routes.signup);
  }
}
