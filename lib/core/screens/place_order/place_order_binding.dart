import 'package:get/get.dart';
import 'package:practices/core/screens/place_order/place_order_controller.dart';

class PlaceOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PlaceOrderController>(PlaceOrderController());
  }
}
