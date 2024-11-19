import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static late final List<Map<String, dynamic>> users;
  static late final List<Map<String, dynamic>> winddata;
  static late final List<Map<String, dynamic>> direction;

  FirestoreService() {
    // Initialize the streams to fill the lists
    _initializeUsers();
    _initializeWinddata();
    _initializeDirectiondata();
  }

  void _initializeUsers() {
    getUsers().listen((userList) {
      users = userList;
    });
  }

  void _initializeWinddata() {
    getWinddata().listen((windList) {
      winddata = windList;
    });
  }

  void _initializeDirectiondata() {
    getDirectiondata().listen((directionList) {
      direction = directionList;
    });
  }

  Stream<List<Map<String, dynamic>>> getUsers() {
    return _db
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<Map<String, dynamic>>> getWinddata() {
    return _db
        .collection('winddata')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<Map<String, dynamic>>> getDirectiondata() {
    return _db
        .collection('directiondata')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
