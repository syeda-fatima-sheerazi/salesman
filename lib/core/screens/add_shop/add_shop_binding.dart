import 'package:get/get.dart';
import 'package:practices/core/screens/add_shop/add_shop_controller.dart';
import 'package:practices/core/screens/add_shop/repositories/shop_repository.dart';

class AddShopBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ShopRepository>(ShopRepository());
    Get.put<AddShopController>(AddShopController());
  }
}
