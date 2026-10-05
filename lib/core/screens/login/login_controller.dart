import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_man/core/routes/route_names.dart';
import 'package:sales_man/core/services/auth_service.dart';
import 'package:sales_man/core/services/auth_exception.dart';
import 'package:sales_man/core/services/snackbar/app_snackbar_service.dart';
import 'package:sales_man/core/utils/app_validators.dart';

class LoginController extends GetxController {
  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable states
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;

  // Error states
  final emailError = RxString('');
  final passwordError = RxString('');

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  bool _validateFields() {
    bool isValid = true;

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

    return isValid;
  }

  Future<void> login() async {
    if (!_validateFields()) return;

    isLoading.value = true;

    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      final user = await AuthService.instance.signInWithEmail(
        email: email,
        password: password,
      );
      Get.offAllNamed(Routes.dashboard, arguments: user);
    } on AuthException catch (e) {
      AppSnackbarService.error(e.message);
    } catch (e) {
      AppSnackbarService.error('Failed to login. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      AppSnackbarService.warning('Please enter your email address first.');
      return;
    }
    try {
      await AuthService.instance.sendPasswordResetEmail(email: email);
      AppSnackbarService.success('Password reset email sent to $email');
    } on AuthException catch (e) {
      AppSnackbarService.error(e.message);
    } catch (e) {
      AppSnackbarService.error('Failed to send reset email.');
    }
  }

  void signUp() {
    emailError.value = '';
    passwordError.value = '';
    Get.toNamed(Routes.signup);
  }

  Future<void> loginWithGoogle() async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      final user = await AuthService.instance.signInWithGoogle();
      if (user == null) return;
      Get.offAllNamed(Routes.dashboard, arguments: user);
    } on AuthException catch (e) {
      AppSnackbarService.error(e.message, title: 'Google Sign-In failed');
    } catch (e) {
      AppSnackbarService.error('Google Sign-In failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void signInWithGoogle() {
    loginWithGoogle();
  }
}
