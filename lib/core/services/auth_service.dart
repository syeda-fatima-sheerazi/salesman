import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sales_man/core/models/user_model.dart';
import 'package:sales_man/core/repositories/i_user_repository.dart';
import 'package:sales_man/core/services/auth_exception.dart';
import 'package:sales_man/core/services/auth_user_mapper.dart';

class AuthService extends GetxService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final AuthUserMapper _mapper;
  bool _googleSignInInitialized = false;

  AuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    AuthUserMapper? mapper,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
        _mapper = mapper ?? AuthUserMapper();

  static AuthService get instance => Get.find();

  UserModel? get currentUser =>
      _mapper.fromFirebaseUser(_firebaseAuth.currentUser);

  Stream<UserModel?> get authStateChanges =>
      _firebaseAuth.authStateChanges().map(_mapper.fromFirebaseUser);

  Future<UserModel> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
      final user = _mapper.fromFirebaseUser(_firebaseAuth.currentUser);
      if (user == null) {
        throw AuthException(code: 'unknown', message: 'User not found after sign up');
      }
      unawaited(Get.find<IUserRepository>().createProfile(user));
      return user;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _mapper.fromFirebaseUser(credential.user);
      if (user == null) {
        throw AuthException(code: 'not_found', message: 'User not found after sign in');
      }
      unawaited(Get.find<IUserRepository>().updateLastLogin());
      return user;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      if (!_googleSignInInitialized) {
        await _googleSignIn.initialize();
        _googleSignInInitialized = true;
      }
      final GoogleSignInAccount googleAccount =
          await _googleSignIn.authenticate(
        scopeHint: const <String>['email', 'profile'],
      );
      final GoogleSignInAuthentication googleAuth = googleAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final authResult = await _firebaseAuth.signInWithCredential(credential);
      final user = _mapper.fromFirebaseUser(authResult.user);
      if (user != null) {
        unawaited(Get.find<IUserRepository>().updateLastLogin());
      }
      return user;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted) {
        return null;
      }
      throw _mapFirebaseError(e);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  Future<UserModel> reloadCurrentUser() async {
    try {
      await _firebaseAuth.currentUser?.reload();
      final user = _mapper.fromFirebaseUser(_firebaseAuth.currentUser);
      if (user == null) {
        throw AuthException(code: 'not_found', message: 'User not found after reload');
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  AuthException _mapFirebaseError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return AuthException(
            code: error.code,
            message: 'An account with this email already exists.',
          );
        case 'invalid-email':
          return AuthException(
            code: error.code,
            message: 'Please enter a valid email address.',
          );
        case 'weak-password':
          return AuthException(
            code: error.code,
            message: 'Password is too weak. Use at least 6 characters.',
          );
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          return AuthException(
            code: 'invalid_credentials',
            message: 'Invalid email or password.',
          );
        case 'too-many-requests':
          return AuthException(
            code: error.code,
            message: 'Too many attempts. Please try again later.',
          );
        case 'network-request-failed':
          return AuthException(
            code: error.code,
            message: 'Network error. Check your connection.',
          );
        case 'canceled':
          return AuthException(
            code: error.code,
            message: 'Sign in was canceled.',
          );
        default:
          return AuthException(
            code: error.code,
            message: error.message ?? 'An unexpected error occurred.',
          );
      }
    }
    if (error is GoogleSignInException) {
      return AuthException(
        code: error.code.name,
        message: error.description ?? 'Google sign-in failed.',
      );
    }
    return AuthException(
      code: 'unknown',
      message: 'An unexpected error occurred. Please try again.',
    );
  }
}
