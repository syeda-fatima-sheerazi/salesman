import 'package:get/get.dart';
import 'package:practices/core/screens/place_order/select_product/select_product_controller.dart';

class SelectProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SelectProductController>(SelectProductController());
  }
}
