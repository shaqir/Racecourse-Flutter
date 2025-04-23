import 'dart:io';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

Future<void> fetchAndReadExcel() async {
  const String excelUrl =
      "https://docs.google.com/spreadsheets/d/1xP51BQYCbyP1xk0fyfmItsTfACemkw5glE_7Hp1JGfw/export?format=xlsx";

  try {
    // Step 1: Download the file
    final file = await downloadExcelFile(excelUrl);

    // Step 2: Read the Excel file
    readExcelFile(file);
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
  }
}

Future<File> downloadExcelFile(String url) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/sheet.xlsx";

    Dio dio = Dio();
    await dio.download(url, filePath);

    if (kDebugMode) {
      print("File downloaded to $filePath");
    }
    return File(filePath);
  } catch (e) {
    throw Exception("Failed to download file: $e");
  }
}

void readExcelFile(File file) {
  // Read the file as bytes
  var bytes = file.readAsBytesSync();

  // Decode the Excel file
  var excel = Excel.decodeBytes(bytes);

  // Iterate through each sheet in the Excel file
  for (var sheetName in excel.tables.keys) {
    if (kDebugMode) {
      print("Reading sheet: $sheetName");
    }
    var sheet = excel.tables[sheetName];
    if (sheet != null) {
      for (var row in sheet.rows) {
        // Filter out null values
        var rowData = row
            .where((cell) => cell?.value != null)
            .map((cell) => cell!.value)
            .toList();

        if (rowData.isNotEmpty) {
          if (kDebugMode) {
            print("Filtered Row Data: $rowData");
          }
        }
      }
    }
  }
}
