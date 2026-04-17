import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:practices/core/dialogs/app_result_dialog.dart';
import 'package:practices/core/enums/app_dialog_variant.dart';
import 'package:practices/core/screens/dashboard/dashboard_view.dart';
import 'package:practices/core/screens/signUp/sign_up_view.dart';
import 'package:practices/core/services/remember_login_storage.dart';
import 'package:practices/core/utils/app_validators.dart';

class LoginController extends GetxController {
  bool _googleSignInInitialized = false;
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

    // Validate mobile number
    final emailErr = AppValidators.emailError(emailController.text);
    if (emailErr != null) {
      emailError.value = emailErr;
      isValid = false;
    } else {
      emailError.value = '';
    }

    // Validate password
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
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      Get.offAll(() => const DashboardView());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to login. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void forgotPassword() {
    // TODO: Navigate to forgot password screen
    Get.toNamed('/forgot-password');
  }

  void signUp() {
    emailError.value = '';
    passwordError.value = '';
    Get.to(() => const SignUpView());
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    await GoogleSignIn.instance.initialize();
    _googleSignInInitialized = true;
  }

  /// Interactive Google Sign-In. Configure OAuth client IDs in Google Cloud /
  /// Firebase for release builds (see `google_sign_in` README).
  Future<void> loginWithGoogle() async {
    if (isLoading.value) return;

    try {
      await _ensureGoogleSignInInitialized();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not start Google Sign-In. Check app configuration.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        Get.snackbar(
          'Not supported',
          'Google Sign-In is not available on this platform.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final GoogleSignInAccount account = await GoogleSignIn.instance
          .authenticate(scopeHint: const <String>['email', 'profile']);

      final String? idToken = account.authentication.idToken;
      debugPrint(
        'Google sign-in: ${account.email} (idToken: ${idToken != null})',
      );

      // TODO: Send idToken to your backend for session creation.
      Get.offAll(() => const DashboardView());
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted) {
        return;
      }
      Get.snackbar(
        'Google Sign-In failed',
        e.description ?? e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Google Sign-In failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void signInWithGoogle() {
    loginWithGoogle();
  }
}
