import 'package:get/instance_manager.dart';
import 'package:practices/core/screens/products/product_controller.dart';

class ProductViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
