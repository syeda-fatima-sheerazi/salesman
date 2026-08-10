import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sales_man/core/models/product_model.dart';
import 'package:sales_man/core/repositories/i_product_repository.dart';
import 'package:sales_man/core/services/auth_service.dart';
import 'package:sales_man/core/services/snackbar/app_snackbar_service.dart';
import 'package:sales_man/core/services/storage_service.dart';

class _VariantRow {
  _VariantRow()
      : weight = TextEditingController(),
        price = TextEditingController();

  final TextEditingController weight;
  final TextEditingController price;

  void dispose() {
    weight.dispose();
    price.dispose();
  }
}

class AddProductController extends GetxController {
  static const int initialVariantRows = 2;
  static const int maxVariantRows = 30;

  final TextEditingController productNameController = TextEditingController();
  final RxString nameErrorMessage = ''.obs;
  final RxString imageErrorMessage = ''.obs;
  final RxString variantErrorMessage = ''.obs;
  final RxInt variantRowCount = initialVariantRows.obs;
  final Rx<String?> pickedImagePath = Rx<String?>(null);

  final ImagePicker _imagePicker = ImagePicker();
  final List<_VariantRow> _variantRows = [];
  final IProductRepository _productRepository = Get.find();
  final StorageService _storageService = Get.find();

  TextEditingController weightControllerAt(int index) =>
      _variantRows[index].weight;

  TextEditingController priceControllerAt(int index) =>
      _variantRows[index].price;

  @override
  void onInit() {
    super.onInit();
    for (var i = 0; i < initialVariantRows; i++) {
      _variantRows.add(_VariantRow());
    }
    variantRowCount.value = _variantRows.length;
  }

  @override
  void onClose() {
    for (final variantRow in _variantRows) {
      variantRow.dispose();
    }
    _variantRows.clear();
    productNameController.dispose();
    super.onClose();
  }

  void onProductNameChanged(String _) {
    if (nameErrorMessage.value.isNotEmpty) {
      nameErrorMessage.value = '';
    }
  }

  void onVariantFieldChanged(String _) {
    if (variantErrorMessage.value.isNotEmpty) {
      variantErrorMessage.value = '';
    }
  }

  String? _validateProductName(String? raw) {
    final name = raw?.trim() ?? '';
    if (name.isEmpty) {
      return 'Product name is required';
    }
    return null;
  }

  bool _hasAtLeastOneCompleteVariant() {
    for (final variantRow in _variantRows) {
      final weight = variantRow.weight.text.trim();
      final price = variantRow.price.text.trim();
      if (weight.isNotEmpty && price.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  List<ProductVariantModel> _collectCompleteVariants() {
    final variantList = <ProductVariantModel>[];
    for (final variantRow in _variantRows) {
      final weight = variantRow.weight.text.trim();
      final price = variantRow.price.text.trim();
      if (weight.isNotEmpty && price.isNotEmpty) {
        variantList.add(ProductVariantModel(weight: weight, price: price));
      }
    }
    return variantList;
  }

  Future<void> saveProduct() async {
    final nameErr = _validateProductName(productNameController.text);
    final path = pickedImagePath.value?.trim();
    final imageErr = (path == null || path.isEmpty)
        ? 'Product image is required'
        : null;
    final variantErr = _hasAtLeastOneCompleteVariant()
        ? null
        : 'At least one variant (weight and price) is required';

    nameErrorMessage.value = nameErr ?? '';
    imageErrorMessage.value = imageErr ?? '';
    variantErrorMessage.value = variantErr ?? '';

    if (nameErr != null || imageErr != null || variantErr != null) {
      return;
    }

    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final uid = AuthService.instance.currentUser!.id;

      String imageUrl = 'assets/images/shop.png';
      if (pickedImagePath.value != null && pickedImagePath.value!.isNotEmpty) {
        imageUrl = await _storageService.uploadProductImage(
          uid: uid,
          productId: id,
          file: File(pickedImagePath.value!),
        );
      }

      final name = productNameController.text.trim();
      final variants = _collectCompleteVariants();
      final product = ProductModel(
        id: id,
        name: name,
        imageUrl: imageUrl,
        variants: variants,
      );

      await _productRepository.saveProduct(product);

      Get.back();
      AppSnackbarService.success(
        name,
        title: 'Product added',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      AppSnackbarService.error('Failed to save product: $e');
    }
  }

  void moreVariants() {
    if (_variantRows.length >= maxVariantRows) return;
    _variantRows.add(_VariantRow());
    variantRowCount.value = _variantRows.length;
  }

  void removeLastVariant() {
    if (_variantRows.length <= initialVariantRows) return;
    _variantRows.removeLast().dispose();
    variantRowCount.value = _variantRows.length;
  }

  bool get canAddMoreVariants => _variantRows.length < maxVariantRows;

  bool get canRemoveVariant => _variantRows.length > initialVariantRows;

  Future<void> pickProductImageFromGallery() async {
    try {
      final file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );
      if (file != null) {
        pickedImagePath.value = file.path;
        imageErrorMessage.value = '';
      }
    } on PlatformException catch (e) {
      AppSnackbarService.error(
        e.message ?? 'Could not open gallery',
        title: 'Photos',
      );
    } catch (_) {
      AppSnackbarService.error(
        'Something went wrong',
        title: 'Photos',
      );
    }
  }

  void clearPickedImage() {
    pickedImagePath.value = null;
    imageErrorMessage.value = '';
  }
}

