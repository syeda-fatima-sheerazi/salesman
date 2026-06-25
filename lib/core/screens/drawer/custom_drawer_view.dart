import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/models/user_model.dart';
import 'package:practices/core/screens/drawer/custom_drawer_controller.dart';
import 'package:practices/core/screens/drawer/widgets/drawer_header.dart';
import 'package:practices/core/screens/drawer/widgets/drawer_menu.dart';

class CustomDrawerView extends GetView<CustomDrawerController> {
  const CustomDrawerView({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 0.75.sw,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Brand header (teal gradient — same on light & dark)
            DrawerHeaderWidget(user: user),

            // Menu sheet — follows theme surface (light white / dark elevated)
            DrawerMenuWidget(
              onTap: () {
                Get.back(); // Close the drawer
                controller.logout();
              },
              title: '1.0.0',
            ),
          ],
        ),
      ),
    );
  }
}
