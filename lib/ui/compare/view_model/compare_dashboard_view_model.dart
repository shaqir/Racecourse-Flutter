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
  CompareDashboardViewModel(this._racecourseRepository, this._windDataRepository, this._directionRepository, this._lengthRepository) {
    if(_racecourseRepository.allItems.isEmpty) {
      _fetchRacecourses();
    }
    if(_windDataRepository.windData.isEmpty) {
      _fetchWindData();
    }
    if(_directionRepository.direction.isEmpty) {
      _fetchDirection();
    }
    if(_lengthRepository.lengthData.isEmpty) {
      _fetchLengthData();
    }
  }

  final Map<int, String> _selectedRacecourseMap = {};
  Map<int, String> get selectedRacecourseMap => _selectedRacecourseMap;
  final Map<int, String> _selectedRacecourseTypeMap = {};
  Map<int, String> get selectedRacecourseTypeMap => _selectedRacecourseTypeMap;
  List<Map<String, dynamic>> _windData = [];

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

  List<Map<String, dynamic>> get windData => _windData;

  List<Map<String, dynamic>> get direction => _directionRepository.direction;

  List<Map<String, dynamic>> get lengthData => _lengthRepository.lengthData;

  Future<void> _fetchWindData() async {
    await _windDataRepository.fetchWindData();
    _windData = _windDataRepository.windData;
    notifyListeners();
  }

  Future<void> _fetchRacecourses() async {
    await _racecourseRepository.loadData();
    notifyListeners();
  }

  Future<void> _fetchDirection() async {
    await _directionRepository.fetchDirection();
    notifyListeners();
  }
  
  Future<void> _fetchLengthData() async {
    await _lengthRepository.fetchLengthData();
    notifyListeners();
  }

}
