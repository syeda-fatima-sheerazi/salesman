import 'package:get/get.dart';
import 'package:sales_man/core/screens/location_picker/location_picker_controller.dart';

class LocationPickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LocationPickerController>(LocationPickerController());
  }
}
