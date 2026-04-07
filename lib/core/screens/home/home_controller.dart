import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:practices/core/models/shop.dart';
import 'package:practices/core/screens/home/detailed/detailed_view.dart';

class HomeController extends GetxController {
  RxString selectedDistrict = "".obs;
  RxString selectedTown = "".obs;
  RxString selectedArea = "".obs;
  final RxList<Shop?> shops = <Shop?>[].obs;

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

  @override
  void onInit() {
    super.onInit();
    loadDummyShops();
  }

  void loadDummyShops() {
    shops.assignAll([
      Shop(
        isVisited: true,
        shopName: 'Shop 1',
        shopOwner: 'Owner 1',
        cellPhone: '0303684795739',
        shopImagUrl:
            'https://img.freepik.com/premium-vector/shops-stores-icons-set-flat-design-style-vector-illustration_498048-1862.jpg?semt=ais_hybrid&w=740&q=80',
        address: 'Address 1',
      ),
      Shop(
        shopName: 'Shop 2',
        shopOwner: 'Owner 2',
        cellPhone: '0303684795739',
        shopImagUrl:
            'https://img.freepik.com/premium-vector/shops-stores-icons-set-flat-design-style-vector-illustration_498048-1862.jpg?semt=ais_hybrid&w=740&q=80',
        address: 'Address 2',
      ),
      Shop(
        shopName: 'Shop 3',
        shopOwner: 'Owner 3',
        cellPhone: '0303684795739',
        shopImagUrl:
            'https://img.freepik.com/premium-vector/shops-stores-icons-set-flat-design-style-vector-illustration_498048-1862.jpg?semt=ais_hybrid&w=740&q=80',
        address: 'Address 3',
      ),
      Shop(
        shopName: 'Shop 4',
        shopOwner: 'Owner 4',
        cellPhone: '0303684795739',
        shopImagUrl:
            'https://img.freepik.com/premium-vector/shops-stores-icons-set-flat-design-style-vector-illustration_498048-1862.jpg?semt=ais_hybrid&w=740&q=80',
        address: 'Address 4',
      ),
      Shop(
        shopName: 'Shop 5',
        shopOwner: 'Owner 5',
        cellPhone: '0303684795739',
        shopImagUrl:
            'https://img.freepik.com/premium-vector/shops-stores-icons-set-flat-design-style-vector-illustration_498048-1862.jpg?semt=ais_hybrid&w=740&q=80',
        address: 'Address 5',
      ),
      Shop(
        shopName: 'Shop 6',
        shopOwner: 'Owner 6',
        cellPhone: '0303684795739',
        shopImagUrl:
            'https://img.freepik.com/premium-vector/shops-stores-icons-set-flat-design-style-vector-illustration_498048-1862.jpg?semt=ais_hybrid&w=740&q=80',
        address: 'Address 6',
      ),
      Shop(
        shopName: 'Shop 7',
        shopOwner: 'Owner 7',
        cellPhone: '0303684795739',
        shopImagUrl:
            'https://img.freepik.com/premium-vector/shops-stores-icons-set-flat-design-style-vector-illustration_498048-1862.jpg?semt=ais_hybrid&w=740&q=80',
        address: 'Address 7',
      ),
      Shop(
        shopName: 'Shop 8',
        shopOwner: 'Owner 8',
        cellPhone: '0303684795739',
        shopImagUrl:
            'https://img.freepik.com/premium-vector/shops-stores-icons-set-flat-design-style-vector-illustration_498048-1862.jpg?semt=ais_hybrid&w=740&q=80',
        address: 'Address 8',
      ),
      Shop(
        shopName: 'Shop 9',
        shopOwner: 'Owner 9',
        cellPhone: '0303684795739',
        shopImagUrl:
            'https://img.freepik.com/premium-vector/shops-stores-icons-set-flat-design-style-vector-illustration_498048-1862.jpg?semt=ais_hybrid&w=740&q=80',
        address: 'Address 9',
      ),
      Shop(
        shopName: 'Shop 10',
        shopOwner: 'Owner 10',
        cellPhone: '0303684795739',
        shopImagUrl:
            'https://img.freepik.com/premium-vector/shops-stores-icons-set-flat-design-style-vector-illustration_498048-1862.jpg?semt=ais_hybrid&w=740&q=80',
        address: 'Address 10',
      ),
    ]);
  }

  void gotoDetailedView() {
    Get.to(DetailedView());
  }
}
