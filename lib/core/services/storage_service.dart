import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage;

  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  Future<String> uploadShopImage({
    required String uid,
    required String shopId,
    required File file,
  }) async {
    final ref = _storage.ref().child('users/$uid/shops/$shopId.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<String> uploadProductImage({
    required String uid,
    required String productId,
    required File file,
  }) async {
    final ref = _storage.ref().child('users/$uid/products/$productId.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> deleteImage(String path) async {
    await _storage.ref().child(path).delete();
  }
}
