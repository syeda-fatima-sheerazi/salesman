import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import 'package:practices/core/models/shop.dart';
import 'package:practices/core/services/snackbar/app_snackbar_service.dart';

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
      AppSnackbarService.error('Failed to capture photo: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    isGettingLocation.value = true;
    try {
      // Simulate location fetching - replace with actual location service
      await Future.delayed(const Duration(seconds: 2));
      latitude.value = 24.8607; // Example: Karachi latitude
      longitude.value = 67.0011; // Example: Karachi longitude

      // Perform reverse geocoding to get address details
      await _performReverseGeocoding(latitude.value, longitude.value);

      AppSnackbarService.success('Location captured successfully');
    } catch (e) {
      AppSnackbarService.error('Failed to get location: $e');
    } finally {
      isGettingLocation.value = false;
    }
  }

  /// Performs reverse geocoding to auto-fill Area, Town, and District
  Future<void> _performReverseGeocoding(double lat, double lng) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        lat,
        lng,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;

        // Auto-fill the fields with geocoding data
        // Note: In Pakistan context:
        // - subLocality = Area/Neighborhood
        // - locality = Town/City
        // - subAdministrativeArea or administrativeArea = District
        final String area = place.subLocality ?? place.locality ?? '';
        final String town = place.locality ?? place.subAdministrativeArea ?? '';
        final String district =
            place.subAdministrativeArea ?? place.administrativeArea ?? '';

        // Only update if fields are empty (preserve user edits if they exist)
        if (areaController.text.isEmpty && area.isNotEmpty) {
          areaController.text = area;
        }
        if (townController.text.isEmpty && town.isNotEmpty) {
          townController.text = town;
        }
        if (districtController.text.isEmpty && district.isNotEmpty) {
          districtController.text = district;
        }

        // Force UI rebuild to show updated text fields
        // update();

        // Show info snackbar if any fields were auto-filled
        if (area.isNotEmpty || town.isNotEmpty || district.isNotEmpty) {
          AppSnackbarService.info(
            'Area, Town and District have been auto-filled from location. You can edit them if needed.',
            title: 'Address Auto-detected',
            duration: AppSnackbarService.longDuration,
          );
        }
      }
    } catch (e) {
      // Silently fail - reverse geocoding is a nice-to-have, not required
      debugPrint('Reverse geocoding failed: $e');
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

    // Area, Town, District are optional - clear any previous errors
    areaError.value = '';
    townError.value = '';
    districtError.value = '';

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
      AppSnackbarService.warning(
        'Please fill all required fields correctly',
        title: 'Validation Error',
      );
      return;
    }

    // Check if location is captured
    if (latitude.value == 0.0 || longitude.value == 0.0) {
      AppSnackbarService.warning(
        'Please capture shop location',
        title: 'Location Required',
      );
      return;
    }

    isSubmitting.value = true;
    try {
      // 3 seconds delay before processing
      await Future.delayed(const Duration(seconds: 3));

      // Create shop model
      final shop = Shop(
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
        photoPath: shopPhoto.value?.path,
        createdAt: DateTime.now(),
      );

      // TODO: Save shop to storage (SharedPreferences/Backend)
      // For now, just print the shop data
      print('Shop created: ${shop.toMap()}');

      // Show success dialog
      Get.defaultDialog(
        title: 'Success',
        middleText: 'Shop added Successfully',
        backgroundColor: Colors.white,
        titleStyle: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        middleTextStyle: const TextStyle(color: Colors.black87, fontSize: 16),
        confirm: ElevatedButton(
          onPressed: () {
            Get.back(); // Close dialog
            Get.back(); // Go back to home
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        barrierDismissible: false,
      );

      // Clear form after successful submission
      clearForm();
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
