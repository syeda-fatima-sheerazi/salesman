import 'package:sales_man/core/models/order.dart';

abstract class IOrderRepository {
  Stream<List<Order>> getOrders();
  Future<Order?> getOrder(String id);
  Future<void> saveOrder(Order order);
  Future<void> deleteOrder(String id);
  Stream<List<Order>> getOrdersByShop(String shopId);
  Stream<List<Order>> getPendingDeliveries();
  Stream<List<Order>> getPendingCollections();
}
