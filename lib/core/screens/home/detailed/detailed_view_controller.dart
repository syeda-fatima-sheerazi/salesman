import 'package:get/get.dart';
import 'package:sales_man/core/models/shop.dart';
import 'package:sales_man/core/routes/route_names.dart';

class DetailedViewController extends GetxController {
  void gotoPlaceOrderView(Shop shop) {
    Get.toNamed(Routes.placeOrder, arguments: shop);
  }
}

