/// Single item in an order — product snapshot at order time.
class OrderItem {
  const OrderItem({
    required this.productId,
    required this.productName,
    required this.qty,
    required this.price,
    this.variant,
    this.imageUrl,
  });

  final String productId;
  final String productName;
  final int qty;
  final double price;
  final String? variant;
  final String? imageUrl;

  double get getTotalPrice => price * qty;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'qty': qty,
      'price': price,
      'variant': variant,
      'imageUrl': imageUrl,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'],
      productName: map['productName'],
      qty: map['qty'],
      price: map['price'],
      variant: map['variant'],
      imageUrl: map['imageUrl'],
    );
  }

  // OrderItem copyWith({
  //   String? productId,
  //   String? productName,
  //   int? qty,
  //   double? price,
  //   String? variant,
  //   String? imageUrl,
  // }) {
  //   return OrderItem(
  //     productId: productId ?? this.productId,
  //     productName: productName ?? this.productName,
  //     qty: qty ?? this.qty,
  //     price: price ?? this.price,
  //     variant: variant ?? this.variant,
  //     imageUrl: imageUrl ?? this.imageUrl,
  //   );
  // }
}
