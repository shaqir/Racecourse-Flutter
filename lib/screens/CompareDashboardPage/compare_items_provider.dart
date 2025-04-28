import 'package:flutter/material.dart';

class CompareItemsProvider extends ChangeNotifier {
  final Map<int, String> _selectedRacecourseMap = {};
  Map<int, String> get selectedRacecourseMap => _selectedRacecourseMap;
  final Map<int, String> _selectedRacecourseTypeMap = {};
  Map<int, String> get selectedRacecourseTypeMap => _selectedRacecourseTypeMap;

  void setSelectedRacecourse(int index, String selectedRacecourse,
      String selectedRacecourseType) {
    _selectedRacecourseMap[index] = selectedRacecourse;
    _selectedRacecourseTypeMap[index] = selectedRacecourseType;
    notifyListeners();
  }

}
