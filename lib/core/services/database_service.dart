import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sales_man/core/models/user_model.dart';

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
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        avatarUrl TEXT NOT NULL DEFAULT 'assets/icons/user.png'
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

