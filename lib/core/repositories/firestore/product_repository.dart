import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sales_man/core/models/product_model.dart';
import 'package:sales_man/core/repositories/i_product_repository.dart';
import 'package:sales_man/core/services/auth_service.dart';

class ProductRepository implements IProductRepository {
  final FirebaseFirestore _firestore;
  final AuthService _authService;

  ProductRepository({
    FirebaseFirestore? firestore,
    required AuthService authService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _authService = authService;

  String get _uid {
    final user = _authService.currentUser;
    if (user == null) throw StateError('No authenticated user');
    return user.id;
  }

  CollectionReference get _productsRef =>
      _firestore.collection('users').doc(_uid).collection('products');

  @override
  Stream<List<ProductModel>> getProducts() {
    return _productsRef.snapshots().map(
      (snap) => snap.docs
          .map((doc) =>
              ProductModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ProductModel?> getProduct(String id) async {
    final doc = await _productsRef.doc(id).get();
    if (!doc.exists) return null;
    return ProductModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> saveProduct(ProductModel product) async {
    final ref = _productsRef.doc(product.id);
    await ref.set(product.toFirestore());
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _productsRef.doc(id).delete();
  }
}
