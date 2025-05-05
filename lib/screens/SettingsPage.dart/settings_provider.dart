import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/utility/sharedpreferenceshelper.dart';

enum DistanceUnit { metres, yards }

class SettingsProvider extends ChangeNotifier {
  DistanceUnit _selectedDistanceUnit = DistanceUnit.metres;

  DistanceUnit get selectedDistanceUnit => _selectedDistanceUnit;

  Future<void> init() async {
    // Initialize the provider with default values or load from shared preferences
    _selectedDistanceUnit = DistanceUnit.metres; // Default value
    final savedUnit = await SharedPreferencesHelper.getDistanceUnit();
    _selectedDistanceUnit = savedUnit;
    notifyListeners();
  }

  void setSelectedDistanceUnit(DistanceUnit unit) {
    _selectedDistanceUnit = unit;
    notifyListeners();
    SharedPreferencesHelper.saveDistanceUnit(unit);
  }

  String get distanceUnitValue {
    switch (_selectedDistanceUnit) {
      case DistanceUnit.metres:
        return 'm';
      case DistanceUnit.yards:
        return 'yd';
    }
  }

  String formatDistance(double distance) {
    switch (_selectedDistanceUnit) {
      case DistanceUnit.metres:
        return '${distance.toStringAsFixed(0)} m';
      case DistanceUnit.yards:
        return '${(distance * 1.09361).toStringAsFixed(0)} yd';
    }
  }
}