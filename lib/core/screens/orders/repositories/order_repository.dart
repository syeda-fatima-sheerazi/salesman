import 'package:practices/core/models/order.dart';
import 'package:practices/core/models/order_attachment.dart';
import 'package:practices/core/models/order_item.dart';
import 'package:practices/core/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class OrderRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  String _generateId() {
    final now = DateTime.now();
    return '${now.millisecondsSinceEpoch}_${now.microsecondsSinceEpoch}';
  }

  Future<void> insertOrder(Order order) async {
    final db = await _dbService.database;
    final id = order.id ?? _generateId();

    await db.transaction((txn) async {
      await txn.insert('orders', {
        'id': id,
        'shopId': order.shopId,
        'shopName': order.shopName,
        'ownerName': order.ownerName,
        'cell': order.cell,
        'shopPhotoAsset': order.shopPhotoAsset,
        'orderNo': order.orderNo,
        'totalBill': order.totalBill,
        'collectedAmount': order.collectedAmount,
        'remainingAmount': order.remainingAmount,
        'isDelivered': order.isDelivered ? 1 : 0,
        'isCollected': order.isCollected ? 1 : 0,
        'orderDate': order.orderDate?.toIso8601String(),
        'deliveryDate': order.deliveryDate?.toIso8601String(),
        'paymentDate': order.paymentDate?.toIso8601String(),
        'notes': order.notes,
        'createdAt': order.createdAt.toIso8601String(),
      });

      for (final item in order.items) {
        await txn.insert('order_items', {
          'orderId': id,
          'productId': item.productId,
          'productName': item.productName,
          'qty': item.qty,
          'price': item.price,
          'variant': item.variant,
          'imageUrl': item.imageUrl,
        });
      }
    });
  }

  Future<List<Order>> getOrdersByShopId(String shopId) async {
    final db = await _dbService.database;
    final orderMaps = await db.query(
      'orders',
      where: 'shopId = ?',
      whereArgs: [shopId],
      orderBy: 'createdAt DESC',
    );

    final orders = <Order>[];
    for (final orderMap in orderMaps) {
      final items = await _getOrderItems(db, orderMap['id'] as String);
      orders.add(_orderFromMap(orderMap, items));
    }
    return orders;
  }

  Future<List<Order>> getOrdersByDeliveryDate(DateTime date) async {
    final db = await _dbService.database;
    final dateStr = date.toIso8601String().split('T')[0];
    final orderMaps = await db.query(
      'orders',
      where: 'deliveryDate LIKE ?',
      whereArgs: ['$dateStr%'],
      orderBy: 'createdAt DESC',
    );

    final orders = <Order>[];
    for (final orderMap in orderMaps) {
      final items = await _getOrderItems(db, orderMap['id'] as String);
      orders.add(_orderFromMap(orderMap, items));
    }
    return orders;
  }

  Future<List<Order>> getOrdersByPaymentDate(DateTime date) async {
    final db = await _dbService.database;
    final dateStr = date.toIso8601String().split('T')[0];
    final orderMaps = await db.query(
      'orders',
      where: 'paymentDate LIKE ?',
      whereArgs: ['$dateStr%'],
      orderBy: 'createdAt DESC',
    );

    final orders = <Order>[];
    for (final orderMap in orderMaps) {
      final items = await _getOrderItems(db, orderMap['id'] as String);
      orders.add(_orderFromMap(orderMap, items));
    }
    return orders;
  }

  Future<Order?> getOrderById(String id) async {
    final db = await _dbService.database;
    final orderMaps = await db.query(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (orderMaps.isEmpty) return null;

    final items = await _getOrderItems(db, id);
    return _orderFromMap(orderMaps.first, items);
  }

  Future<void> updateOrder(Order order) async {
    final db = await _dbService.database;
    await db.transaction((txn) async {
      await txn.update(
        'orders',
        {
          'totalBill': order.totalBill,
          'collectedAmount': order.collectedAmount,
          'remainingAmount': order.remainingAmount,
          'isDelivered': order.isDelivered ? 1 : 0,
          'isCollected': order.isCollected ? 1 : 0,
          'deliveryDate': order.deliveryDate?.toIso8601String(),
          'paymentDate': order.paymentDate?.toIso8601String(),
          'notes': order.notes,
        },
        where: 'id = ?',
        whereArgs: [order.id],
      );

      await txn.delete(
        'order_items',
        where: 'orderId = ?',
        whereArgs: [order.id],
      );
      for (final item in order.items) {
        await txn.insert('order_items', {
          'orderId': order.id,
          'productId': item.productId,
          'productName': item.productName,
          'qty': item.qty,
          'price': item.price,
          'variant': item.variant,
          'imageUrl': item.imageUrl,
        });
      }
    });
  }

  Future<void> deleteOrder(String id) async {
    final db = await _dbService.database;
    await db.transaction((txn) async {
      await txn.delete('order_items', where: 'orderId = ?', whereArgs: [id]);
      await txn.delete(
        'order_attachments',
        where: 'orderId = ?',
        whereArgs: [id],
      );
      await txn.delete('orders', where: 'id = ?', whereArgs: [id]);
    });
  }

  Future<void> insertAttachment(OrderAttachment attachment) async {
    final db = await _dbService.database;
    final id = attachment.id ?? _generateId();
    await db.insert('order_attachments', {
      'id': id,
      'orderId': attachment.orderId,
      'filePath': attachment.filePath,
      'createdAt': attachment.createdAt.toIso8601String(),
    });
  }

  Future<List<OrderAttachment>> getAttachmentsByOrderId(String orderId) async {
    final db = await _dbService.database;
    final maps = await db.query(
      'order_attachments',
      where: 'orderId = ?',
      whereArgs: [orderId],
      orderBy: 'createdAt ASC',
    );
    return maps.map((m) => OrderAttachment.fromMap(m)).toList();
  }

  Future<void> deleteAttachment(String id) async {
    final db = await _dbService.database;
    await db.delete('order_attachments', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<OrderItem>> _getOrderItems(Database db, String orderId) async {
    final itemMaps = await db.query(
      'order_items',
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
    return itemMaps.map((m) => OrderItem.fromMap(m)).toList();
  }

  Order _orderFromMap(Map<String, dynamic> map, List<OrderItem> items) {
    return Order(
      id: map['id'],
      shopId: map['shopId'],
      shopName: map['shopName'],
      ownerName: map['ownerName'],
      cell: map['cell'],
      shopPhotoAsset: map['shopPhotoAsset'],
      orderNo: map['orderNo'],
      totalBill: map['totalBill'] ?? 0,
      collectedAmount: map['collectedAmount'] ?? 0,
      remainingAmount: map['remainingAmount'] ?? 0,
      isDelivered: map['isDelivered'] == 1,
      isCollected: map['isCollected'] == 1,
      orderDate: map['orderDate'] != null
          ? DateTime.parse(map['orderDate'])
          : DateTime.now(),
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
      items: items,
    );
  }
}
