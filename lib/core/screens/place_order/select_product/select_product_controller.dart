import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practices/core/models/order_item.dart';
import 'package:practices/core/models/product_model.dart';
import 'package:practices/core/screens/place_order/place_order_controller.dart';

class SelectProductController extends GetxController {
  final PlaceOrderController _placeOrderController;

  SelectProductController({PlaceOrderController? placeOrderController})
    : _placeOrderController =
          placeOrderController ?? Get.find<PlaceOrderController>();

  final RxString searchQuery = ''.obs;
  final searchController = TextEditingController();

  // Local selection state (items being added in this session)
  final RxList<OrderItem> tempSelectedItems = <OrderItem>[].obs;

  List<ProductModel> get filteredProducts {
    final query = searchQuery.value.toLowerCase().trim();
    final allProducts = _placeOrderController.products;
    if (query.isEmpty) return allProducts.toList();
    return allProducts
        .where((p) => p.name.toLowerCase().contains(query))
        .toList();
  }

  int get selectedCount => tempSelectedItems.length;

  int get totalSelected => tempSelectedItems.fold(0, (sum, i) => sum + i.qty);

  int get totalAmount =>
      tempSelectedItems.fold(0, (sum, i) => sum + (i.price * i.qty).toInt());

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  void incrementTempItem(int index) {
    final item = tempSelectedItems[index];
    tempSelectedItems[index] = item.copyWith(qty: item.qty + 1);
  }

  void decrementTempItem(int index) {
    final item = tempSelectedItems[index];
    if (item.qty <= 1) {
      tempSelectedItems.removeAt(index);
    } else {
      tempSelectedItems[index] = item.copyWith(qty: item.qty - 1);
    }
  }

  void addProductToSelection(
    ProductModel product,
    ProductVariantModel variant,
  ) {
    final existingIndex = tempSelectedItems.indexWhere(
      (i) => i.productId == product.id && i.variant == variant.weight,
    );
    if (existingIndex >= 0) {
      final existing = tempSelectedItems[existingIndex];
      tempSelectedItems[existingIndex] = existing.copyWith(
        qty: existing.qty + 1,
      );
    } else {
      tempSelectedItems.add(
        OrderItem(
          productId: product.id,
          productName: product.name,
          qty: 1,
          price: variant.numericPrice,
          variant: variant.weight,
          imageUrl: product.imageUrl,
        ),
      );
    }
  }

  void confirmSelection() {
    // Add all temp items to the place order controller's cart
    for (final item in tempSelectedItems) {
      _placeOrderController.addToCart(item);
    }
    Get.back();
  }
}
