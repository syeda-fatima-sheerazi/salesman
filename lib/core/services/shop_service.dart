import 'package:practices/core/models/shop.dart';

class ShopService {
  /// Returns a list of dummy shops (simulates network/db).
  Future<List<Shop>> fetchDummyShops() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return [
      Shop(
        isVisited: true,
        shopName: 'Shop 1',
        shopOwner: 'Owner 1',
        cellPhone: '0303684795739',
        address: 'Address 1',
      ),
      Shop(
        shopName: 'Shop 2',
        shopOwner: 'Owner 2',
        cellPhone: '0303684795739',
        address: 'Address 2',
      ),
      Shop(
        shopName: 'Shop 3',
        shopOwner: 'Owner 3',
        cellPhone: '0303684795739',
        address: 'Address 3',
      ),
      Shop(
        shopName: 'Shop 4',
        shopOwner: 'Owner 4',
        cellPhone: '0303684795739',
        address: 'Address 4',
      ),
      Shop(
        shopName: 'Shop 5',
        shopOwner: 'Owner 5',
        cellPhone: '0303684795739',
        address: 'Address 5',
      ),
      Shop(
        shopName: 'Shop 6',
        shopOwner: 'Owner 6',
        cellPhone: '0303684795739',
        address: 'Address 6',
      ),
      Shop(
        shopName: 'Shop 7',
        shopOwner: 'Owner 7',
        cellPhone: '0303684795739',
        address: 'Address 7',
      ),
      Shop(
        shopName: 'Shop 8',
        shopOwner: 'Owner 8',
        cellPhone: '0303684795739',
        address: 'Address 8',
      ),
      Shop(
        shopName: 'Shop 9',
        shopOwner: 'Owner 9',
        cellPhone: '0303684795739',
        address: 'Address 9',
      ),
      Shop(
        shopName: 'Shop 10',
        shopOwner: 'Owner 10',
        cellPhone: '0303684795739',
        address: 'Address 10',
      ),
    ];
  }
}

