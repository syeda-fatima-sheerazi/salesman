import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practices/core/dialogs/app_result_dialog.dart';
import 'package:practices/core/enums/app_dialog_variant.dart';
import 'package:practices/core/routes/route_names.dart';
import 'package:practices/core/services/database_service.dart';
import 'package:practices/core/services/session_service.dart';
import 'package:practices/core/services/snackbar/app_snackbar_service.dart';
import 'package:practices/core/utils/app_validators.dart';
import 'package:practices/core/models/user_model.dart';

class SignUpController extends GetxController {
  // Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  // Error states
  final RxString fullNameError = RxString('');
  final RxString emailError = RxString('');
  final RxString passwordError = RxString('');
  final RxString confirmPasswordError = RxString('');

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.toggle();
  }

  bool _validateFields() {
    bool isValid = true;

    final fullNameErr = AppValidators.fullNameError(fullNameController.text);
    if (fullNameErr != null) {
      fullNameError.value = fullNameErr;
      isValid = false;
    } else {
      fullNameError.value = '';
    }

    final emailErr = AppValidators.emailError(emailController.text);
    if (emailErr != null) {
      emailError.value = emailErr;
      isValid = false;
    } else {
      emailError.value = '';
    }

    final passwordErr = AppValidators.passwordError(passwordController.text);
    if (passwordErr != null) {
      passwordError.value = passwordErr;
      isValid = false;
    } else {
      passwordError.value = '';
    }

    final confirmErr = AppValidators.confirmPasswordError(
      passwordController.text,
      confirmPasswordController.text,
    );
    if (confirmErr != null) {
      confirmPasswordError.value = confirmErr;
      isValid = false;
    } else {
      confirmPasswordError.value = '';
    }

    return isValid;
  }

  Future<void> signUp() async {
    if (!_validateFields()) return;

    isLoading.value = true;

    try {
      final email = emailController.text.trim();
      final existing = await DatabaseService.instance.getUserByEmail(email);
      if (existing != null) {
        AppSnackbarService.error(
          'An account with this email already exists.',
        );
        return;
      }

      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: fullNameController.text.trim(),
        email: email,
        password: passwordController.text,
      );

      final success = await DatabaseService.instance.registerUser(user);
      if (!success) {
        AppSnackbarService.error('Failed to create account. Please try again.');
        return;
      }

      await SessionService.instance.saveSession(email);

      AppResultDialog.show(
        title: 'Success',
        message: 'Account created successfully!',
        variant: AppDialogVariant.success,
        showPrimaryButton: false,
      );
      await Future.delayed(const Duration(seconds: 3));
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      Get.offAllNamed(Routes.dashboard, arguments: user);
    } catch (e) {
      AppSnackbarService.error('Failed to create account. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void login() {
    // Navigate to login screen
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    fullNameError.value = '';
    Get.toNamed(Routes.login);
  }

  void signUpWithGoogle() {
    // TODO: Implement Google Sign Up
  }

  void dummySignUp() {
    final email = emailController.text.trim();
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: fullNameController.text.trim(),
      email: email,
      password: passwordController.text,
    );
    DatabaseService.instance.registerUser(user);
    SessionService.instance.saveSession(email);
    Get.offAllNamed(Routes.dashboard, arguments: user);
  }
}
