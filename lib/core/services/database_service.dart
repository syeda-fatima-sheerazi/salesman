import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:practices/core/models/user_model.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sales_man.db');
    return openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createUsersTable(db);
    await _createOrdersTables(db);
    await _createShopsTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createOrdersTables(db);
    }
    if (oldVersion < 3) {
      await _createShopsTable(db);
    }
  }

  Future<void> _createUsersTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        avatarUrl TEXT NOT NULL DEFAULT 'assets/icons/user.png'
      )
    ''');
  }

  Future<void> _createOrdersTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS orders (
        id TEXT PRIMARY KEY,
        shopId TEXT NOT NULL,
        shopName TEXT NOT NULL,
        ownerName TEXT NOT NULL,
        cell TEXT NOT NULL,
        shopPhotoAsset TEXT,
        orderNo TEXT,
        totalBill INTEGER NOT NULL DEFAULT 0,
        collectedAmount INTEGER NOT NULL DEFAULT 0,
        remainingAmount INTEGER NOT NULL DEFAULT 0,
        isDelivered INTEGER NOT NULL DEFAULT 0,
        isCollected INTEGER NOT NULL DEFAULT 0,
        orderDate TEXT,
        deliveryDate TEXT,
        paymentDate TEXT,
        notes TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        orderId TEXT NOT NULL,
        productId TEXT NOT NULL,
        productName TEXT NOT NULL,
        qty INTEGER NOT NULL DEFAULT 1,
        price REAL NOT NULL DEFAULT 0,
        variant TEXT,
        imageUrl TEXT,
        FOREIGN KEY (orderId) REFERENCES orders(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS order_attachments (
        id TEXT PRIMARY KEY,
        orderId TEXT NOT NULL,
        filePath TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (orderId) REFERENCES orders(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _createShopsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS shops (
        id TEXT PRIMARY KEY,
        shopName TEXT NOT NULL,
        shopOwner TEXT NOT NULL,
        cellPhone TEXT NOT NULL,
        cnic TEXT,
        address TEXT NOT NULL,
        area TEXT,
        town TEXT,
        district TEXT,
        latitude REAL,
        longitude REAL,
        photoPath TEXT,
        shopImagUrl TEXT DEFAULT 'assets/images/shop.png',
        isVisited INTEGER NOT NULL DEFAULT 0,
        description TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<bool> registerUser(UserModel user) async {
    final db = await database;
    try {
      await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel?> loginUser(String email, String password) async {
    final db = await database;
    final hashed = _hashPassword(password);
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email.trim(), hashed],
    );
    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first);
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim()],
    );
    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first);
  }

  String hashPassword(String password) => _hashPassword(password);
}
