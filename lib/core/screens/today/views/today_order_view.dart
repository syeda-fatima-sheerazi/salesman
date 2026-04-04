import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/today/controller/today_controller.dart';

class TodayOrderView extends StatelessWidget {
  const TodayOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodayController>(
      init: TodayController(),
      builder: (controller) {
        return Scaffold(
          body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  onTap: controller.changeTab,
                  tabs: [
                    Tab(text: "Order"),
                    Tab(text: "Collection"),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
