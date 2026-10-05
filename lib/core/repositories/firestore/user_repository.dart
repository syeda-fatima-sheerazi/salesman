import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sales_man/core/models/user_model.dart';
import 'package:sales_man/core/repositories/i_user_repository.dart';
import 'package:sales_man/core/services/auth_service.dart';

class UserRepository implements IUserRepository {
  final FirebaseFirestore _firestore;
  final AuthService _authService;

  UserRepository({
    FirebaseFirestore? firestore,
    required AuthService authService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _authService = authService;

  String get _uid {
    final user = _authService.currentUser;
    if (user == null) throw StateError('No authenticated user');
    return user.id;
  }

  @override
  Future<void> createProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set({
      ...user.toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<UserModel?> getProfile() async {
    final doc = await _firestore.collection('users').doc(_uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc.id, doc.data()!);
  }

  @override
  Future<void> updateProfile(UserModel user) async {
    await _firestore.collection('users').doc(_uid).update(user.toFirestore());
  }

  @override
  Future<void> updateLastLogin() async {
    await _firestore.collection('users').doc(_uid).update({
      'lastLogin': FieldValue.serverTimestamp(),
    });
  }
}
