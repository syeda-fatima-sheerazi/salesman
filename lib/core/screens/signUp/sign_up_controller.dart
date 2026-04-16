import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/login/login_view.dart';

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

    // Validate full name
    if (fullNameController.text.trim().isEmpty) {
      fullNameError.value = 'Please enter your full name';
      isValid = false;
    } else if (fullNameController.text.trim().length < 3) {
      fullNameError.value = 'Name must be at least 3 characters';
      isValid = false;
    } else {
      fullNameError.value = '';
    }

    // Validate email address
    String email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = 'Please enter your email address';
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emailError.value = 'Please enter a valid email address';
      isValid = false;
    } else {
      emailError.value = '';
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Please enter a password';
      isValid = false;
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    } else if (!RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>]).{6,}$',
    ).hasMatch(passwordController.text)) {
      passwordError.value =
          'Please enter a strong password (uppercase, lowercase, number, special char)';
      isValid = false;
    } else {
      passwordError.value = '';
    }

    // Validate confirm password
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      isValid = false;
    } else if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
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
      Get.to(() => const LoginView());

      Get.snackbar(
        'Success',
        'Account created successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create account. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
