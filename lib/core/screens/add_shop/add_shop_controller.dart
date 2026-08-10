import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sales_man/core/models/shop.dart';
import 'package:sales_man/core/repositories/i_shop_repository.dart';
import 'package:sales_man/core/routes/route_names.dart';
import 'package:sales_man/core/screens/location_picker/location_picker_controller.dart';
import 'package:sales_man/core/services/auth_service.dart';
import 'package:sales_man/core/services/snackbar/app_snackbar_service.dart';
import 'package:sales_man/core/services/storage_service.dart';

class AddShopController extends GetxController {
  final shopNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final cnicController = TextEditingController();
  final areaController = TextEditingController();
  final townController = TextEditingController();
  final districtController = TextEditingController();

  final Rx<File?> shopPhoto = Rx<File?>(null);
  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;
  final RxBool isSubmitting = false.obs;

  final RxString shopNameError = ''.obs;
  final RxString ownerNameError = ''.obs;
  final RxString mobileNumberError = ''.obs;
  final RxString cnicError = ''.obs;
  final RxString areaError = ''.obs;
  final RxString townError = ''.obs;
  final RxString districtError = ''.obs;

  final ImagePicker _imagePicker = ImagePicker();
  final IShopRepository _shopRepository = Get.find();
  final StorageService _storageService = Get.find();

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
      AppSnackbarService.error('Failed to capture photo: $e');
    }
  }

  Future<void> openLocationPicker() async {
    final result = await Get.toNamed(Routes.locationPicker);
    if (result is SelectedLocation) {
      latitude.value = result.latitude;
      longitude.value = result.longitude;

      if (result.address.isNotEmpty) {
        areaController.text = result.address;
      }

      AppSnackbarService.success('Location selected');
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

    areaError.value = '';
    townError.value = '';
    districtError.value = '';

    return isValid;
  }

  bool isValidMobileNumber(String number) {
    final RegExp regex = RegExp(r'^03\d{2}-?\d{7}$');
    return regex.hasMatch(number.replaceAll('-', ''));
  }

  bool isValidCNIC(String cnic) {
    final RegExp regex = RegExp(r'^\d{5}-?\d{7}-?\d{1}$');
    return regex.hasMatch(cnic);
  }

  Future<void> submitShop() async {
    if (!validateForm()) {
      AppSnackbarService.warning(
        'Please fill all required fields correctly',
        title: 'Validation Error',
      );
      return;
    }

    if (latitude.value == 0.0 || longitude.value == 0.0) {
      AppSnackbarService.warning(
        'Please select shop location',
        title: 'Location Required',
      );
      return;
    }

    isSubmitting.value = true;
    try {
      final shopId = DateTime.now().millisecondsSinceEpoch.toString();
      final uid = AuthService.instance.currentUser!.id;

      String imageUrl = 'assets/images/shop.png';
      if (shopPhoto.value != null) {
        imageUrl = await _storageService.uploadShopImage(
          uid: uid,
          shopId: shopId,
          file: shopPhoto.value!,
        );
      }

      final shop = Shop(
        id: shopId,
        shopName: shopNameController.text.trim(),
        shopOwner: ownerNameController.text.trim(),
        cellPhone: mobileNumberController.text.trim(),
        cnic: cnicController.text.trim(),
        address:
            '${areaController.text.trim()}, ${townController.text.trim()}, ${districtController.text.trim()}',
        area: areaController.text.trim(),
        town: townController.text.trim(),
        district: districtController.text.trim(),
        latitude: latitude.value,
        longitude: longitude.value,
        shopImagUrl: imageUrl,
        createdAt: DateTime.now(),
      );

      await _shopRepository.saveShop(shop);

      AppSnackbarService.success('Shop added successfully');
      clearForm();
      Get.back(result: true);
    } catch (e) {
      AppSnackbarService.error('Failed to add shop: $e');
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
