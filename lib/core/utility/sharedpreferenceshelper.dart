import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String key = "user_data";

  // Save Set<Map<String, dynamic>> to SharedPreferences
  static Future<void> saveSetToPreferences(Set<Map<String, dynamic>> dataSet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the set to a list and then encode to JSON
    String jsonString = jsonEncode(dataSet.toList());

    await prefs.setString(key, jsonString);
    print("Data saved: $jsonString");
    
  }

  // Retrieve Set<Map<String, dynamic>> from SharedPreferences
  static Future<Set<Map<String, dynamic>>> getSetFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString(key);
    if (jsonString == null) {
      return {}; // Return an empty set if no data is found
    }

    // Decode JSON string to List and then convert to Set<Map<String, dynamic>>
    List<dynamic> jsonList = jsonDecode(jsonString);
    
    Set<Map<String, dynamic>> dataSet = jsonList.map((item) => Map<String, dynamic>.from(item)).toSet();

    print("Data retrieved: $dataSet");
    return dataSet;
  }
}
