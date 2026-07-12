import 'package:get/get.dart';
import 'package:practices/core/enums/data_state.dart';
import 'package:practices/core/models/shop.dart';
import 'package:practices/core/routes/route_names.dart';
import 'package:practices/core/screens/add_shop/repositories/shop_repository.dart';
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

  final ShopRepository _shopRepository = Get.find<ShopRepository>();
  final LocationService _locationService = LocationService();

  @override
  void onInit() {
    super.onInit();
    _loadLocationData();
    loadShops();
  }

  Future<void> _loadLocationData() async {
    dataState.value = DataState.loading;
    districts = await _locationService.fetchDistricts();
    towns = await _locationService.fetchTowns();
    areas = await _locationService.fetchAreas();
    dataState.value = DataState.loaded;
    update();
  }

  Future<void> loadShops() async {
    final shops = await _shopRepository.getAllShops();
    shopList.assignAll(shops);
  }

  void gotoDetailedView(Shop shop) {
    Get.toNamed(Routes.detailed, arguments: shop);
  }

  void toggleVisited(bool isVisited, String shopId) {
    //TODO: if shop is visited false he to true krna Hai
  }
}
