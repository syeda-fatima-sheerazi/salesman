import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/models/user_model.dart';
import 'package:practices/core/routes/app_pages.dart';
import 'package:practices/core/screens/dashboard/dashboard_binding.dart';
import 'package:practices/core/screens/login/login_binding.dart';
import 'package:practices/core/screens/signUp/signup_binding.dart';
import 'package:practices/core/screens/splash/splash_binding.dart';
import 'package:practices/core/screens/dashboard/dashboard_view.dart';
import 'package:practices/core/screens/login/login_view.dart';
import 'package:practices/core/screens/signUp/sign_up_view.dart';
import 'package:practices/core/screens/splash/splash_view.dart';
import 'package:practices/core/themes/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, widget) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.light,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          
        );
      },
    );
  }
}
