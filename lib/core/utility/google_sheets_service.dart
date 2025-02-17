// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class GoogleSheetsService {
//   static const String sheetUrl =
//       "https://docs.google.com/spreadsheets/d/1xP51BQYCbyP1xk0fyfmItsTfACemkw5glE_7Hp1JGfw/gviz/tq?tqx=out:json";

//   Future<List<Map<String, dynamic>>> fetchSheetData() async {
//     final response = await http.get(Uri.parse(sheetUrl));

//     if (response.statusCode == 200) {
//       // Clean JSON Response (Remove "google.visualization.Query.setResponse(")
//       String rawJson = response.body
//           .replaceAll("/*O_o*/", "")
//           .replaceAll("google.visualization.Query.setResponse(", "")
//           .replaceAll(");", "");

//       Map<String, dynamic> jsonData = json.decode(rawJson);

//       List<dynamic> rows = jsonData['table']['rows'];
//       List<String> headers = jsonData['table']['cols']
//           .map<String>((col) => col['label']?.toString() ?? "")
//           .toList();

//       List<Map<String, dynamic>> extractedData = [];

//       for (var row in rows) {
//         Map<String, dynamic> rowData = {};
//         for (var i = 0; i < headers.length; i++) {
//           rowData[headers[i]] = row['c'][i] != null ? row['c'][i]['v'] : null;
//         }
//         extractedData.add(rowData);
//       }
//       print("LATEST SHEET DATA : ${extractedData.length}");
//       return extractedData;
//     } else {
//       throw Exception("Failed to load Google Sheets data");
//     }
//   }
// }

//=======

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class GoogleSheetsService {
//   static const String spreadsheetId =
//       "1xP51BQYCbyP1xk0fyfmItsTfACemkw5glE_7Hp1JGfw";

//   // List of sheet IDs (GID values) - you need to find these manually
//   static const List<int> sheetGids = [
//     1509225340,
//     1208953900,
//     1494935664,
//     1194006308
//   ]; // Add your actual sheet GIDs

//   Future<Map<String, List<Map<String, dynamic>>>> fetchAllSheetsData() async {
//     Map<String, List<Map<String, dynamic>>> allSheetsData = {};

//     for (int gid in sheetGids) {
//       String sheetUrl =
//           "https://docs.google.com/spreadsheets/d/$spreadsheetId/gviz/tq?tqx=out:json&gid=$gid";

//       final response = await http.get(Uri.parse(sheetUrl));

//       if (response.statusCode == 200) {
//         // Clean JSON Response (Remove "google.visualization.Query.setResponse(")
//         String rawJson = response.body
//             .replaceAll("/*O_o*/", "")
//             .replaceAll("google.visualization.Query.setResponse(", "")
//             .replaceAll(");", "");

//         Map<String, dynamic> jsonData = json.decode(rawJson);

//         List<dynamic> rows = jsonData['table']['rows'];
//         List<String> headers = jsonData['table']['cols']
//             .map<String>((col) => col['label']?.toString() ?? "")
//             .toList();

//         List<Map<String, dynamic>> extractedData = [];

//         for (var row in rows) {
//           Map<String, dynamic> rowData = {};
//           for (var i = 0; i < headers.length; i++) {
//             rowData[headers[i]] = row['c'][i] != null ? row['c'][i]['v'] : null;
//           }
//           extractedData.add(rowData);
//         }

//         allSheetsData["Sheet_$gid"] = extractedData;
//         print("Fetched ${extractedData.length} rows from Sheet GID: $gid");
//       } else {
//         print("Failed to load sheet with GID: $gid");
//       }
//     }

//     return allSheetsData;
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleSheetsService {
  // static const String baseUrl =
  //     "https://docs.google.com/spreadsheets/d/1xP51BQYCbyP1xk0fyfmItsTfACemkw5glE_7Hp1JGfw/gviz/tq?tqx=out:json&gid=";

  static const String baseUrl =
      "https://docs.google.com/spreadsheets/d/1cumaJOcninW7xjGGmbmlwSAmSwiOtQRq5eHC5OZ-66M/gviz/tq?tqx=out:json&gid=";

  Future<List<Map<String, dynamic>>> fetchSheetDataByGid(String gid) async {
    final response = await http.get(Uri.parse("$baseUrl$gid"));

    if (response.statusCode == 200) {
      String rawJson = response.body
          .replaceAll("/*O_o*/", "")
          .replaceAll("google.visualization.Query.setResponse(", "")
          .replaceAll(");", "");

      Map<String, dynamic> jsonData = json.decode(rawJson);

      List<dynamic> rows = jsonData['table']['rows'];
      List<String> headers = jsonData['table']['cols']
          .map<String>((col) => col['label']?.toString() ?? "")
          .toList();

      List<Map<String, dynamic>> extractedData = [];

      for (var row in rows) {
        Map<String, dynamic> rowData = {};
        for (var i = 0; i < headers.length; i++) {
          rowData[headers[i]] = row['c'][i] != null ? row['c'][i]['v'] : null;
        }
        extractedData.add(rowData);
      }
      print("Fetched ${extractedData.length} rows from gid $gid");
      return extractedData;
    } else {
      throw Exception("Failed to load Google Sheets data for gid $gid");
    }
  }
}
