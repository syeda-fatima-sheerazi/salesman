import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sales_man/core/models/shop.dart';
import 'package:sales_man/core/repositories/i_shop_repository.dart';
import 'package:sales_man/core/services/auth_service.dart';

class ShopRepository implements IShopRepository {
  final FirebaseFirestore _firestore;
  final AuthService _authService;

  ShopRepository({
    FirebaseFirestore? firestore,
    required AuthService authService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _authService = authService;

  String get _uid {
    final user = _authService.currentUser;
    if (user == null) throw StateError('No authenticated user');
    return user.id;
  }

  CollectionReference get _shopsRef =>
      _firestore.collection('users').doc(_uid).collection('shops');

  @override
  Stream<List<Shop>> getShops() {
    return _shopsRef.snapshots().map(
      (snap) => snap.docs
          .map((doc) => Shop.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<Shop?> getShop(String id) async {
    final doc = await _shopsRef.doc(id).get();
    if (!doc.exists) return null;
    return Shop.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> saveShop(Shop shop) async {
    final ref = shop.id != null
        ? _shopsRef.doc(shop.id)
        : _shopsRef.doc();
    await ref.set(shop.toFirestore());
  }

  @override
  Future<void> deleteShop(String id) async {
    await _shopsRef.doc(id).delete();
  }
}
