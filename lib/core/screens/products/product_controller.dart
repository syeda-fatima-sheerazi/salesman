import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_man/core/models/product_model.dart';
import 'package:sales_man/core/repositories/i_product_repository.dart';
import 'package:sales_man/core/routes/route_names.dart';
import 'package:sales_man/core/screens/products/widgets/variant_sheet.dart';

class ProductController extends GetxController {
  final RxString searchQuery = ''.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final TextEditingController searchFieldController = TextEditingController();

  final IProductRepository _productRepository = Get.find();
  StreamSubscription? _productSubscription;

  @override
  void onInit() {
    super.onInit();
    _subscribeToProducts();
  }

  @override
  void onClose() {
    _productSubscription?.cancel();
    searchFieldController.dispose();
    super.onClose();
  }

  void _subscribeToProducts() {
    _productSubscription = _productRepository.getProducts().listen((list) {
      products.assignAll(list);
    });
  }

  List<ProductModel> get filteredProducts {
    final searchValue = searchQuery.value.toLowerCase();

    if (searchValue.isEmpty) return products.toList();

    return products
        .where((product) => product.name.toLowerCase().contains(searchValue))
        .toList();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void clearSearch() {
    searchFieldController.clear();
    searchQuery.value = '';
  }

  void addProduct() {
    Get.toNamed(Routes.addProduct);
  }

  void addProductWithName(
    String name, {
    String? imagePath,
    required List<ProductVariantModel> variants,
  }) {
    final trimmed = name.trim();
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final image = (imagePath != null && imagePath.trim().isNotEmpty)
        ? imagePath.trim()
        : 'assets/images/shop.png';
    final product = ProductModel(
      id: id,
      name: trimmed,
      imageUrl: image,
      variants: List<ProductVariantModel>.from(variants),
    );
    _productRepository.saveProduct(product);
  }

  void addVariant(String productId, String weight, String price) {
    final w = weight.trim();
    final p = price.trim();
    if (w.isEmpty || p.isEmpty) return;
    final product = _productById(productId);
    if (product == null) return;
    product.variants.add(ProductVariantModel(weight: w, price: p));
    _productRepository.saveProduct(product);
  }

  void updateVariant(
    String productId,
    int variantIndex,
    String weight,
    String price,
  ) {
    final w = weight.trim();
    final p = price.trim();
    if (w.isEmpty || p.isEmpty) return;
    final product = _productById(productId);
    if (product == null) return;
    if (variantIndex < 0 || variantIndex >= product.variants.length) return;
    product.variants[variantIndex].weight = w;
    product.variants[variantIndex].price = p;
    _productRepository.saveProduct(product);
  }

  void editVariant(String productId, int variantIndex) {
    final product = _productById(productId);
    if (product == null) return;
    if (variantIndex < 0 || variantIndex >= product.variants.length) return;
    showVariantSheet(productId, variantIndex: variantIndex);
  }

  void deleteVariant(String productId, int variantIndex) {
    final product = _productById(productId);
    if (product == null) return;
    if (variantIndex < 0 || variantIndex >= product.variants.length) return;
    product.variants.removeAt(variantIndex);
    _productRepository.saveProduct(product);
  }

  void showVariantSheet(String productId, {int? variantIndex}) {
    final ctx = Get.context;
    if (ctx == null) return;
    VariantSheet.show(ctx, productId, variantIndex: variantIndex);
  }

  ProductModel? _productById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}

