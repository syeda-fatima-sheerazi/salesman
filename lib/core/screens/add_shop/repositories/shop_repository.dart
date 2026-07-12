import 'package:practices/core/models/shop.dart';
import 'package:practices/core/services/database_service.dart';

class ShopRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  String _generateId() {
    final now = DateTime.now();
    return '${now.millisecondsSinceEpoch}_${now.microsecondsSinceEpoch}';
  }

  Future<void> insertShop(Shop shop) async {
    final db = await _dbService.database;
    final id = shop.id ?? _generateId();

    await db.insert('shops', {
      'id': id,
      'shopName': shop.shopName,
      'shopOwner': shop.shopOwner,
      'cellPhone': shop.cellPhone,
      'cnic': shop.cnic,
      'address': shop.address,
      'area': shop.area,
      'town': shop.town,
      'district': shop.district,
      'latitude': shop.latitude,
      'longitude': shop.longitude,
      'photoPath': shop.photoPath,
      'shopImagUrl': shop.shopImagUrl,
      'isVisited': shop.isVisited ? 1 : 0,
      'description': shop.description,
      'createdAt': shop.createdAt?.toIso8601String() ??
          DateTime.now().toIso8601String(),
    });
  }

  Future<List<Shop>> getAllShops() async {
    final db = await _dbService.database;
    final maps = await db.query('shops', orderBy: 'createdAt DESC');
    return maps.map((m) => _shopFromMap(m)).toList();
  }

  Future<Shop?> getShopById(String id) async {
    final db = await _dbService.database;
    final maps = await db.query(
      'shops',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return _shopFromMap(maps.first);
  }

  Future<void> updateShop(Shop shop) async {
    final db = await _dbService.database;
    await db.update(
      'shops',
      {
        'shopName': shop.shopName,
        'shopOwner': shop.shopOwner,
        'cellPhone': shop.cellPhone,
        'cnic': shop.cnic,
        'address': shop.address,
        'area': shop.area,
        'town': shop.town,
        'district': shop.district,
        'latitude': shop.latitude,
        'longitude': shop.longitude,
        'photoPath': shop.photoPath,
        'shopImagUrl': shop.shopImagUrl,
        'isVisited': shop.isVisited ? 1 : 0,
        'description': shop.description,
      },
      where: 'id = ?',
      whereArgs: [shop.id],
    );
  }

  Future<void> deleteShop(String id) async {
    final db = await _dbService.database;
    await db.delete('shops', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Shop>> searchShopsByName(String query) async {
    final db = await _dbService.database;
    final maps = await db.query(
      'shops',
      where: 'shopName LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'shopName ASC',
    );
    return maps.map((m) => _shopFromMap(m)).toList();
  }

  Shop _shopFromMap(Map<String, dynamic> map) {
    return Shop(
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
      isVisited: map['isVisited'] == 1,
      description: map['description'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }
}
