import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
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

                  SizedBox(height: 20.h),
                  Lottie.asset(
                    'assets/animations/splash.json',
                    // height: 300.sh,
                    // width: 300.sw,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    '...',
                    speed: Duration(milliseconds: 500),
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
    );
  }
}
