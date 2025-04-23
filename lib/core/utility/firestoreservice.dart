import 'package:flutter/foundation.dart';
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

  Future<List<Map<String, dynamic>>> getUsers(
      {List<Map>? selectedItems}) async {
    String? query;
    if (selectedItems != null && selectedItems.isNotEmpty) {
      final nameFilter = selectedItems
          .map((item) =>
              "(B = '${item['Racecourse']}' and G = '${item['Racecourse Type']}')")
          .join(" or ");
      query = "select * where $nameFilter";
    }
    final result = await _googleSheetsService.fetchSheetDataByGid("1509225340",
        query: query);
    if (users.isEmpty) {
      users = result;
    } else {
      for(var i = 0; i < users.length; i++) {
        if(result.any((item) =>
            item['Racecourse'] == users[i]['Racecourse'] &&
            item['Racecourse Type'] == users[i]['Racecourse Type'])) {
          users[i] = result.firstWhere((item) =>
              item['Racecourse'] == users[i]['Racecourse'] &&
              item['Racecourse Type'] == users[i]['Racecourse Type']);
        }
      }
    }
    if (kDebugMode) {
      print('Lengthdata: ${result.length} rows fetched');
    }
    return result;
  }

  // ✅ Fetch Length Data (gid = 1194006308)
  Future<List<Map<String, dynamic>>> getLengthdata() async {
    lengthdata = await _googleSheetsService.fetchSheetDataByGid("1194006308");
    if (kDebugMode) {
      print('Lengthdata: ${lengthdata.length} rows fetched');
    }
    return lengthdata;
  }

  // ✅ Fetch Wind Data (gid = 1494935664)
  Future<List<Map<String, dynamic>>> getWinddata() async {
    winddata =
        await _googleSheetsService.fetchSheetDataByGid("1208953900&headers=1");
    if (kDebugMode) {
      print('Winddata: ${winddata.length} rows fetched');
    }
    return winddata;
  }

  // ✅ Fetch Direction Data (gid = 1208953900)
  Future<List<Map<String, dynamic>>> getDirectiondata() async {
    direction = await _googleSheetsService.fetchSheetDataByGid("1494935664");
    if (kDebugMode) {
      print('Directiondata: ${direction.length} rows fetched');
    }
    return direction;
  }
}
