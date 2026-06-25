import 'package:get/get.dart';
import 'package:practices/core/screens/products/product_controller.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
