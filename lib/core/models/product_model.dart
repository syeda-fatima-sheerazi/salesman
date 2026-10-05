class ProductVariantModel {
  ProductVariantModel({
    required this.weight,
    required this.price,
  });

  String weight;
  String price;

  Map<String, dynamic> toFirestore() => {'weight': weight, 'price': price};

  factory ProductVariantModel.fromFirestore(Map<String, dynamic> data) {
    return ProductVariantModel(
      weight: data['weight'] ?? '',
      price: data['price'] ?? '',
    );
  }
}

class ProductModel {
  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.variants,
    this.createdBy,
  });

  final String id;
  String name;
  String imageUrl;
  List<ProductVariantModel> variants;
  final String? createdBy;

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'variants': variants.map((v) => v.toFirestore()).toList(),
    };
  }

  factory ProductModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ProductModel(
      id: id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      variants: (data['variants'] as List<dynamic>?)
              ?.map(
                  (v) => ProductVariantModel.fromFirestore(v as Map<String, dynamic>))
              .toList() ??
          [],
      createdBy: data['createdBy'],
    );
  }
}

