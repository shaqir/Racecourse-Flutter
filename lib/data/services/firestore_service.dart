import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:racecourse_tracks/domain/models/user.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;
  FirestoreService(this._firestore);

  Future<List<Map<String, dynamic>>> getRacecourses() async {
    final snapshot = await _firestore
        .collection('racecourses')
        .orderBy('Racecourse')
        .get();
    final racecourses = snapshot.docs
        .map((doc) => {
              ...doc.data(),
              'id': doc.id, // Add document ID to the map
            })
        .toList();
    if (kDebugMode) {
      print('racecourses: ${racecourses.length} rows fetched');
    }
    return racecourses;
  }

  // ✅ Fetch Length Data
  Future<List<Map<String, dynamic>>> getLengthdata() async {
    final snapshot = await _firestore
        .collection('lengthdata')
        .get();

    final lengthdata = snapshot.docs
        .map((doc) => {
              ...doc.data(),
              'id': doc.id, // Add document ID to the map
            })
        .toList();
    if (kDebugMode) {
      print('Lengthdata: ${lengthdata.length} rows fetched');
    }
    return lengthdata;
  }

  // ✅ Fetch Wind Data (gid = 1494935664)
  Future<List<Map<String, dynamic>>> getWinddata() async {
    final snapshot = await _firestore
        .collection('winddata')
        .get();
    final winddata = snapshot.docs
        .map((doc) => {
              ...doc.data(),
              'id': doc.id, // Add document ID to the map
            })
        .toList();
    return winddata;
  }

  // ✅ Fetch Direction Data
  Future<List<Map<String, dynamic>>> getDirectiondata() async {
    final snapshot = await _firestore
        .collection('direction')
        .get();
    final direction = snapshot.docs
        .map((doc) => {
              ...doc.data(),
              'id': doc.id, // Add document ID to the map
            })
        .toList();
    if (kDebugMode) {
      print('Directiondata: ${direction.length} rows fetched');
    }
    return direction;
  }

  Future<User?> getUserById(String userId) async {
    final snapshot = await _firestore.doc('users/$userId').get();
    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null) {
        return User(
            id: snapshot.id,
            name: data['displayName'] ?? '',
            email: data['email'] ?? '',
            role: data['role']);
      }
    }
    return null;
  }
}
