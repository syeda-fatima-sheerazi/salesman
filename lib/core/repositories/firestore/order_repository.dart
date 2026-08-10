import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:sales_man/core/models/order.dart';
import 'package:sales_man/core/repositories/i_order_repository.dart';
import 'package:sales_man/core/services/auth_service.dart';

class OrderRepository implements IOrderRepository {
  final FirebaseFirestore _firestore;
  final AuthService _authService;

  OrderRepository({
    FirebaseFirestore? firestore,
    required AuthService authService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _authService = authService;

  String get _uid {
    final user = _authService.currentUser;
    if (user == null) throw StateError('No authenticated user');
    return user.id;
  }

  CollectionReference get _ordersRef =>
      _firestore.collection('users').doc(_uid).collection('orders');

  @override
  Stream<List<Order>> getOrders() {
    return _ordersRef.snapshots().map(
      (snap) => snap.docs
          .map((doc) =>
              Order.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<Order?> getOrder(String id) async {
    final doc = await _ordersRef.doc(id).get();
    if (!doc.exists) return null;
    return Order.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> saveOrder(Order order) async {
    final ref = order.id != null ? _ordersRef.doc(order.id) : _ordersRef.doc();
    await ref.set(order.toFirestore());
  }

  @override
  Future<void> deleteOrder(String id) async {
    await _ordersRef.doc(id).delete();
  }

  @override
  Stream<List<Order>> getOrdersByShop(String shopId) {
    return _ordersRef
        .where('shopId', isEqualTo: shopId)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => Order.fromFirestore(
                  doc.id, doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  @override
  Stream<List<Order>> getPendingDeliveries() {
    return _ordersRef
        .where('isDelivered', isEqualTo: false)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => Order.fromFirestore(
                  doc.id, doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  @override
  Stream<List<Order>> getPendingCollections() {
    return _ordersRef
        .where('isCollected', isEqualTo: false)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => Order.fromFirestore(
                  doc.id, doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }
}
