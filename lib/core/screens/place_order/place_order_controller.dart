import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practices/core/models/order.dart';
import 'package:practices/core/models/order_attachment.dart';
import 'package:practices/core/models/order_item.dart';
import 'package:practices/core/models/product_model.dart';
import 'package:practices/core/models/shop.dart';
import 'package:practices/core/routes/route_names.dart';
import 'package:practices/core/screens/orders/repositories/order_repository.dart';

class PlaceOrderController extends GetxController {
  final OrderRepository _orderRepository;

  PlaceOrderController({OrderRepository? orderRepository})
    : _orderRepository = orderRepository ?? OrderRepository();

  // ─── Shop & Order Info ───────────────────────────────────────
  late Shop shop;
  final orderDate = DateTime.now();

  // ─── Cart State ──────────────────────────────────────────────
  final RxList<OrderItem> selectedItems = <OrderItem>[].obs;

  // ─── Order Fields ────────────────────────────────────────────
  final collectedAmountController = TextEditingController(text: '0');
  final paymentStatus = 'Pending'.obs;
  final paymentDate = Rxn<DateTime>();
  final deliveryStatus = 'Scheduled'.obs;
  final deliveryDate = Rxn<DateTime>();
  final notesController = TextEditingController();
  final RxList<String> attachments = <String>[].obs;

  // ─── Quick Order Mode ────────────────────────────────────────
  final RxBool isQuickOrder = false.obs;
  final quickOrderTotalController = TextEditingController(text: '0');

  // ─── Product Catalog ─────────────────────────────────────────
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxString searchQuery = ''.obs;
  final searchController = TextEditingController();

  // ─── Computed Getters ────────────────────────────────────────
  int get totalBill {
    if (isQuickOrder.value) {
      return int.tryParse(quickOrderTotalController.text) ?? 0;
    }
    return selectedItems.fold(
      0,
      (sum, item) => sum + (item.price * item.qty).toInt(),
    );
  }

  int get collectedAmount => int.tryParse(collectedAmountController.text) ?? 0;

  int get remainingAmount => totalBill - collectedAmount;

  bool get hasProducts => selectedItems.isNotEmpty;

