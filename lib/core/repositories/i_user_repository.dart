import 'package:sales_man/core/models/user_model.dart';

abstract class IUserRepository {
  Future<void> createProfile(UserModel user);
  Future<UserModel?> getProfile();
  Future<void> updateProfile(UserModel user);
  Future<void> updateLastLogin();
}
