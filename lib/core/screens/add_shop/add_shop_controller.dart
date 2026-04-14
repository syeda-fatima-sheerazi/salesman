import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddShopController extends GetxController {
  // Text Controllers
  final shopNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final cnicController = TextEditingController();
  final areaController = TextEditingController();
  final townController = TextEditingController();
  final districtController = TextEditingController();

  // Observable variables
  final Rx<File?> shopPhoto = Rx<File?>(null);
  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;
  final RxBool isGettingLocation = false.obs;
  final RxBool isSubmitting = false.obs;

  // Form validation states
  final RxString shopNameError = ''.obs;
  final RxString ownerNameError = ''.obs;
  final RxString mobileNumberError = ''.obs;
  final RxString cnicError = ''.obs;
  final RxString areaError = ''.obs;
  final RxString townError = ''.obs;
  final RxString districtError = ''.obs;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onClose() {
    shopNameController.dispose();
    ownerNameController.dispose();
    mobileNumberController.dispose();
    cnicController.dispose();
    areaController.dispose();
    townController.dispose();
    districtController.dispose();
    super.onClose();
  }

  Future<void> capturePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (photo != null) {
        shopPhoto.value = File(photo.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture photo: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<void> getCurrentLocation() async {
    isGettingLocation.value = true;
    try {
      // Simulate location fetching - replace with actual location service
      await Future.delayed(const Duration(seconds: 2));
      latitude.value = 24.8607; // Example: Karachi latitude
      longitude.value = 67.0011; // Example: Karachi longitude

      Get.snackbar(
        'Success',
        'Location captured successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get location: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isGettingLocation.value = false;
    }
  }

  bool validateForm() {
    bool isValid = true;

    if (shopNameController.text.trim().isEmpty) {
      shopNameError.value = 'Shop name is required';
      isValid = false;
    } else {
      shopNameError.value = '';
    }

    if (ownerNameController.text.trim().isEmpty) {
      ownerNameError.value = 'Owner name is required';
      isValid = false;
    } else {
      ownerNameError.value = '';
    }

    if (mobileNumberController.text.trim().isEmpty) {
      mobileNumberError.value = 'Mobile number is required';
      isValid = false;
    } else if (!isValidMobileNumber(mobileNumberController.text)) {
      mobileNumberError.value = 'Enter valid mobile number (03XX-XXXXXXX)';
      isValid = false;
    } else {
      mobileNumberError.value = '';
    }

    if (cnicController.text.trim().isEmpty) {
      cnicError.value = 'CNIC is required';
      isValid = false;
    } else if (!isValidCNIC(cnicController.text)) {
      cnicError.value = 'Enter valid CNIC (XXXXX-XXXXXXX-X)';
      isValid = false;
    } else {
      cnicError.value = '';
    }

    if (areaController.text.trim().isEmpty) {
      areaError.value = 'Area is required';
      isValid = false;
    } else {
      areaError.value = '';
    }

    if (townController.text.trim().isEmpty) {
      townError.value = 'Town is required';
      isValid = false;
    } else {
      townError.value = '';
    }

    if (districtController.text.trim().isEmpty) {
      districtError.value = 'District is required';
      isValid = false;
    } else {
      districtError.value = '';
    }

    return isValid;
  }

  bool isValidMobileNumber(String number) {
    // Pakistani mobile number format: 03XX-XXXXXXX
    final RegExp regex = RegExp(r'^03\d{2}-?\d{7}$');
    return regex.hasMatch(number.replaceAll('-', ''));
  }

  bool isValidCNIC(String cnic) {
    // Pakistani CNIC format: XXXXX-XXXXXXX-X
    final RegExp regex = RegExp(r'^\d{5}-?\d{7}-?\d{1}$');
    return regex.hasMatch(cnic);
  }

  Future<void> submitShop() async {
    if (!validateForm()) {
      Get.snackbar(
        'Validation Error',
        'Please fill all required fields correctly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.1),
        colorText: Colors.orange,
      );
      return;
    }

    isSubmitting.value = true;
    try {
      // Simulate API call - replace with actual shop creation service
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Shop added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

      // Clear form after successful submission
      clearForm();
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add shop: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void clearForm() {
    shopNameController.clear();
    ownerNameController.clear();
    mobileNumberController.clear();
    cnicController.clear();
    areaController.clear();
    townController.clear();
    districtController.clear();
    shopPhoto.value = null;
    latitude.value = 0.0;
    longitude.value = 0.0;

    shopNameError.value = '';
    ownerNameError.value = '';
    mobileNumberError.value = '';
    cnicError.value = '';
    areaError.value = '';
    townError.value = '';
    districtError.value = '';
  }
}