  List<ProductModel> get filteredProducts {
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) return products.toList();
    return products.where((p) => p.name.toLowerCase().contains(query)).toList();
  }

  bool get canSave {
    if (shop.id == null || shop.id!.isEmpty) return false;
    if (!isQuickOrder.value && selectedItems.isEmpty) return false;
    if (totalBill <= 0) return false;
    if (collectedAmount < 0) return false;
    if (collectedAmount > totalBill) return false;
    return true;
  }

  String get validationMessage {
    if (shop.id == null || shop.id!.isEmpty) return 'Shop not found';
    if (!isQuickOrder.value && selectedItems.isEmpty) {
      return 'Please add at least one product';
    }
    if (totalBill <= 0) return 'Total bill must be greater than 0';
    if (collectedAmount < 0) return 'Collected amount cannot be negative';
    if (collectedAmount > totalBill) {
      return 'Collected amount cannot exceed total bill';
    }
    return 'Please fill all required fields';
  }

  // ─── Init ────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    shop = Get.arguments as Shop;
    _loadDummyProducts();
  }

  @override
  void onClose() {
    collectedAmountController.dispose();
    notesController.dispose();
    searchController.dispose();
    quickOrderTotalController.dispose();
    super.onClose();
  }

  void _loadDummyProducts() {
    products.assignAll([
      ProductModel(
        id: '1',
        name: 'National Flour',
        imageUrl: 'assets/images/ketchup.jpg',
        variants: [
          ProductVariantModel(weight: '20 KG', price: 'Rs 1200'),
          ProductVariantModel(weight: '10 KG', price: 'Rs 650'),
          ProductVariantModel(weight: '5 KG', price: 'Rs 350'),
        ],
      ),
      ProductModel(
        id: '2',
        name: 'Cooking Oil',
        imageUrl: 'assets/images/nihari_masala.jpg',
        variants: [
          ProductVariantModel(weight: '1 Ltr', price: 'Rs 380'),
          ProductVariantModel(weight: '3 Ltr', price: 'Rs 1050'),
          ProductVariantModel(weight: '5 Ltr', price: 'Rs 1700'),
        ],
      ),
      ProductModel(
        id: '3',
        name: 'Sugar',
        imageUrl: 'assets/images/mix_achar.jpg',
        variants: [
          ProductVariantModel(weight: '1 KG', price: 'Rs 160'),
          ProductVariantModel(weight: '5 KG', price: 'Rs 750'),
          ProductVariantModel(weight: '10 KG', price: 'Rs 1400'),
        ],
      ),
      ProductModel(
        id: '4',
        name: 'Rice Super Kernel',
        imageUrl: 'assets/images/ketchup.jpg',
        variants: [
          ProductVariantModel(weight: '5 KG', price: 'Rs 750'),
          ProductVariantModel(weight: '10 KG', price: 'Rs 1400'),
          ProductVariantModel(weight: '20 KG', price: 'Rs 2700'),
        ],
      ),
    ]);
  }

  // ─── Search ──────────────────────────────────────────────────
  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  // ─── Navigation ──────────────────────────────────────────────
  void goToSelectProductView() {
    Get.toNamed(Routes.selectproduct);
  }

  void goToQuickOrder() {
    Get.toNamed(Routes.quickOrder);
  }

  void goToEditProducts() {
    Get.toNamed(Routes.addProduct);
  }

  // ─── Cart Operations ─────────────────────────────────────────
  void addToCart(OrderItem item) {
    final existingIndex = selectedItems.indexWhere(
      (i) => i.productId == item.productId && i.variant == item.variant,
    );
    if (existingIndex >= 0) {
      final existing = selectedItems[existingIndex];
      selectedItems[existingIndex] = existing.copyWith(
        qty: existing.qty + item.qty,
      );
    } else {
      selectedItems.add(item);
    }
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < selectedItems.length) {
      selectedItems.removeAt(index);
    }
  }

  void updateQuantity(int index, int delta) {
    if (index < 0 || index >= selectedItems.length) return;
    final item = selectedItems[index];
    final newQty = item.qty + delta;
    if (newQty < 1) {
      selectedItems.removeAt(index);
    } else {
      selectedItems[index] = item.copyWith(qty: newQty);
    }
  }

  // ─── Quick Order ─────────────────────────────────────────────
  void enterQuickOrderMode(int total) {
    isQuickOrder.value = true;
    quickOrderTotalController.text = total.toString();
  }

  void setQuickOrderTotal(int total) {
    quickOrderTotalController.text = total.toString();
  }

  // ─── Status Handlers ─────────────────────────────────────────
  void onPaymentStatusChanged(String value) {
    paymentStatus.value = value;
    if (value == 'Paid') {
      paymentDate.value = DateTime.now();
    } else {
      paymentDate.value = null;
    }
  }

  void onPaymentDateChanged(DateTime date) {
    paymentDate.value = date;
  }

  void onDeliveryStatusChanged(String value) {
    deliveryStatus.value = value;
    if (value == 'Delivered') {
      deliveryDate.value = DateTime.now();
    } else {
      deliveryDate.value = null;
    }
  }

  void onDeliveryDateChanged(DateTime date) {
    deliveryDate.value = date;
  }

  // ─── Collected Amount ────────────────────────────────────────
  void onCollectedAmountChanged(String value) {
    collectedAmountController.text = value;
    collectedAmountController.selection = TextSelection.fromPosition(
      TextPosition(offset: value.length),
    );
    update(['summary']);
  }

  // ─── Attachments ─────────────────────────────────────────────
  void addAttachment(String path) {
    if (!attachments.contains(path)) {
      attachments.add(path);
    }
  }

  void removeAttachment(int index) {
    if (index >= 0 && index < attachments.length) {
      attachments.removeAt(index);
    }
  }

  // ─── Save Order ──────────────────────────────────────────────
  Future<void> saveOrder() async {
    if (!canSave) {
      Get.snackbar(
        'Validation Error',
        validationMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final order = Order(
        shopId: shop.id!,
        shopName: shop.shopName,
        ownerName: shop.shopOwner,
        cell: shop.cellPhone,
        shopPhotoAsset: shop.shopImagUrl,
        items: selectedItems.toList(),
        totalBill: totalBill,
        collectedAmount: collectedAmount,
        remainingAmount: remainingAmount,
        isDelivered: deliveryStatus.value == 'Delivered',
        isCollected: paymentStatus.value == 'Paid',
        orderDate: orderDate,
        deliveryDate: deliveryDate.value,
        paymentDate: paymentDate.value,
        notes: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
      );

      await _orderRepository.insertOrder(order);

      for (final path in attachments) {
        await _orderRepository.insertAttachment(
          OrderAttachment(orderId: order.id ?? '', filePath: path),
        );
      }

      Get.offAllNamed(
        Routes.orderSuccess,
        arguments: {'orderId': order.id, 'shop': shop},
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save order: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ─── Reset ───────────────────────────────────────────────────
  void resetOrder() {
    selectedItems.clear();
    collectedAmountController.text = '0';
    paymentStatus.value = 'Pending';
    paymentDate.value = null;
    deliveryStatus.value = 'Scheduled';
    deliveryDate.value = null;
    notesController.clear();
    attachments.clear();
    isQuickOrder.value = false;
    quickOrderTotalController.text = '0';
  }
}
