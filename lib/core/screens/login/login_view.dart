import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/login/login_controller.dart';
import 'package:practices/core/themes/app_theme.dart';
import 'package:practices/core/widgets/custom_input_field.dart';
import 'package:practices/core/widgets/divider_with_text.dart';
import 'package:practices/core/widgets/social_button.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFE8EDF0),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),

                // Welcome Back text
                Text(
                  'Welcome Back!',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 30.h),

                // Form fields
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      // Mobile Number Field
                      CustomInputField(
                        controller: controller.emailController,
                        hintText: 'Email',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        errorText: controller.emailError,
                      ),
                      SizedBox(height: 16.h),

                      // Password Field
                      CustomInputField(
                        controller: controller.passwordController,
                        hintText: 'Password',
                        prefixIcon: Icons.lock,
                        isVisible: controller.isPasswordVisible,
                        onVisibilityToggle: controller.togglePasswordVisibility,
                        errorText: controller.passwordError,
                      ),
                      SizedBox(height: 12.h),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: controller.forgotPassword,
                          child: Text(
                            'Forgot Password?',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Login Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        onPressed: controller.login,
                        child: Text('Log In'),
                      ),
                      SizedBox(height: 24.h),

                      // Or continue with divider
                      DividerWithText(text: 'Or continue with'),
                      SizedBox(height: 20.h),

                      // Social Login Buttons
                      SocialButton(
                        onTap: () => controller.loginWithGoogle(),
                        icon: 'assets/images/google.png',
                        text: 'Log in with Google',
                      ),
                      SizedBox(height: 32.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          GestureDetector(
                            onTap: controller.signUp,
                            child: Text(
                              'Sign Up',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.primaryColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Sign Up Row
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
