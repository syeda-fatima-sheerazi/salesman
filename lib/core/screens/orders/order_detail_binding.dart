import 'package:get/get.dart';
import 'package:practices/core/screens/orders/order_detail_controller.dart';

class OrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDetailController>(() => OrderDetailController(
          orderId: Get.arguments as String,
        ));
  }
}
