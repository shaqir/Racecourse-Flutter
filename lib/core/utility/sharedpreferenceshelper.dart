import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String racecourse_data_key = "racecourse_data";
  static const String selected_racecourse_key = "selected_racecourse";

  // Save Set<Map<String, dynamic>> to SharedPreferences
  static Future<void> saveSetToPreferences(
      Set<Map<String, dynamic>> dataSet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the set to a list and then encode to JSON
    String jsonString = jsonEncode(dataSet.toList());

    await prefs.setString(racecourse_data_key, jsonString);
    print("Data saved: ");
  }

  // Retrieve Set<Map<String, dynamic>> from SharedPreferences
  static Future<Set<Map<String, dynamic>>> getSetFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString(racecourse_data_key);
    if (jsonString == null) {
      return {}; // Return an empty set if no data is found
    }

    // Decode JSON string to List and then convert to Set<Map<String, dynamic>>
    List<dynamic> jsonList = jsonDecode(jsonString);

    Set<Map<String, dynamic>> dataSet =
        jsonList.map((item) => Map<String, dynamic>.from(item)).toSet();

    print("Data retrieved: $dataSet");
    return dataSet;
  }

  static Future<void> saveSelectedRaceCourseToPreferences(
      Map<String, dynamic> dataSet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the set to a list and then encode to JSON
    String jsonString = jsonEncode(dataSet);

    await prefs.setString(selected_racecourse_key, jsonString);
    print("Data saved: ");
  }

// Retrieve Set<Map<String, dynamic>> from SharedPreferences
  static Future<Map<String, dynamic>>
      getSelectedRacecourseFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString(selected_racecourse_key);
    if (jsonString == null) {
      print('jsonString is null........');
      return {}; // Return an empty set if no data is found
    }

    // Decode JSON string to List and then convert to Set<Map<String, dynamic>>
    Map<String, dynamic> dataSet = jsonDecode(jsonString);

    print("Selected Racecourse retrieved: $dataSet");
    return dataSet;
  }

  static Future<void> saveSelectedRaceCourse(
      int index, String racecourse, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_racecourse_$index', racecourse);
    await prefs.setString('selected_racecourse_type_$index', type);
    print("Data saved for index $index: $racecourse, $type");
  }

  static Future<Map<String, String>> getSelectedRacecourse(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String racecourse = prefs.getString('selected_racecourse_$index') ?? '';
    String type = prefs.getString('selected_racecourse_type_$index') ?? '';
    print("Data retrieved for index $index: $racecourse, $type");
    return {
      'racecourse': racecourse,
      'type': type,
    };
  }
}
