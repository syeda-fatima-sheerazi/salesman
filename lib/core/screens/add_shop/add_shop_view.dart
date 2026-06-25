import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/add_shop/add_shop_controller.dart';
import 'package:practices/core/themes/app_theme.dart';
import 'package:practices/core/widgets/app_primary_action_button.dart';
import 'package:practices/core/widgets/card_input_field.dart';
import 'package:practices/core/widgets/photo_upload_widget.dart';
import 'package:practices/core/widgets/shop_location_section.dart';

class AddShopView extends GetView<AddShopController> {
  const AddShopView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text('Add Shop', style: theme.appBarTheme.titleTextStyle),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop Photo (Optional)
            Obx(() {
              return Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: PhotoUploadWidget(
                  photo: controller.shopPhoto.value,
                  onCapture: controller.capturePhoto,
                  title: 'Shop Photo',
                  subtitle: 'Add a clear photo (Optional)',
                  buttonText: 'Capture Photo',
                  placeholderIcon: Icons.store,
                ),
              );
            }),
            SizedBox(height: 16.h),

            // Shop Information Section
            Text(
              'Shop Information',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),

            // Shop Name
            Obx(() {
              return CardInputField(
                controller: controller.shopNameController,
                label: 'Shop Name',
                hint: 'Enter shop name',
                icon: Icons.store,
                error: controller.shopNameError.value.isNotEmpty
                    ? controller.shopNameError.value
                    : null,
                isRequired: true,
              );
            }),
            SizedBox(height: 16.h),

            // Owner Name
            Obx(() {
              return CardInputField(
                controller: controller.ownerNameController,
                label: 'Owner Name',
                hint: 'Enter owner name',
                icon: Icons.person,
                error: controller.ownerNameError.value.isNotEmpty
                    ? controller.ownerNameError.value
                    : null,
                isRequired: true,
              );
            }),
            SizedBox(height: 16.h),

            // CNIC
            Obx(() {
              return CardInputField(
                controller: controller.cnicController,
                label: 'CNIC',
                hint: 'XXXXX-XXXXXXX-X',
                icon: Icons.credit_card,
                keyboardType: TextInputType.number,
                error: controller.cnicError.value.isNotEmpty
                    ? controller.cnicError.value
                    : null,
                isRequired: true,
              );
            }),
            SizedBox(height: 16.h),

            // Mobile Number
            Obx(() {
              return CardInputField(
                controller: controller.mobileNumberController,
                label: 'Mobile Number',
                hint: '03XX-XXXXXXX',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                error: controller.mobileNumberError.value.isNotEmpty
                    ? controller.mobileNumberError.value
                    : null,
                isRequired: true,
              );
            }),
            SizedBox(height: 24.h),

            // Address Section
            Text(
              'Address Information',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'These fields are optional and will be auto-filled when you capture location',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppTheme.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 12.h),

            // Area (Optional - auto-detected from location)
            Obx(() {
              return CardInputField(
                controller: controller.areaController,
                label: 'Area',
                hint: 'Auto-detected from location (optional)',
                icon: Icons.location_on,
                error: controller.areaError.value.isNotEmpty
                    ? controller.areaError.value
                    : null,
                isRequired: false,
              );
            }),
            SizedBox(height: 16.h),

            // Town (Optional - auto-detected from location)
            Obx(() {
              return CardInputField(
                controller: controller.townController,
                label: 'Town',
                hint: 'Auto-detected from location (optional)',
                icon: Icons.business,
                error: controller.townError.value.isNotEmpty
                    ? controller.townError.value
                    : null,
                isRequired: false,
              );
            }),
            SizedBox(height: 16.h),

            // District (Optional - auto-detected from location)
            Obx(() {
              return CardInputField(
                controller: controller.districtController,
                label: 'District',
                hint: 'Auto-detected from location (optional)',
                icon: Icons.person_pin_circle,
                error: controller.districtError.value.isNotEmpty
                    ? controller.districtError.value
                    : null,
                isRequired: false,
              );
            }),
            SizedBox(height: 24.h),

            // Location Section
            Text(
              'Shop Location',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),

            // Location Card
            Obx(() {
              return ShopLocationSection(
                latitude: controller.latitude.value,
                longitude: controller.longitude.value,
                isGettingLocation: controller.isGettingLocation.value,
                onGetLocation: controller.getCurrentLocation,
              );
            }),
            SizedBox(height: 24.h),

            // Submit Button
            AppPrimaryActionButton(
              label: 'Submit',
              onPressed: controller.submitShop,
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
