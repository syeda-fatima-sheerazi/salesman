import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sales_man/core/screens/drawer/custom_drawer_controller.dart';
import 'package:sales_man/core/screens/drawer/widgets/drawer_header.dart';
import 'package:sales_man/core/screens/drawer/widgets/drawer_menu.dart';

class CustomDrawerView extends GetView<CustomDrawerController> {
  const CustomDrawerView({super.key});

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
            DrawerHeaderWidget(user: controller.currentUser!),
            DrawerMenuWidget(
              onTap: () {
                Get.back();
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

