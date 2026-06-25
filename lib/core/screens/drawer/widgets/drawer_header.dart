import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practices/core/models/user_model.dart';
import 'package:practices/core/themes/app_theme.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key, required this.user});

  static const _headerOnGradient = Colors.white;
  final UserModel user;
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
                    child: () {
                      Image.network(user.avatarUrl, fit: BoxFit.cover);

                      return Icon(
                        Icons.person,
                        size: 50.sp,
                        color: AppTheme.primaryColor,
                      );
                    }(),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                user.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: _headerOnGradient,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                user.email,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: _headerOnGradient.withValues(alpha: 0.88),
                ),
              ),
              SizedBox(width: 6.w),
            ],
          ),
        ),
      ),
    );
  }
}
