import 'package:practices/core/models/order.dart';

class Shop {
  final String? id;
  final String shopName;
  final String shopOwner;
  final String cellPhone;
  final String? cnic;
  final String shopImagUrl;
  final String? photoPath;
  final String address;
  final String? area;
  final String? town;
  final String? district;
  final double? latitude;
  final double? longitude;
  final bool isVisited;
  final String? description;
  final DateTime? createdAt;
  final List<Order> orders;

  Shop({
    this.id,
    required this.shopName,
    required this.shopOwner,
    required this.cellPhone,
    this.cnic,
    required this.address,
    this.area,
    this.town,
    this.district,
    this.latitude,
    this.longitude,
    this.photoPath,
    this.isVisited = false,
    this.orders = const [],

    this.shopImagUrl = 'assets/images/shop.png',
    this.description,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shopName': shopName,
      'shopOwner': shopOwner,
      'cellPhone': cellPhone,
      'cnic': cnic,
      'address': address,
      'area': area,
      'town': town,
      'district': district,
      'latitude': latitude,
      'longitude': longitude,
      'photoPath': photoPath,
      'shopImagUrl': shopImagUrl,
      'isVisited': isVisited,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'orders': orders.map((order) => order.toMap()).toList(),
    };
  }

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      orders: map["list"],
      id: map['id'],
      shopName: map['shopName'],
      shopOwner: map['shopOwner'],
      cellPhone: map['cellPhone'],
      cnic: map['cnic'],
      address: map['address'],
      area: map['area'],
      town: map['town'],
      district: map['district'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      photoPath: map['photoPath'],
      shopImagUrl: map['shopImagUrl'] ?? 'assets/images/shop.png',
      isVisited: map['isVisited'] ?? false,
      description: map['description'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }

  /// Create full address from area, town, district
  String get fullAddress {
    final parts = <String>[];
    if (area != null && area!.isNotEmpty) parts.add(area!);
    if (town != null && town!.isNotEmpty) parts.add(town!);
    if (district != null && district!.isNotEmpty) parts.add(district!);
    return parts.isNotEmpty ? parts.join(', ') : address;
  }

  Shop copyWith({
    String? id,
    String? shopName,
    String? shopOwner,
    String? cellPhone,
    String? cnic,
    String? address,
    String? area,
    String? town,
    String? district,
    double? latitude,
    double? longitude,
    String? photoPath,
    String? shopImagUrl,
    bool? isVisited,
    String? description,
    DateTime? createdAt,
    List<Order>? orders,
  }) {
    return Shop(
      id: id ?? this.id,
      shopName: shopName ?? this.shopName,
      shopOwner: shopOwner ?? this.shopOwner,
      cellPhone: cellPhone ?? this.cellPhone,
      cnic: cnic ?? this.cnic,
      address: address ?? this.address,
      area: area ?? this.area,
      town: town ?? this.town,
      district: district ?? this.district,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photoPath: photoPath ?? this.photoPath,
      shopImagUrl: shopImagUrl ?? this.shopImagUrl,
      isVisited: isVisited ?? this.isVisited,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      orders: orders ?? this.orders,
    );
  }
}
