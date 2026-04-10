import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:practices/core/enums/data_state.dart';
import 'package:practices/core/models/shop.dart';
import 'package:practices/core/screens/home/detailed/detailed_view.dart';
import 'package:practices/core/services/shop_service.dart';
import 'package:practices/core/services/location_service.dart';

class HomeController extends GetxController {
  final RxString selectedDistrict = "".obs;
  final RxString selectedTown = "".obs;
  final RxString selectedArea = "".obs;
  final RxList<Shop?> shopList = <Shop?>[].obs;
  final Rx<DataState> dataState = DataState.empty.obs;

  List<String> districts = [];
  Map<String, dynamic> towns = {};
  Map<String, dynamic> areas = {};

  final ShopService _shopService = ShopService();
  final LocationService _locationService = LocationService();

  @override
  void onInit() {
    super.onInit();
    _loadLocationData();
    loadDummyShops();
  }

  Future<void> _loadLocationData() async {
    dataState.value = DataState.loading;
    districts = await _locationService.fetchDistricts();
    towns = await _locationService.fetchTowns();
    areas = await _locationService.fetchAreas();
    dataState.value = DataState.loaded;
    update();
  }

  Future<void> loadDummyShops() async {
    final shops = await _shopService.fetchDummyShops();
    shopList.assignAll(shops);
    update();
  }

  void gotoDetailedView() {
    Get.to(DetailedView());
  }
}
