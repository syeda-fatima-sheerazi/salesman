import 'package:sales_man/core/models/product_model.dart';

abstract class IProductRepository {
  Stream<List<ProductModel>> getProducts();
  Future<ProductModel?> getProduct(String id);
  Future<void> saveProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}
