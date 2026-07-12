import 'package:get/get.dart';
import 'package:practices/core/models/order.dart';
import 'package:practices/core/models/shop.dart';
import 'package:practices/core/routes/route_names.dart';
import 'package:practices/core/screens/orders/repositories/order_repository.dart';

class DetailedViewController extends GetxController {
  final Shop shop;
  final OrderRepository _orderRepository = OrderRepository();
  final RxList<Order> orders = <Order>[].obs;

  DetailedViewController({required this.shop});

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final loaded = await _orderRepository.getOrdersByShopId(shop.id ?? '');
    orders.assignAll(loaded);
  }

  List<Order> get collections =>
      orders.where((o) => !o.isCollected || o.collectedAmount < o.totalBill).toList();

  void gotoPlaceOrderView(Shop shop) {
    Get.toNamed(Routes.placeOrder, arguments: shop)?.then((_) => loadOrders());
  }
}
