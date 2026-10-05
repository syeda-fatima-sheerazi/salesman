import 'package:get/get.dart';
import 'package:sales_man/core/models/user_model.dart';
import 'package:sales_man/core/routes/route_names.dart';
import 'package:sales_man/core/services/auth_service.dart';

class CustomDrawerController extends GetxController {
  UserModel? get currentUser => AuthService.instance.currentUser;

  Future<void> logout() async {
    await AuthService.instance.signOut();
    Get.offAllNamed(Routes.login);
  }
}

