import 'package:sales_man/core/models/shop.dart';

abstract class IShopRepository {
  Stream<List<Shop>> getShops();
  Future<Shop?> getShop(String id);
  Future<void> saveShop(Shop shop);
  Future<void> deleteShop(String id);
}
