import 'package:get/get.dart';
import 'package:practices/core/models/product_model.dart';

class ProductController extends GetxController {
  final RxString searchQuery = ''.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyProducts();
  }

  void _loadDummyProducts() {
    products.assignAll([
      ProductModel(
        id: '1',
        name: 'Different Ketchup',
        imageUrl:
            'https://www.pngmart.com/files/Ketchup-Bottle-PNG-Transparent-Image.png',
        variants: [
          ProductVariantModel(weight: '1 KG', price: 'Rs 350'),
          ProductVariantModel(weight: '500g', price: 'Rs 200'),
          ProductVariantModel(weight: '250g', price: 'Rs 100'),
        ],
      ),
      ProductModel(
        id: '2',
        name: 'Nihari Masala',
        imageUrl:
            'https://www.pngall.com/wp-content/uploads/5/Masala-Powder-PNG.png',
        variants: [
          ProductVariantModel(weight: '250g', price: 'Rs 180'),
          ProductVariantModel(weight: '100g', price: 'Rs 80'),
          ProductVariantModel(weight: '50g', price: 'Rs 50'),
        ],
      ),
      ProductModel(
        id: '3',
        name: 'Mix Achar',
        imageUrl:
            'https://www.pngall.com/wp-content/uploads/5/Pickle-Jar-PNG.png',
        variants: [
          ProductVariantModel(weight: '5 KG Bucket', price: 'Rs 1100'),
          ProductVariantModel(weight: '1 KG Jar', price: 'Rs 240'),
          ProductVariantModel(weight: '500g Jar', price: 'Rs 130'),
        ],
      ),
    ]);
  }

  List<ProductModel> get filteredProducts {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return products.toList();
    return products
        .where((p) => p.name.toLowerCase().contains(q))
        .toList();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void addProduct() {
    // TODO: navigate to add product / show bottom sheet
  }

  void addVariant(String productId) {
    final product = _productById(productId);
    if (product == null) return;
    product.variants.add(ProductVariantModel(weight: 'New', price: 'Rs 0'));
    products.refresh();
  }

  void editVariant(String productId, int variantIndex) {
    final product = _productById(productId);
    if (product == null) return;
    if (variantIndex < 0 || variantIndex >= product.variants.length) return;
    // TODO: open edit dialog
  }

  void deleteVariant(String productId, int variantIndex) {
    final product = _productById(productId);
    if (product == null) return;
    if (variantIndex < 0 || variantIndex >= product.variants.length) return;
    product.variants.removeAt(variantIndex);
    products.refresh();
  }

  ProductModel? _productById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
