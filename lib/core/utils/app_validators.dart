import 'package:practices/core/enums/app_validation_kind.dart';

/// Shared validation helpers for use across screens (sign up, login, add shop, etc.).
class AppValidators {
  AppValidators._();

  // --- Full name ---

  static String? fullNameError(String name, {int minLength = 3}) {
    final t = name.trim();
    if (t.isEmpty) return 'Please enter your full name';
    if (t.length < minLength) {
      return 'Name must be at least $minLength characters';
    }
    return null;
  }

  // --- Email ---

  static final RegExp _emailRegex = RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,}$');

  static bool isValidEmail(String email) {
    final e = email.trim();
    if (e.isEmpty) return false;
    return _emailRegex.hasMatch(e);
  }

  static String? emailError(String email) {
    final e = email.trim();
    if (e.isEmpty) return 'Please enter your email address';
    if (!isValidEmail(e)) return 'Please enter a valid email address';
    return null;
  }

  // --- Password ---

  static final RegExp _strongPasswordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{6,}$',
  );

  static bool isValidPassword(
    String password, {
    int minLength = 6,
    bool requireStrong = true,
  }) {
    if (password.isEmpty) return false;
    if (password.length < minLength) return false;
    if (requireStrong) return _strongPasswordRegex.hasMatch(password);
    return true;
  }

  static String? passwordError(
    String password, {
    int minLength = 6,
    bool requireStrong = true,
  }) {
    if (password.isEmpty) return 'Please enter a password';
    if (password.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    if (requireStrong && !_strongPasswordRegex.hasMatch(password)) {
      return 'Please enter a strong password (uppercase, lowercase, number, special char)';
    }
    return null;
  }

  static String? confirmPasswordError(String password, String confirm) {
    if (confirm.isEmpty) return 'Please confirm your password';
    if (password != confirm) return 'Passwords do not match';
    return null;
  }

  // --- Phone (Pakistan-style: 03XXXXXXXXX or +923XXXXXXXXX) ---

  static final RegExp _pkPhoneRegex = RegExp(r'^(\+92|0)?3\d{9}$');

  static bool isValidPkPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\s|-'), '');
    if (digits.isEmpty) return false;
    return _pkPhoneRegex.hasMatch(digits);
  }

  static String? pkPhoneError(String phone) {
    final digits = phone.replaceAll(RegExp(r'\s|-'), '');
    if (digits.isEmpty) return 'Please enter your phone number';
    if (!isValidPkPhone(phone)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Single entry point for simple checks (e.g. `if (AppValidators.matches(...))`).
  static bool matches(AppValidationKind kind, String value, {String? other}) {
    switch (kind) {
      case AppValidationKind.email:
        return isValidEmail(value);
      case AppValidationKind.password:
        return isValidPassword(value);
      case AppValidationKind.confirmPassword:
        return other != null && value == other;
      case AppValidationKind.pkPhone:
        return isValidPkPhone(value);
    }
  }
}
