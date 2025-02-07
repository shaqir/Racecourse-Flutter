import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleSheetsService {
  static const String sheetUrl =
      "https://docs.google.com/spreadsheets/d/1xP51BQYCbyP1xk0fyfmItsTfACemkw5glE_7Hp1JGfw/gviz/tq?tqx=out:json";

  Future<List<Map<String, dynamic>>> fetchSheetData() async {
    final response = await http.get(Uri.parse(sheetUrl));

    if (response.statusCode == 200) {
      // Clean JSON Response (Remove "google.visualization.Query.setResponse(")
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
      print("LATEST SHEET DATA : ${extractedData.length}");
      return extractedData;
    } else {
      throw Exception("Failed to load Google Sheets data");
    }
  }
}
