import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/models/shop.dart';
import 'package:practices/core/screens/home/home_controller.dart';
import 'package:practices/core/widgets/shop_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.all(8.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(() {
                        return Container(
                          padding: EdgeInsets.only(left: 5.sp),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 235, 228, 228),

                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: DropdownButton<String>(
                            hint: Text(
                              'Select District',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            value: controller.selectedDistrict.value.isEmpty
                                ? null
                                : controller.selectedDistrict.value,
                            items: controller.districts
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              controller.selectedDistrict.value = val!;
                            },
                          ),
                        );
                      }),
                      Obx(() {
                        return Container(
                          padding: EdgeInsets.only(left: 5.sp),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 235, 228, 228),

                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: DropdownButton<String>(
                            hint: Text(
                              'Select Town',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            value: controller.selectedTown.value.isEmpty
                                ? null
                                : controller.selectedTown.value,
                            items: controller.selectedDistrict.value.isEmpty
                                ? []
                                : controller
                                      .towns[controller.selectedDistrict.value]
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ),
                                      )
                                      .toList(),
                            onChanged: (val) {
                              controller.selectedTown.value = val!;
                              controller.selectedArea.value = "";
                            },
                          ),
                        );
                      }),
                      Obx(() {
                        return Container(
                          padding: EdgeInsets.only(left: 5.sp),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: const Color.fromARGB(255, 235, 228, 228),
                          ),
                          child: DropdownButton<String>(
                            underline: SizedBox(),
                            hint: Text(
                              'Select District',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            value: controller.selectedDistrict.value.isEmpty
                                ? null
                                : controller.selectedDistrict.value,
                            items: controller.districts
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              controller.selectedDistrict.value = val!;
                            },
                          ),
                        );
                      }),
                      SizedBox(height: 20),
                    ],
                  ),
                  Text("Shops", style: Theme.of(context).textTheme.bodyLarge),

                  ShopCard(
                    onTap: controller.gotoDetailedView,
                    shop: Shop(
                      shopName: "Ghafor Cosmetic Store",
                      shopOwner: "Muhammad Ghafor",
                      cellPhone: "0303684795739",
                      shopImagUrl: "",
                      address: "Gulshan_e_Iqbal , Karachi",
                    ),
                  ),
                  ShopCard(
                    onTap: controller.gotoDetailedView,
                    shop: Shop(
                      shopName: "Ghafor Cosmetic Store",
                      shopOwner: "Muhammad Ghafor",
                      cellPhone: "0303684795739",
                      shopImagUrl: "",
                      address: "Gulshan_e_Iqbal , Karachi",
                    ),
                  ),
                  ShopCard(
                    onTap: controller.gotoDetailedView,
                    shop: Shop(
                      shopName: "Ghafor Cosmetic Store",
                      shopOwner: "Muhammad Ghafor",
                      cellPhone: "0303684795739",
                      shopImagUrl: "",
                      address: "Gulshan_e_Iqbal , Karachi",
                    ),
                  ),
                  ShopCard(
                    onTap: controller.gotoDetailedView,
                    shop: Shop(
                      shopName: "Ghafor Cosmetic Store",
                      shopOwner: "Muhammad Ghafor",
                      cellPhone: "0303684795739",
                      shopImagUrl: "",
                      address: "Gulshan_e_Iqbal , Karachi",
                    ),
                  ),
                  ShopCard(
                    onTap: controller.gotoDetailedView,
                    shop: Shop(
                      shopName: "Ghafor Cosmetic Store",
                      shopOwner: "Muhammad Ghafor",
                      cellPhone: "0303684795739",
                      shopImagUrl: "",
                      address: "Gulshan_e_Iqbal , Karachi",
                    ),
                  ),
                  ShopCard(
                    onTap: controller.gotoDetailedView,
                    shop: Shop(
                      shopName: "Ghafor Cosmetic Store",
                      shopOwner: "Muhammad Ghafor",
                      cellPhone: "0303684795739",
                      shopImagUrl: "",
                      address: "Gulshan_e_Iqbal , Karachi",
                    ),
                  ),
                  ShopCard(
                    onTap: controller.gotoDetailedView,
                    shop: Shop(
                      shopName: "Ghafor Cosmetic Store",
                      shopOwner: "Muhammad Ghafor",
                      cellPhone: "0303684795739",
                      shopImagUrl: "",
                      address: "Gulshan_e_Iqbal , Karachi",
                    ),
                  ),
                ],
              ),
            ),
          ),
          persistentFooterButtons: [
            ElevatedButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.add), Text("Add Shop")],
              ),
            ),
          ],
        );
      },
    );
  }
}
