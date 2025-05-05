import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:racecourse_tracks/screens/SettingsPage.dart/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String racecourseDataKey = "racecourse_data";
  static const String selectedRacecourseKey = "selected_racecourse";

  // Save Set<Map<String, dynamic>> to SharedPreferences
  static Future<void> saveSetToPreferences(
      Set<Map<String, dynamic>> dataSet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the set to a list and then encode to JSON
    String jsonString = jsonEncode(dataSet.toList());

    await prefs.setString(racecourseDataKey, jsonString);
    if (kDebugMode) {
      print("Data saved: ");
    }
  }

  // Retrieve Set<Map<String, dynamic>> from SharedPreferences
  static Future<Set<Map<String, dynamic>>> getSetFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString(racecourseDataKey);
    if (jsonString == null) {
      return {}; // Return an empty set if no data is found
    }

    // Decode JSON string to List and then convert to Set<Map<String, dynamic>>
    List<dynamic> jsonList = jsonDecode(jsonString);

    Set<Map<String, dynamic>> dataSet =
        jsonList.map((item) => Map<String, dynamic>.from(item)).toSet();

    if (kDebugMode) {
      print("Data retrieved: $dataSet");
    }
    return dataSet;
  }

  static Future<void> saveSelectedRaceCourseToPreferences(
      Map<String, dynamic> dataSet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the set to a list and then encode to JSON
    String jsonString = jsonEncode(dataSet);

    await prefs.setString(selectedRacecourseKey, jsonString);
    if (kDebugMode) {
      print("Data saved: ");
    }
  }

// Retrieve Set<Map<String, dynamic>> from SharedPreferences
  static Future<Map<String, dynamic>>
      getSelectedRacecourseFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString(selectedRacecourseKey);
    if (jsonString == null) {
      if (kDebugMode) {
        print('jsonString is null........');
      }
      return {}; // Return an empty set if no data is found
    }

    // Decode JSON string to List and then convert to Set<Map<String, dynamic>>
    Map<String, dynamic> dataSet = jsonDecode(jsonString);

    if (kDebugMode) {
      print("Selected Racecourse retrieved: $dataSet");
    }
    return dataSet;
  }

  static Future<void> saveSelectedRaceCourse(
      int index, String racecourse, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_racecourse_$index', racecourse);
    await prefs.setString('selected_racecourse_type_$index', type);
    if (kDebugMode) {
      print("Data saved for index $index: $racecourse, $type");
    }
  }

  static Future<Map<String, String>> getSelectedRacecourse(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String racecourse = prefs.getString('selected_racecourse_$index') ?? '';
    String type = prefs.getString('selected_racecourse_type_$index') ?? '';
    if (kDebugMode) {
      print("Data retrieved for index $index: $racecourse, $type");
    }
    return {
      'racecourse': racecourse,
      'type': type,
    };
  }

  static Future<DistanceUnit> getDistanceUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? unit = prefs.getString('distance_unit');
    if (unit == null) {
      return DistanceUnit.metres; // Default value
    }
    if (unit == 'metres') {
      return DistanceUnit.metres;
    } else if (unit == 'yards') {
      return DistanceUnit.yards;
    } else {
      return DistanceUnit.metres; // Default value
    }
  }

  static void saveDistanceUnit(DistanceUnit unit) {
    SharedPreferences.getInstance().then((prefs) {
      String unitString = unit == DistanceUnit.metres ? 'metres' : 'yards';
      prefs.setString('distance_unit', unitString);
      if (kDebugMode) {
        print("Distance unit saved: $unitString");
      }
    });
  }
}
