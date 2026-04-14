import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:practices/core/screens/splash/splash_ctrl.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashCtrl>(
      init: SplashCtrl(),
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sales Man',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          // color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'Track, Manage, Grow Your Sales',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Lottie.asset(
                        'assets/animations/splash.json',
                        height: 250.h,
                        width: 250.w,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 30.h),
                      AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(
                            '...',
                            speed: const Duration(milliseconds: 500),
                            textStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                        repeatForever: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
