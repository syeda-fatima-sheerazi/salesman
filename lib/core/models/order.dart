import 'package:practices/core/models/order_item.dart';

/// Complete Order model — supports display, draft building, and API.
class Order {
  Order({
    this.id,
    required this.shopId,
    required this.shopName,
    required this.ownerName,
    required this.cell,
    required this.items,
    this.shopPhotoAsset,
    this.createdBy,
    this.orderNo,
    this.isDelivered = false,
    required this.orderDate,
    this.remainingAmount = 0,
    this.isCollected = false,
    required this.totalBill,
    this.collectedAmount = 0,
    this.deliveryDate,
    this.paymentDate,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String? id;
  final String shopId;
  final String? createdBy;
  final String shopName;
  final String ownerName;
  final String cell;
  final String? shopPhotoAsset;
  final String? orderNo;
  final List<OrderItem> items;
  bool isDelivered;
  final DateTime orderDate;
  int remainingAmount;
  bool isCollected;
  final int totalBill;
  int collectedAmount;
  DateTime? deliveryDate;
  DateTime? paymentDate;
  String? notes;
  final DateTime createdAt;

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.qty);
  String get displayShopPhotoAsset =>
      shopPhotoAsset ?? 'assets/images/shop.png';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shopId': shopId,
      'createdBy': createdBy,
      'shopName': shopName,
      'ownerName': ownerName,
      'cell': cell,
      'shopPhotoAsset': shopPhotoAsset,
      'orderNo': orderNo,
      'isDelivered': isDelivered,
      'orderDate': orderDate?.toIso8601String(),
      'remainingAmount': remainingAmount,
      'isCollected': isCollected,
      'totalBill': totalBill,
      'collectedAmount': collectedAmount,
      'deliveryDate': deliveryDate?.toIso8601String(),
      'paymentDate': paymentDate?.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      shopId: map['shopId'],
      createdBy: map['createdBy'],
      shopName: map['shopName'],
      ownerName: map['ownerName'],
      cell: map['cell'],
      shopPhotoAsset: map['shopPhotoAsset'],
      orderNo: map['orderNo'],
      isDelivered: map['isDelivered'] ?? false,
      orderDate: map['orderDate'],

      remainingAmount: map['remainingAmount'] ?? 0,
      isCollected: map['isCollected'] ?? false,
      totalBill: map['totalBill'] ?? 0,
      collectedAmount: map['collectedAmount'] ?? 0,
      deliveryDate: map['deliveryDate'] != null
          ? DateTime.parse(map['deliveryDate'])
          : null,
      paymentDate: map['paymentDate'] != null
          ? DateTime.parse(map['paymentDate'])
          : null,
      notes: map['notes'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      items: List<OrderItem>.from(
        (map['items'] as List?)?.map((item) => OrderItem.fromMap(item)) ?? [],
      ),
    );
  }
}
