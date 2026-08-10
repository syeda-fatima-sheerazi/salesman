import 'dart:async';

import 'package:get/get.dart';
import 'package:sales_man/core/dialogs/app_result_dialog.dart';
import 'package:sales_man/core/enums/app_dialog_variant.dart';
import 'package:sales_man/core/models/order.dart';
import 'package:sales_man/core/repositories/i_order_repository.dart';

class TodoController extends GetxController {
  final RxInt mainTabIndex = 0.obs;
  final RxList<Order> orders = <Order>[].obs;
  final RxList<Order> collections = <Order>[].obs;

  final IOrderRepository _orderRepository = Get.find();
  StreamSubscription? _deliverySubscription;
  StreamSubscription? _collectionSubscription;

  @override
  void onInit() {
    super.onInit();
    _subscribeToOrders();
  }

  @override
  void onClose() {
    _deliverySubscription?.cancel();
    _collectionSubscription?.cancel();
    super.onClose();
  }

  void _subscribeToOrders() {
    _deliverySubscription =
        _orderRepository.getPendingDeliveries().listen((list) {
      orders.assignAll(list);
    });
    _collectionSubscription =
        _orderRepository.getPendingCollections().listen((list) {
      collections.assignAll(list);
    });
  }

  Future<void> updateOrderState(Order o) async {
    final updated = Order(
      id: o.id,
      shopId: o.shopId,
      shopName: o.shopName,
      ownerName: o.ownerName,
      cell: o.cell,
      items: o.items,
      shopPhotoAsset: o.shopPhotoAsset,
      createdBy: o.createdBy,
      orderNo: o.orderNo,
      isDelivered: true,
      orderDate: o.orderDate,
      remainingAmount: o.remainingAmount,
      isCollected: o.isCollected,
      totalBill: o.totalBill,
      collectedAmount: o.collectedAmount,
    );
    await _orderRepository.saveOrder(updated);
    await showDialoge();
  }

  Future<void> updateCollectionState(Order c) async {
    final updated = Order(
      id: c.id,
      shopId: c.shopId,
      shopName: c.shopName,
      ownerName: c.ownerName,
      cell: c.cell,
      items: c.items,
      shopPhotoAsset: c.shopPhotoAsset,
      createdBy: c.createdBy,
      orderNo: c.orderNo,
      isDelivered: c.isDelivered,
      orderDate: c.orderDate,
      remainingAmount: c.remainingAmount,
      isCollected: true,
      totalBill: c.totalBill,
      collectedAmount: c.collectedAmount,
    );
    await _orderRepository.saveOrder(updated);
    await showDialoge();
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

  void onEditOrder(Order item) {}

  void onEditCollection(Order item) {}
}

