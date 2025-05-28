import 'package:flutter/material.dart';
import 'package:racecourse_tracks/data/repositories/racecourse_repository.dart';

class FreeDashboardViewModel extends ChangeNotifier {
  FreeDashboardViewModel(this._racecourseRepository) {
    _selectedRacecourse = racecourses
        .firstWhere((racecourse) => racecourse['Racecourse Type'] == 'Gallops');
  }
  final RacecourseRepository _racecourseRepository;
  bool get isLoading => _racecourseRepository.isLoading; // Assuming isLoading
  List<Map<String, dynamic>> get racecourses =>
      _racecourseRepository.allItems.toList();
  late Map<String, dynamic> _selectedRacecourse;
  String _selectedRacecourseType = 'Gallops';
  Map<String, dynamic> get selectedRacecourse => _selectedRacecourse;
  void setSelectedRacecourse(String racecourse) {
    _selectedRacecourse =
        racecourses.firstWhere((rc) => rc['Racecourse'] == racecourse);
    notifyListeners();
  }

  String get selectedRacecourseType => _selectedRacecourseType;
  set selectedRacecourseType(String value) {
    if (_selectedRacecourseType != value) {
      _selectedRacecourseType = value;
      _selectedRacecourse = racecourses
          .firstWhere((racecourse) => racecourse['Racecourse Type'] == value);
      notifyListeners();
    }
  }

  List<String> get filteredRacecourses {
    return racecourses
        .where((racecourse) => racecourse['Racecourse Type'] == _selectedRacecourseType)
        .map((racecourse) => racecourse['Racecourse'] as String)
        .toList();
  }
}
