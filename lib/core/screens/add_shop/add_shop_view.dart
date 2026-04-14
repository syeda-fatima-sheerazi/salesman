import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/add_shop/add_shop_controller.dart';
import 'package:practices/core/themes/app_theme.dart';

class AddShopView extends StatelessWidget {
  const AddShopView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<AddShopController>(
      init: AddShopController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppTheme.primaryColor,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: Text(
              'Add Shop',
              style: theme.appBarTheme.titleTextStyle,
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shop Photo Section
                  _buildShopPhotoSection(context, controller),
                  SizedBox(height: 20.h),

                  // Basic Information Card
                  _buildBasicInformationCard(context, controller),
                  SizedBox(height: 16.h),

                  // Address Card
                  _buildAddressCard(context, controller),
                  SizedBox(height: 16.h),

                  // Location Card
                  _buildLocationCard(context, controller),
                  SizedBox(height: 24.h),

                  // Submit Button
                  _buildSubmitButton(context, controller),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShopPhotoSection(BuildContext context, AddShopController controller) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Photo Avatar with Camera Icon
          Stack(
            children: [
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  color: AppTheme.primaryColor.withOpacity(0.1),
                ),
                child: Obx(() {
                  if (controller.shopPhoto.value != null) {
                    return ClipOval(
                      child: Image.file(
                        controller.shopPhoto.value!,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                  return Icon(
                    Icons.store,
                    size: 45.w,
                    color: AppTheme.primaryColor,
                  );
                }),
              ),
              // Camera icon badge
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: controller.capturePhoto,
                  child: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 18.w,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 16.w),

          // Text and Button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shop Photo',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Add a clear photo of the shop for better identification.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 38.h,
                  child: OutlinedButton.icon(
                    onPressed: controller.capturePhoto,
                    icon: Icon(
                      Icons.camera_alt,
                      size: 18.w,
                      color: AppTheme.primaryColor,
                    ),
                    label: Text(
                      'Capture Photo',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.primaryColor,
                        fontSize: 13.sp,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: BorderSide(color: AppTheme.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInformationCard(BuildContext context, AddShopController controller) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Icon(
                Icons.store_outlined,
                color: AppTheme.primaryColor,
                size: 20.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'Basic Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Shop Name Field
          _buildTextField(
            context: context,
            controller: controller.shopNameController,
            label: 'Shop Name',
            hint: 'Enter shop name',
            icon: Icons.store,
            isRequired: true,
            errorText: controller.shopNameError,
          ),
          SizedBox(height: 12.h),

          // Owner Name Field
          _buildTextField(
            context: context,
            controller: controller.ownerNameController,
            label: 'Owner Name',
            hint: 'Enter owner name',
            icon: Icons.person,
            isRequired: true,
            errorText: controller.ownerNameError,
          ),
          SizedBox(height: 12.h),

          // Mobile Number Field
          _buildTextField(
            context: context,
            controller: controller.mobileNumberController,
            label: 'Mobile Number',
            hint: '03XX-XXXXXXX',
            icon: Icons.phone,
            isRequired: true,
            keyboardType: TextInputType.phone,
            errorText: controller.mobileNumberError,
          ),
          SizedBox(height: 12.h),

          // CNIC Field
          _buildTextField(
            context: context,
            controller: controller.cnicController,
            label: 'CNIC',
            hint: 'XXXXX-XXXXXXX-X',
            icon: Icons.credit_card,
            isRequired: true,
            keyboardType: TextInputType.number,
            errorText: controller.cnicError,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, AddShopController controller) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppTheme.primaryColor,
                size: 20.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'Address',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Area Field
          _buildTextField(
            context: context,
            controller: controller.areaController,
            label: 'Area',
            hint: 'Enter area',
            icon: Icons.location_on,
            isRequired: true,
            errorText: controller.areaError,
          ),
          SizedBox(height: 12.h),

          // Town Field
          _buildTextField(
            context: context,
            controller: controller.townController,
            label: 'Town',
            hint: 'Enter town',
            icon: Icons.business,
            isRequired: true,
            errorText: controller.townError,
          ),
          SizedBox(height: 12.h),

          // District Field
          _buildTextField(
            context: context,
            controller: controller.districtController,
            label: 'District',
            hint: 'Enter district',
            icon: Icons.person_pin_circle,
            isRequired: true,
            errorText: controller.districtError,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context, AddShopController controller) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Icon(
                Icons.my_location_outlined,
                color: AppTheme.primaryColor,
                size: 20.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'Location',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Location Info & Button Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get current location or select on map',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Obx(() {
                      if (controller.latitude.value != 0.0) {
                        return Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            'Lat: ${controller.latitude.value.toStringAsFixed(4)}, Lng: ${controller.longitude.value.toStringAsFixed(4)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Obx(() {
                return SizedBox(
                  height: 40.h,
                  child: ElevatedButton.icon(
                    onPressed: controller.isGettingLocation.value
                        ? null
                        : controller.getCurrentLocation,
                    icon: controller.isGettingLocation.value
                        ? SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            Icons.location_on,
                            size: 18.w,
                          ),
                    label: Text(
                      controller.isGettingLocation.value
                          ? 'Getting...'
                          : 'Get Location',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 13.sp,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isRequired,
    TextInputType keyboardType = TextInputType.text,
    required RxString errorText,
  }) {
    final theme = Theme.of(context);

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label with icon
          Row(
            children: [
              Icon(
                icon,
                size: 18.w,
                color: AppTheme.primaryColor,
              ),
              SizedBox(width: 8.w),
              Text(
                '$label ${isRequired ? '*' : ''}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),

          // Text Field
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary.withOpacity(0.6),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 14.h,
              ),
              filled: true,
              fillColor: AppTheme.backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  color: AppTheme.primaryColor,
                  width: 1.5,
                ),
              ),
              errorBorder: errorText.value.isNotEmpty
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(
                        color: AppTheme.error,
                        width: 1.5,
                      ),
                    )
                  : null,
            ),
          ),

          // Error Text
          if (errorText.value.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 4.h, left: 4.w),
              child: Text(
                errorText.value,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.error,
                  fontSize: 11.sp,
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildSubmitButton(BuildContext context, AddShopController controller) {
    final theme = Theme.of(context);

    return Obx(() {
      return SizedBox(
        width: double.infinity,
        height: 50.h,
        child: ElevatedButton(
          onPressed: controller.isSubmitting.value
              ? null
              : controller.submitShop,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: AppTheme.primaryColor.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: controller.isSubmitting.value
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Adding Shop...',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                )
              : Text(
                  'Add Shop',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      );
    });
  }
}
