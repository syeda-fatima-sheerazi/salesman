import 'dart:async';
import 'package:get/get.dart';
import 'package:sales_man/core/enums/data_state.dart';
import 'package:sales_man/core/models/shop.dart';
import 'package:sales_man/core/repositories/i_shop_repository.dart';
import 'package:sales_man/core/routes/route_names.dart';
import 'package:sales_man/core/services/location_service.dart';

class HomeController extends GetxController {
  final RxString selectedDistrict = "".obs;
  final RxString selectedTown = "".obs;
  final RxString selectedArea = "".obs;
  final RxList<Shop?> shopList = <Shop?>[].obs;
  final Rx<DataState> dataState = DataState.empty.obs;

  List<String> districts = [];
  Map<String, dynamic> towns = {};
  Map<String, dynamic> areas = {};

  final IShopRepository _shopRepository = Get.find();
  final LocationService _locationService = LocationService();
  StreamSubscription? _shopSubscription;

  @override
  void onInit() {
    super.onInit();
    _loadLocationData();
    _subscribeToShops();
  }

  @override
  void onClose() {
    _shopSubscription?.cancel();
    super.onClose();
  }

  void _subscribeToShops() {
    _shopSubscription = _shopRepository.getShops().listen((shops) {
      shopList.assignAll(shops);
    });
  }

  Future<void> _loadLocationData() async {
    dataState.value = DataState.loading;
    districts = await _locationService.fetchDistricts();
    towns = await _locationService.fetchTowns();
    areas = await _locationService.fetchAreas();
    dataState.value = DataState.loaded;
    update();
  }

  void gotoDetailedView(Shop shop) {
    Get.toNamed(Routes.detailed, arguments: shop);
  }

  void toggleVisited(bool isVisited, String shopId) {
    //TODO: if shop is visited false he to true krna Hai
  }
}

