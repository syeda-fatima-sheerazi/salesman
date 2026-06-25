import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/enums/data_state.dart';
import 'package:practices/core/models/shop.dart';
import 'package:practices/core/routes/route_names.dart';
import 'package:practices/core/screens/home/home_controller.dart';
import 'package:practices/core/widgets/app_primary_action_button.dart';
import 'package:practices/core/widgets/shop_card.dart';
import 'package:practices/core/widgets/custom_dropdown.dart';
import 'package:practices/core/widgets/empty_state.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Obx(() {
                    return CustomDropdown(
                      value: controller.selectedDistrict.value.isEmpty
                          ? null
                          : controller.selectedDistrict.value,
                      items: controller.districts,
                      onChanged: (v) =>
                          controller.selectedDistrict.value = v ?? '',
                      hint: 'Select District',
                    );
                  }),
                ),
                SizedBox(width: 5.w),

                Expanded(
                  child: Obx(() {
                    return CustomDropdown(
                      value: controller.selectedTown.value.isEmpty
                          ? null
                          : controller.selectedTown.value,
                      items:
                          controller.towns[controller.selectedDistrict.value] ??
                          [],
                      onChanged: (v) => controller.selectedTown.value = v ?? '',
                      hint: 'Select Town',
                    );
                  }),
                ),
                SizedBox(width: 5.w),

                Expanded(
                  child: Obx(() {
                    return CustomDropdown(
                      value: controller.selectedArea.value.isEmpty
                          ? null
                          : controller.selectedArea.value,
                      items:
                          controller.areas[controller.selectedTown.value] ?? [],
                      onChanged: (v) => controller.selectedArea.value = v ?? '',
                      hint: 'Select Area',
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            Text("Shops List", style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 10.h),

            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Obx(() {
                  final shops = controller.shopList;
                  final dataState = controller.dataState.value;

                  if (dataState == DataState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (dataState == DataState.empty || shops.isEmpty) {
                    return const EmptyState(
                      icon: Icons.store_outlined,
                      text: 'No shops found',
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: shops.length,
                    itemBuilder: (context, index) {
                      Shop shop = shops[index]!;
                      return ShopCard(
                        shop: shops[index]!,
                        cardOnTap: () => controller.gotoDetailedView(shop),
                        visitedOnTap: () =>
                            controller.toggleVisited(shop.isVisited, shop.id!),
                      );
                    },
                  );
                }),
              ),
            ),
            AppPrimaryActionButton(
              label: "Add Shop",
              onPressed: () => Get.toNamed(Routes.addShop),
            ),
          ],
        ),
      ),
    );
  }
}
