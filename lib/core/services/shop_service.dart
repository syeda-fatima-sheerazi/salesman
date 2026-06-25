import 'package:practices/core/models/order.dart';
import 'package:practices/core/models/order_item.dart';
import 'package:practices/core/models/shop.dart';

class ShopService {
  /// Returns a list of dummy shops (simulates network/db).
  Future<List<Shop>> fetchDummyShops() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return [
      Shop(
        isVisited: true,
        shopName: 'shop name',
        shopOwner: 'Owner name',
        cellPhone: '0303684795739',
        address: 'Address 1',
      ),
      Shop(
        shopName: 'Shop name',
        shopOwner: 'Owner name',
        cellPhone: '0303684795739',
        address: 'Address 2',
        orders: [
          Order(
            totalBill: 300,
            items: [
              OrderItem(
                productId: "2",
                productName: "KatchUp",
                qty: 2,
                price: 99,
              ),
            ],
            cell: "",
            ownerName: 'Owner name',
            shopName: 'Shop name',
            shopId: 'shop2',
            id: 'order1',
          ),
          Order(
            shopId: "1",
            shopName: "Shop name",
            ownerName: "Owner name",
            cell: '0303684795739',
            items: [
              OrderItem(
                productId: "3",
                productName: "Achar",
                qty: 5,
                price: 100,
              ),
            ],
            totalBill: 500,
          ),
        ],
      ),
    ];
  }
}
