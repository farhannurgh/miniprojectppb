import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user_model.dart';

class AuthService {
  AuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Stream<User?> authStateChanges() => _auth.authStateChanges();

  static AppUserModel? get currentUser {
    final User? user = _auth.currentUser;
    if (user == null) {
      return null;
    }

    return AppUserModel.fromFirebase(uid: user.uid, email: user.email);
  }

  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  static Future<void> register({
    required String email,
    required String password,
  }) async {
    await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }
}
