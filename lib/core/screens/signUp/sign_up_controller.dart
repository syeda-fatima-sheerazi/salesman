import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practices/core/dialogs/app_result_dialog.dart';
import 'package:practices/core/enums/app_dialog_variant.dart';
import 'package:practices/core/screens/dashboard/dashboard_view.dart';
import 'package:practices/core/screens/login/login_view.dart';
import 'package:practices/core/utils/app_validators.dart';

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
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual signup logic here
      // For now, just navigate to login
      Get.to(() => const DashboardView());

      await AppResultDialog.show(
        title: 'Success',
        message: 'Account created successfully!',
        variant: AppDialogVariant.success,
      );
    } catch (e) {
      await AppResultDialog.show(
        title: 'Error',
        message: 'Failed to create account. Please try again.',
        variant: AppDialogVariant.error,
      );
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
    Get.to(() => const LoginView());
  }

  void signUpWithGoogle() {
    // TODO: Implement Google Sign Up
  }
}
