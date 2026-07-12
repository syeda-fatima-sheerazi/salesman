import 'package:get/get.dart';

class QuickOrderBinding extends Bindings {
  @override
  void dependencies() {
    // Quick Order reuses the existing PlaceOrderController
    // The controller is already registered from the PlaceOrder route
  }
}
