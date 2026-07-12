import 'package:get/get.dart';
import 'package:practices/core/models/shop.dart';
import 'package:practices/core/screens/home/detailed/detailed_view_controller.dart';

class DetailedViewBinding extends Bindings {
  @override
  void dependencies() {
    final shop = Get.arguments as Shop;
    Get.put<DetailedViewController>(DetailedViewController(shop: shop));
  }
}
