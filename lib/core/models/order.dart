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
    this.orderDate,
    this.remainingAmount = 0,
    this.isCollected = false,
    required this.totalBill,
    this.collectedAmount = 0,
  });

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
  final DateTime? orderDate;
  final int remainingAmount;
  bool isCollected;
  final int totalBill;
  final int collectedAmount;

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

      'items': items.map((item) => item.toMap()).toList(),
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
      isDelivered: map['isDelivered'],
      orderDate: map['orderDate'] != null
          ? DateTime.parse(map['orderDate'])
          : null,
      remainingAmount: map['remainingAmount'],
      isCollected: map['isCollected'],
      totalBill: map['totalBill'],
      collectedAmount: map['collectedAmount'],

      items: List<OrderItem>.from(
        (map['items'] as List).map((item) => OrderItem.fromMap(item)),
      ),
    );
  }
}
