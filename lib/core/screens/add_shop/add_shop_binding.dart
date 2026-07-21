import 'package:get/get.dart';
import 'package:sales_man/core/screens/add_shop/add_shop_controller.dart';

class AddShopBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddShopController>(AddShopController());
  }
}

