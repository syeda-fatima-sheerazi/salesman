import 'package:get/get.dart';
import 'package:practices/core/screens/home/detailed/detailed_view_controller.dart';

class DetailedViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DetailedViewController>(DetailedViewController());
  }
}
