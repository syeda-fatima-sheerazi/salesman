import 'package:get/get.dart';
import 'package:practices/core/models/user_model.dart';

class CustomDrawerController extends GetxController {
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxString appVersion = '1.0.3'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyUser();
  }

  void _loadDummyUser() {
    currentUser.value = UserModel(
      id: '1',
      name: 'Asad Khan',
      email: 'asad@example.com',
      avatarUrl: null,
    );
  }

  void updateUserProfile(String name, String email) {
    if (currentUser.value != null) {
      currentUser.value = UserModel(
        id: currentUser.value!.id,
        name: name,
        email: email,
        avatarUrl: currentUser.value!.avatarUrl,
      );
    }
  }

  void logout() {
    // Clear user data and navigate to login
    currentUser.value = null;
    // Get.offAllNamed('/login');
  }
}
