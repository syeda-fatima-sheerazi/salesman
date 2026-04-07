import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/drawer/custom_drawer_controller.dart';
import 'package:practices/core/themes/app_theme.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key, required this.controller});

  final CustomDrawerController controller;
  static const _headerOnGradient = Colors.white;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryDark,
            AppTheme.primaryColor,
            AppTheme.primaryLight,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _headerOnGradient,
                    border: Border.all(color: _headerOnGradient, width: 3.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.22),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Obx(() {
                      final user = controller.currentUser.value;
                      if (user?.avatarUrl != null) {
                        return Image.network(
                          user!.avatarUrl!,
                          fit: BoxFit.cover,
                        );
                      }
                      return Icon(
                        Icons.person,
                        size: 50.sp,
                        color: AppTheme.primaryColor,
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Obx(() {
                final user = controller.currentUser.value;
                return Text(
                  user?.name ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: _headerOnGradient,
                  ),
                );
              }),
              SizedBox(height: 6.h),
              Obx(() {
                final user = controller.currentUser.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        user?.email ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: _headerOnGradient.withValues(alpha: 0.88),
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.edit_outlined,
                        color: _headerOnGradient.withValues(alpha: 0.95),
                        size: 18.sp,
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
