import 'package:sales_man/core/models/order_item.dart';

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

  Map<String, dynamic> toFirestore() {
    return {
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
      'items': items.map((item) => item.toFirestore()).toList(),
    };
  }

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

  factory Order.fromFirestore(String id, Map<String, dynamic> data) {
    return Order(
      id: id,
      shopId: data['shopId'] ?? '',
      createdBy: data['createdBy'],
      shopName: data['shopName'] ?? '',
      ownerName: data['ownerName'] ?? '',
      cell: data['cell'] ?? '',
      shopPhotoAsset: data['shopPhotoAsset'],
      orderNo: data['orderNo'],
      isDelivered: data['isDelivered'] ?? false,
      orderDate: data['orderDate'] != null
          ? DateTime.parse(data['orderDate'] as String)
          : null,
      remainingAmount: data['remainingAmount'] ?? 0,
      isCollected: data['isCollected'] ?? false,
      totalBill: data['totalBill'] ?? 0,
      collectedAmount: data['collectedAmount'] ?? 0,
      items: (data['items'] as List<dynamic>?)
              ?.map((item) =>
                  OrderItem.fromFirestore(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

