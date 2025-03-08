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
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static List<Map<String, dynamic>> users = [];
  static List<Map<String, dynamic>> winddata = [];
  static List<Map<String, dynamic>> direction = [];
  static List<Map<String, dynamic>> lengthdata = [];
  final GoogleSheetsService _googleSheetsService = GoogleSheetsService();

  Future<List<Map<String, dynamic>>> getUsers() async {
    users = await _googleSheetsService.fetchSheetDataByGid("1509225340");
    print('Lengthdata: ${users.length} rows fetched');
    return users;
  }

  // ✅ Fetch Length Data (gid = 1194006308)
  Future<List<Map<String, dynamic>>> getLengthdata() async {
    lengthdata = await _googleSheetsService.fetchSheetDataByGid("1194006308");
    print('Lengthdata: ${lengthdata.length} rows fetched');
    return lengthdata;
  }

  // ✅ Fetch Wind Data (gid = 1494935664)
  Future<List<Map<String, dynamic>>> getWinddata() async {
    winddata =
        await _googleSheetsService.fetchSheetDataByGid("1208953900&headers=1");
    print('Winddata: ${winddata.length} rows fetched');
    return winddata;
  }

  // ✅ Fetch Direction Data (gid = 1208953900)
  Future<List<Map<String, dynamic>>> getDirectiondata() async {
    direction = await _googleSheetsService.fetchSheetDataByGid("1494935664");
    print('Directiondata: ${direction.length} rows fetched');
    return direction;
  }

  // Future<List<Map<String, dynamic>>> getUsers() async {
  //   // final snapshot = await _firestore.collection('users').get();
  //   // users = snapshot.docs.map((doc) => doc.data()).toList();
  //   // print('users-->>>>${users.length}');

  //   // users = await _googleSheetsService.fetchAllSheetsData();
  //   // print('users-->>>>${users.length}');

  //   // Map<String, List<Map<String, dynamic>>> sheetsData =
  //   //     await _googleSheetsService.fetchAllSheetsData();

  //   // // Print data from all sheets
  //   // sheetsData.forEach((sheetName, data) {
  //   //   print("Data from $sheetName: ${data.length} rows");
  //   // });

  //   return users;
  // }

  // Future<List<Map<String, dynamic>>> getWinddata() async {
  //   final snapshot = await _firestore.collection('winddata').get();
  //   winddata = snapshot.docs.map((doc) => doc.data()).toList();
  //   print('winddata-->>>>${winddata.length}');
  //   return winddata;
  // }

  // Future<List<Map<String, dynamic>>> getDirectiondata() async {
  //   final snapshot = await _firestore.collection('directiondata').get();
  //   direction = snapshot.docs.map((doc) => doc.data()).toList();
  //   print('direction-->>>>${direction.length}');
  //   return direction;
  // }

  // Future<List<Map<String, dynamic>>> getLengthdata() async {
  //   final snapshot = await _firestore.collection('lengthdata').get();
  //   lengthdata = snapshot.docs.map((doc) => doc.data()).toList();
  //   print('lengthdata-->>>>${lengthdata.length}');
  //   return lengthdata;
  // }

  // Stream<List<Map<String, dynamic>>> getUsers1() {
  //   return _firestore
  //       .collection('users')
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  // }
}
