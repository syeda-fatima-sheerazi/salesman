import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/dashboard/dashboard_view.dart';
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
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, widget) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.light,
          home: const SplashView(),
          // initialRoute: '/',
          // getPages: [
          //   GetPage(name: '/', page: () => const SplashView()),
          //   GetPage(name: '/login', page: () => const LoginView()),
          //   GetPage(name: '/signup', page: () => const SignUpView()),
          //   GetPage(name: '/dashboard', page: () => const DashboardView()),
          // ],
        );
      },
    );
  }
}
