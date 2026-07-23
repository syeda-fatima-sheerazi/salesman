import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:sales_man/core/models/user_model.dart';

class AuthUserMapper {
  UserModel? fromFirebaseUser(User? firebaseUser) {
    if (firebaseUser == null) return null;
    return UserModel(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      avatarUrl: firebaseUser.photoURL ?? 'assets/icons/user.png',
    );
  }
}
