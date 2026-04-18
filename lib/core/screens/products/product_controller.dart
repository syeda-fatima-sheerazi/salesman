import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practices/core/models/product_model.dart';
import 'package:practices/core/screens/products/add_product_view.dart';
import 'package:practices/core/screens/products/widgets/variant_sheet.dart';

class ProductController extends GetxController {
  final RxString searchQuery = ''.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final TextEditingController searchFieldController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadDummyProducts();
  }

  @override
  void onClose() {
    searchFieldController.dispose();
    super.onClose();
  }

  void _loadDummyProducts() {
    products.assignAll([
      ProductModel(
        id: '1',
        name: 'Different Ketchup',
        imageUrl: 'assets/images/ketchup.jpg',
        variants: [
          ProductVariantModel(weight: '1 KG', price: 'Rs 350'),
          ProductVariantModel(weight: '500g', price: 'Rs 200'),
          ProductVariantModel(weight: '250g', price: 'Rs 100'),
        ],
      ),
      ProductModel(
        id: '2',
        name: 'Nihari Masala',
        imageUrl: 'assets/images/nihari_masala.jpg',
        variants: [
          ProductVariantModel(weight: '250g', price: 'Rs 180'),
          ProductVariantModel(weight: '100g', price: 'Rs 80'),
          ProductVariantModel(weight: '50g', price: 'Rs 50'),
        ],
      ),
      ProductModel(
        id: '3',
        name: 'Mix Achar',
        imageUrl: 'assets/images/mix_achar.jpg',
        variants: [
          ProductVariantModel(weight: '5 KG Bucket', price: 'Rs 1100'),
          ProductVariantModel(weight: '1 KG Jar', price: 'Rs 240'),
          ProductVariantModel(weight: '500g Jar', price: 'Rs 130'),
        ],
      ),
    ]);
  }

  List<ProductModel> get filteredProducts {
    final searchValue = searchQuery.value.toLowerCase();

    if (searchValue.isEmpty) return products.toList();
    // filter the products based on the search value

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
    Get.to(() => const AddProductView());
  }

  void addVariant(String productId, String weight, String price) {
    final w = weight.trim();
    final p = price.trim();
    if (w.isEmpty || p.isEmpty) return;
    final product = _productById(productId);
    if (product == null) return;
    product.variants.add(ProductVariantModel(weight: w, price: p));
    products.refresh();
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
    products.refresh();
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
    products.refresh();
  }

  /// Add / edit variant — floating card ([VariantSheet.show]).
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
