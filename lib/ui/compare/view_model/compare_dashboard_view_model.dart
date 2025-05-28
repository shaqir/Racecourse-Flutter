import 'package:flutter/material.dart';
import 'package:racecourse_tracks/data/repositories/racecourse_repository.dart';

class CompareDashboardViewModel extends ChangeNotifier {
  final RacecourseRepository _racecourseRepository;
  CompareDashboardViewModel(this._racecourseRepository);
  final Map<int, String> _selectedRacecourseMap = {};
  Map<int, String> get selectedRacecourseMap => _selectedRacecourseMap;
  final Map<int, String> _selectedRacecourseTypeMap = {};
  Map<int, String> get selectedRacecourseTypeMap => _selectedRacecourseTypeMap;

  void setSelectedRacecourse(int index, String selectedRacecourse) {
    _selectedRacecourseMap[index] = selectedRacecourse;
    notifyListeners();
  }

  void setSelectedRacecourseType(int index, String selectedRacecourseType) {
    _selectedRacecourseTypeMap[index] = selectedRacecourseType;
    notifyListeners();
  }

  List<Map<String, dynamic>> get allItems =>
      _racecourseRepository.allItems.toList();
}
