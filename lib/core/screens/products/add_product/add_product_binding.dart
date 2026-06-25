import 'package:get/get.dart';
import 'package:practices/core/screens/products/add_product/add_product_controller.dart';

class AddProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddProductController>(AddProductController());
  }
}
