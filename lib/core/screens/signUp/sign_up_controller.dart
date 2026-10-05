import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_man/core/dialogs/app_result_dialog.dart';
import 'package:sales_man/core/enums/app_dialog_variant.dart';
import 'package:sales_man/core/routes/route_names.dart';
import 'package:sales_man/core/services/auth_service.dart';
import 'package:sales_man/core/services/auth_exception.dart';
import 'package:sales_man/core/services/snackbar/app_snackbar_service.dart';
import 'package:sales_man/core/utils/app_validators.dart';

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
      final user = await AuthService.instance.signUpWithEmail(
        name: fullNameController.text.trim(),
        email: email,
        password: passwordController.text,
      );

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
    } on AuthException catch (e) {
      AppSnackbarService.error(e.message);
    } catch (e) {
      AppSnackbarService.error('Failed to create account. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void login() {
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    fullNameError.value = '';
    Get.toNamed(Routes.login);
  }

  Future<void> signUpWithGoogle() async {
    try {
      final user = await AuthService.instance.signInWithGoogle();
      if (user == null) return;
      Get.offAllNamed(Routes.dashboard, arguments: user);
    } on AuthException catch (e) {
      AppSnackbarService.error(e.message, title: 'Google Sign-In failed');
    } catch (e) {
      AppSnackbarService.error('Google Sign-In failed: $e');
    }
  }
}
