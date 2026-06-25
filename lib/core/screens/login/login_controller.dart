import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:practices/core/routes/route_names.dart';
import 'package:practices/core/utils/app_validators.dart';
import 'package:practices/core/services/snackbar/app_snackbar_service.dart';
import 'package:practices/core/models/user_model.dart';

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

      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: emailController.text.split('@').first,
        email: emailController.text.trim(),
      );
      Get.offAllNamed(Routes.dashboard, arguments: user);
    } catch (e) {
      AppSnackbarService.error('Failed to login. Please try again.');
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
    Get.toNamed(Routes.signup);
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
      AppSnackbarService.error(
        'Could not start Google Sign-In. Check app configuration.',
      );
      return;
    }

    isLoading.value = true;
    try {
      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        AppSnackbarService.warning(
          'Google Sign-In is not available on this platform.',
          title: 'Not supported',
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
      final user = UserModel(
        id: account.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: account.displayName ?? account.email.split('@').first,
        email: account.email,
      );
      Get.offAllNamed(Routes.dashboard, arguments: user);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted) {
        return;
      }
      AppSnackbarService.error(
        e.description ?? e.toString(),
        title: 'Google Sign-In failed',
      );
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
