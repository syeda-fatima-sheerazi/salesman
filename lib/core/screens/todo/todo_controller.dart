import 'dart:async';

import 'package:get/get.dart';
import 'package:practices/core/dialogs/app_result_dialog.dart';
import 'package:practices/core/enums/app_dialog_variant.dart';
import 'package:practices/core/models/order.dart';
import 'package:practices/core/screens/orders/repositories/order_repository.dart';

class TodoController extends GetxController {
  final OrderRepository _orderRepository = OrderRepository();
  final RxInt mainTabIndex = 0.obs;
  final RxList<Order> orders = <Order>[].obs;
  final RxList<Order> collections = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTodayData();
  }

  Future<void> loadTodayData() async {
    final today = DateTime.now();
    final todayOrders = await _orderRepository.getOrdersByDeliveryDate(today);
    orders.assignAll(todayOrders.where((o) => !o.isDelivered));

    final todayCollections =
        await _orderRepository.getOrdersByPaymentDate(today);
    collections.assignAll(
        todayCollections.where((o) => !o.isCollected || o.collectedAmount < o.totalBill));
  }

  Future<void> updateCollectionState(Order c) async {
    c.isCollected = true;
    c.paymentDate = DateTime.now();
    await _orderRepository.updateOrder(c);
    collections.refresh();
    await showDialoge();
    collections.remove(c);
    await loadTodayData();
  }

  Future<void> updateOrderState(Order o) async {
    o.isDelivered = true;
    o.deliveryDate = DateTime.now();
    await _orderRepository.updateOrder(o);
    orders.refresh();
    await showDialoge();
    orders.remove(o);
    await loadTodayData();
  }

  void onChangeTabIndex(int index) {
    mainTabIndex.value = index;
  }

  Future<void> showDialoge() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    unawaited(
      AppResultDialog.show<void>(
        variant: AppDialogVariant.success,
        title: '',
        message: 'Successfully completed and saved.',
        showPrimaryButton: false,
        barrierDismissible: false,
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 1300));

    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  void onEditOrder(Order item) {
    Get.toNamed('/order-detail', arguments: item.id);
  }

  void onEditCollection(Order item) {
    Get.toNamed('/order-detail', arguments: item.id);
  }
}
