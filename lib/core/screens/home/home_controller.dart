import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:practices/core/screens/home/detailed/detailed_view.dart';

class HomeController extends GetxController {
  void gotoDetailedView() {
    Get.to(DetailedView());
  }

  RxString selectedDistrict = "".obs;
  RxString selectedTown = "".obs;
  RxString selectedArea = "".obs;

  List<String> districts = ['Karachi', 'Lahore', 'Islamabad'];
  Map<String, dynamic> towns = {
    'Karachi': ['Gulshan-e-Iqbal', 'Saddar', 'North Nazimabad'],
    'Lahore': ['Model Town', 'Gulberg'],
    'Islamabad': ['F-6', 'G-10'],
  };
  Map<String, dynamic> areas = {
    'Gulshan-e-Iqbal': ['Block 1', 'Block 2'],
    'Saddar': ['Area A', 'Area B'],
    'North Nazimabad': ['Sector 1', 'Sector 2'],
    'Model Town': ['Zone 1'],
    'Gulberg': ['Zone A'],
    'F-6': ['Sector F6/1'],
    'G-10': ['Sector G10/2'],
  };
}
