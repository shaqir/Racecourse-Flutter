import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:racecourse_tracks/core/utility/google_sheets_service.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();

  // Factory constructor to return the same instance
  factory FirestoreService() {
    return _instance;
  }

  // Private constructor to prevent external instantiation
  FirestoreService._internal();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static List<Map<String, dynamic>> users = [];
  static List<Map<String, dynamic>> winddata = [];
  static List<Map<String, dynamic>> direction = [];
  static List<Map<String, dynamic>> lengthdata = [];
  final GoogleSheetsService _googleSheetsService = GoogleSheetsService();

  Future<List<Map<String, dynamic>>> getUsers() async {
    // final snapshot = await _firestore.collection('users').get();
    // users = snapshot.docs.map((doc) => doc.data()).toList();
    // print('users-->>>>${users.length}');

    users = await _googleSheetsService.fetchSheetData();
    print('users-->>>>${users.length}');
    return users;
  }

  Future<List<Map<String, dynamic>>> getWinddata() async {
    final snapshot = await _firestore.collection('winddata').get();
    winddata = snapshot.docs.map((doc) => doc.data()).toList();
    print('winddata-->>>>${winddata.length}');
    return winddata;
  }

  Future<List<Map<String, dynamic>>> getDirectiondata() async {
    final snapshot = await _firestore.collection('directiondata').get();
    direction = snapshot.docs.map((doc) => doc.data()).toList();
    print('direction-->>>>${direction.length}');
    return direction;
  }

  Future<List<Map<String, dynamic>>> getLengthdata() async {
    final snapshot = await _firestore.collection('lengthdata').get();
    lengthdata = snapshot.docs.map((doc) => doc.data()).toList();
    print('lengthdata-->>>>${lengthdata.length}');
    return lengthdata;
  }

  Stream<List<Map<String, dynamic>>> getUsers1() {
    return _firestore
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
