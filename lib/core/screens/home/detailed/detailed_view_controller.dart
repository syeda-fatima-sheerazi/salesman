import 'package:get/get.dart';
import 'package:practices/core/models/shop.dart';
import 'package:practices/core/routes/route_names.dart';

class DetailedViewController extends GetxController {
  void gotoPlaceOrderView(Shop shop) {
    Get.toNamed(Routes.placeOrder, arguments: shop);
  }
}
