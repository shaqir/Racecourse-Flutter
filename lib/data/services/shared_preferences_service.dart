import 'dart:convert';

import 'package:racecourse_tracks/data/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String racecourseDataKey = "racecourse_data";
  static const String selectedRacecourseKey = "selected_racecourse";

  // Save Set<Map<String, dynamic>> to SharedPreferences
  static Future<void> saveSetToPreferences(
      Set<Map<String, dynamic>> dataSet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the set to a list and then encode to JSON
    String jsonString = jsonEncode(dataSet.toList());

    await prefs.setString(racecourseDataKey, jsonString);
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

    return dataSet;
  }

  static Future<void> saveSelectedRaceCourseToPreferences(
      Map<String, dynamic> dataSet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the set to a list and then encode to JSON
    String jsonString = jsonEncode(dataSet);

    await prefs.setString(selectedRacecourseKey, jsonString);
  }

// Retrieve Set<Map<String, dynamic>> from SharedPreferences
  static Future<Map<String, dynamic>>
      getSelectedRacecourseFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString(selectedRacecourseKey);
    if (jsonString == null) {
      return {}; // Return an empty set if no data is found
    }

    // Decode JSON string to List and then convert to Set<Map<String, dynamic>>
    Map<String, dynamic> dataSet = jsonDecode(jsonString);

    return dataSet;
  }

  static Future<void> saveSelectedRaceCourse(
      int index, String racecourse, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_racecourse_$index', racecourse);
    await prefs.setString('selected_racecourse_type_$index', type);
  }

  static Future<Map<String, String>> getSelectedRacecourse(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String racecourse = prefs.getString('selected_racecourse_$index') ?? '';
    String type = prefs.getString('selected_racecourse_type_$index') ?? '';
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
    });
  }
}
