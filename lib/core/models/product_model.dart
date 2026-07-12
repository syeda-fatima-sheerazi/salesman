class ProductVariantModel {
  ProductVariantModel({
    required this.weight,
    required this.price,
  });

  String weight;
  String price;

  double get numericPrice {
    final cleaned = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0;
  }
}

class ProductModel {
  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.variants,
  });

  final String id;
  String name;
  String imageUrl;
  List<ProductVariantModel> variants;
}
