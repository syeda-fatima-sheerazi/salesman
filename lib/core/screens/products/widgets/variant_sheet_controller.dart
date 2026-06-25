import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/products/product_controller.dart';
import 'package:practices/core/services/snackbar/app_snackbar_service.dart';

/// Add / edit variant form — fields + submit. [onClose] par controllers dispose.
final class VariantSheetController extends GetxController {
  VariantSheetController({
    required this.productId,
    required this.productController,
    this.variantIndex,
    this.initialWeight,
    this.initialPrice,
  }) : tag = 'variant_sheet_${DateTime.now().microsecondsSinceEpoch}';

  final String tag;
  final String productId;
  final ProductController productController;

  /// `null` = add new variant; non-null = edit at this index.
  final int? variantIndex;
  final String? initialWeight;
  final String? initialPrice;

  late final TextEditingController weightController;
  late final TextEditingController priceController;

  bool get isEdit => variantIndex != null;

  @override
  void onInit() {
    super.onInit();
    weightController = TextEditingController(text: initialWeight ?? '');
    priceController = TextEditingController(text: initialPrice ?? '');
  }

  @override
  void onClose() {
    weightController.dispose();
    priceController.dispose();
    super.onClose();
  }

  void cancel(BuildContext dialogContext) {
    if (!dialogContext.mounted) return;
    Navigator.of(dialogContext, rootNavigator: true).pop();
  }

  void submit(BuildContext dialogContext) {
    final w = weightController.text.trim();
    final p = priceController.text.trim();
    if (w.isEmpty || p.isEmpty) {
      AppSnackbarService.warning(
        'Please enter weight and price',
        title: 'Missing fields',
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    if (variantIndex == null) {
      productController.addVariant(productId, w, p);
    } else {
      productController.updateVariant(productId, variantIndex!, w, p);
    }
    if (!dialogContext.mounted) return;
    Navigator.of(dialogContext, rootNavigator: true).pop();
  }
}
