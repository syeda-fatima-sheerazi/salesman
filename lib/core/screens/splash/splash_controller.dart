import 'package:get/get.dart';
import 'package:sales_man/core/routes/route_names.dart';
import 'package:sales_man/core/services/database_service.dart';
import 'package:sales_man/core/services/session_service.dart';
import 'dart:async';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 5));
    final email = await SessionService.instance.getSavedEmail();
    if (email != null) {
      final user = await DatabaseService.instance.getUserByEmail(email);
      if (user != null) {
        Get.offAllNamed(Routes.dashboard, arguments: user);
        return;
      }
      SessionService.instance.clearSession();
    }
    Get.offNamed(Routes.signup);
  }
}

