import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email and password
  Future<User?> signUpWithEmailPassword(
      String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Send email verification
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      // Update user profile with username
      await user?.updateDisplayName(username);

      return user;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return user;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return;
    }
  }

  // Check email verification
  Future<bool> isEmailVerified() async {
    User? user = _auth.currentUser;
    await user?.reload();
    if (user != null && user.emailVerified) {
      return true;
    }
    return false;
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Reset password
  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to send password reset email: $e');
      }
      rethrow;
    }
  }
}
