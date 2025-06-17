import 'package:flutter/material.dart';
import 'package:racecourse_tracks/data/length/length_repository.dart';
import 'package:racecourse_tracks/data/repositories/direction/direction_repository.dart';
import 'package:racecourse_tracks/data/repositories/racecourse_repository.dart';
import 'package:racecourse_tracks/data/repositories/wind_data/wind_data_repository.dart';

class CompareDashboardViewModel extends ChangeNotifier {
  final RacecourseRepository _racecourseRepository;
  final WindDataRepository _windDataRepository;
  final DirectionRepository _directionRepository;
  final LengthRepository _lengthRepository;
  CompareDashboardViewModel(this._racecourseRepository, this._windDataRepository, this._directionRepository, this._lengthRepository);

  void init() {
    _fetchData();
  }

  final Map<int, String> _selectedRacecourseMap = {};
  Map<int, String> get selectedRacecourseMap => _selectedRacecourseMap;
  final Map<int, String> _selectedRacecourseTypeMap = {};
  Map<int, String> get selectedRacecourseTypeMap => _selectedRacecourseTypeMap;

  void setSelectedRacecourse(int index, String selectedRacecourse) {
    _selectedRacecourseMap[index] = selectedRacecourse;
    notifyListeners();
  }

  void setSelectedRacecourseType(int index, String selectedRacecourseType) {
    if(_selectedRacecourseTypeMap[index] != selectedRacecourseType) {
      _selectedRacecourseMap[index] = allItems.firstWhere(
        (item) => item['Racecourse Type'] == selectedRacecourseType,
      )['Racecourse'] as String;
    }
    _selectedRacecourseTypeMap[index] = selectedRacecourseType;
    notifyListeners();
  }

  List<Map<String, dynamic>> get allItems =>
      _racecourseRepository.allItems.toList();

  List<Map<String, dynamic>> get windData => _windDataRepository.windData;

  List<Map<String, dynamic>> get direction => _directionRepository.direction;

  List<Map<String, dynamic>> get lengthData => _lengthRepository.lengthData;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> _fetchData() async {
    _isLoading = true;
    notifyListeners();
    if (_racecourseRepository.allItems.isEmpty) {
      await _racecourseRepository.loadData();
    }
    if (_windDataRepository.windData.isEmpty) {
    await _windDataRepository.fetchWindData();
    }
    if (_directionRepository.direction.isEmpty) {
      await _directionRepository.fetchDirection();
    }
    if (_lengthRepository.lengthData.isEmpty) {
      await _lengthRepository.fetchLengthData();
    }
    _isLoading = false;
    notifyListeners();
  }

}
