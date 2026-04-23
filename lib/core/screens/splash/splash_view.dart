import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.w,
                    vertical: 40.h,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: AnimatedTextKit(
                          repeatForever: false,
                          totalRepeatCount: 1,
                          animatedTexts: [
                            BounceAnimatedText(
                              'Sales Man',
                              textAlign: TextAlign.center,
                              textStyle: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    // fontStyle: GoogleFonts.roboto().fontStyle,
                                    fontFamily:
                                        GoogleFonts.racingSansOne().fontFamily,

                                    fontSize: 28.sp,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                              duration: const Duration(milliseconds: 1100),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: double.infinity,
                        child: AnimatedTextKit(
                          repeatForever: false,
                          totalRepeatCount: 1,
                          animatedTexts: [
                            TyperAnimatedText(
                              'Track, Manage and Grow Your Sales',
                              textAlign: TextAlign.center,
                              textStyle: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                              speed: const Duration(milliseconds: 100),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),
                      // Lottie.asset(
                      //   'assets/animations/splash.json',
                      //   height: 250.h,
                      //   width: 250.w,
                      //   fit: BoxFit.contain,
                      //   // repeat: false,
                      // ),
                      // SizedBox(
                      //   height: 150.h,
                      //   width: 150.w,
                      //   child: Image.asset(
                      //     "assets/icons/splash_icon_bg.png", // Changed 'icon' to 'icons'
                      //     fit: BoxFit.contain,
                      //     errorBuilder: (context, error, stackTrace) => Center(
                      //       child: Icon(
                      //         Icons.error_outline,
                      //         color: Colors.red,
                      //         size: 40.sp,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.8, end: 1.0),
                        duration: const Duration(seconds: 3),
                        curve: Curves.elasticOut,
                        builder: (context, scale, child) {
                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/splash_icon_bg.png",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: 400.h,
                              width: 400.w,
                            ),
                          );
                        },
                      ),

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
