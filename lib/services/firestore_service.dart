import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add user data to Firestore
  Future<void> addUser(Map<String, dynamic> userData, String userId) async {
    try {
      await _db.collection('users').doc(userId).set(userData);
    } catch (e) {
      if (kDebugMode) {
        print('Error adding user: $e');
      }
      rethrow;
    }
  }

  // Get user data from Firestore
  Future<DocumentSnapshot> getUser(String userId) async {
    try {
      return await _db.collection('users').doc(userId).get();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user: $e');
      }
      rethrow;
    }
  }

  // Update user data in Firestore
  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      await _db.collection('users').doc(userId).update(userData);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user: $e');
      }
      rethrow;
    }
  }

  // Delete user data from Firestore
  Future<void> deleteUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user: $e');
      }
      rethrow;
    }
  }
}
