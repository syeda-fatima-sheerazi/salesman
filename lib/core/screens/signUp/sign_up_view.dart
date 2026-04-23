import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/signUp/sign_up_controller.dart';
import 'package:practices/core/themes/app_theme.dart';
import 'package:practices/core/widgets/custom_input_field.dart';
import 'package:practices/core/widgets/divider_with_text.dart';
import 'package:practices/core/widgets/social_button.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<SignUpController>(
      init: SignUpController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFE8EDF0),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),

                  // Create Your Account text
                  Text(
                    'Create Your Account',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // Form fields
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Obx(() {
                      return Column(
                        children: [
                          // Full Name Field
                          CustomInputField(
                            controller: controller.fullNameController,
                            hintText: 'Full Name',
                            prefixIcon: Icons.person,
                            keyboardType: TextInputType.name,
                            errorText: controller.fullNameError.value.isNotEmpty
                                ? controller.fullNameError.value
                                : null,
                          ),
                          SizedBox(height: 16.h),

                          // Email Field
                          CustomInputField(
                            controller: controller.emailController,
                            hintText: 'Email',
                            prefixIcon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            errorText: controller.emailError.value.isNotEmpty
                                ? controller.emailError.value
                                : null,
                          ),
                          SizedBox(height: 16.h),

                          // Password Field
                          CustomInputField(
                            controller: controller.passwordController,
                            hintText: 'Password',
                            prefixIcon: Icons.lock,
                            isVisible: controller.isPasswordVisible.value,
                            onVisibilityToggle:
                                controller.togglePasswordVisibility,
                            errorText: controller.passwordError.value.isNotEmpty
                                ? controller.passwordError.value
                                : null,
                          ),
                          SizedBox(height: 16.h),

                          // Confirm Password Field
                          CustomInputField(
                            controller: controller.confirmPasswordController,
                            hintText: 'Confirm Password',
                            prefixIcon: Icons.lock,
                            isVisible:
                                controller.isConfirmPasswordVisible.value,
                            onVisibilityToggle:
                                controller.toggleConfirmPasswordVisibility,
                            errorText:
                                controller.confirmPasswordError.value.isNotEmpty
                                ? controller.confirmPasswordError.value
                                : null,
                          ),
                          SizedBox(height: 24.h),

                          // Sign Up Button
                          controller.isLoading.value
                              ? CircularProgressIndicator(
                                  color: AppTheme.primaryColor,
                                )
                              : ElevatedButton(
                                  onPressed: controller.signUp,
                                  child: const Text('Sign Up'),
                                ),
                          SizedBox(height: 24.h),

                          // Or sign up with divider
                          DividerWithText(text: 'Or sign up with'),
                          SizedBox(height: 20.h),

                          SocialButton(
                            onTap: controller.signUpWithGoogle,
                            icon: 'assets/images/google.png',
                            text: 'Sign up with Google',
                          ),

                          SizedBox(height: 32.h),

                          // Login Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account?',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              GestureDetector(
                                onTap: controller.login,
                                child: Text(
                                  'Log In',
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
                          SizedBox(height: 20.h),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
