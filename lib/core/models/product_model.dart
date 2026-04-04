class ProductVariantModel {
  ProductVariantModel({
    required this.weight,
    required this.price,
  });

  String weight;
  String price;
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
