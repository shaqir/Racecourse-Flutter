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
        return User.fromMap(data, snapshot.id);
      }
    }
    return null;
  }

  Stream<List<User>> getAllUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return User.fromMap(data, doc.id);
      }).toList();
    });
  }

  Future<List<Map<String, dynamic>>> getWidthData() async {
    final snapshot = await _firestore
        .collection('widthdata')
        .get();
    final widthdata = snapshot.docs
        .map((doc) => {
              ...doc.data(),
              'id': doc.id, // Add document ID to the map
            })
        .toList();
    if (kDebugMode) {
      print('Widthdata: ${widthdata.length} rows fetched');
    }
    return widthdata;
  }

  Future<List<Map<String, dynamic>>> getAllCourseTypes() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('course_types')
          .orderBy('name')
          .get();
      return snapshot.docs
          .map(
            (doc) => {
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id, // Include the document ID in the map
            },
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch course types: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllFirstTurnData() async {
    final QuerySnapshot snapshot = await _firestore
        .collection('first_turns')
        .orderBy('Min')
        .get();
    return snapshot.docs
        .map((doc) => {
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id, // Include the document ID in the map
            })
        .toList();
  }
}
