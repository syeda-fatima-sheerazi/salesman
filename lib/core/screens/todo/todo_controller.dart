import 'dart:async';

import 'package:get/get.dart';
import 'package:practices/core/dialogs/app_result_dialog.dart';
import 'package:practices/core/enums/app_dialog_variant.dart';
import 'package:practices/core/models/order.dart';
import 'package:practices/core/models/order_item.dart';

class TodoController extends GetxController {
  final RxInt mainTabIndex = 0.obs;
  final RxList<Order> orders = <Order>[
    Order(
      shopId: 'shop_3',
      shopName: 'Metro Cash',
      ownerName: 'Imran',
      cell: '0300-5551212',
      shopPhotoAsset: 'assets/images/shop.png',
      orderNo: '#899',
      orderDate: DateTime(2026, 4, 30),
      items: const [
        OrderItem(
          productId: 'p4',
          productName: 'Ketchup 800g',
          qty: 6,
          price: 450,
        ),
        OrderItem(
          productId: 'p5',
          productName: 'Mix Achar',
          qty: 10,
          price: 280,
        ),
        OrderItem(
          productId: 'p6',
          productName: 'Nihari Masala',
          qty: 15,
          price: 120,
        ),
      ],
      totalBill: 7300,
      remainingAmount: 7300,
    ),
  ].obs;
  final RxList<Order> collections = <Order>[
    Order(
      shopId: 'shop_4',
      orderNo: '#900',
      items: [],
      shopName: 'Jawad Super Mart',
      ownerName: 'Jawad Khan',
      cell: '0300-1112233',
      remainingAmount: 18000,
      isCollected: false,
      totalBill: 22000,
      collectedAmount: 4000,
      shopPhotoAsset: 'assets/images/shop.png',
    ),
  ].obs;

  Future<void> updateCollectionState(Order c) async {
    c.isCollected = true;
    collections.refresh();
    await showDialoge();
    collections.remove(c);
    update();
  }

  Future<void> updateOrderState(Order o) async {
    o.isDelivered = true;
    orders.refresh();
    await showDialoge();
    orders.remove(o);
    update();
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
