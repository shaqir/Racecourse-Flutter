import 'package:flutter/material.dart';
import 'package:racecourse_tracks/data/length/length_repository.dart';
import 'package:racecourse_tracks/data/repositories/course_type/course_type_repository.dart';
import 'package:racecourse_tracks/data/repositories/direction/direction_repository.dart';
import 'package:racecourse_tracks/data/repositories/first_turn_data/first_turn_data_repository.dart';
import 'package:racecourse_tracks/data/repositories/racecourse_repository.dart';
import 'package:racecourse_tracks/data/repositories/width_data/width_data_repository.dart';
import 'package:racecourse_tracks/data/repositories/wind_data/wind_data_repository.dart';

class CompareDashboardViewModel extends ChangeNotifier {
  final RacecourseRepository _racecourseRepository;
  final WindDataRepository _windDataRepository;
  final DirectionRepository _directionRepository;
  final LengthRepository _lengthRepository;
  final CourseTypeRepository _courseTypeRepository;
  final FirstTurnDataRepository _firstTurnDataRepository;
  final WidthDataRepository _widthDataRepository;
  CompareDashboardViewModel(
      this._racecourseRepository,
      this._windDataRepository,
      this._directionRepository,
      this._lengthRepository,
      this._courseTypeRepository,
      this._firstTurnDataRepository,
      this._widthDataRepository);

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
    if (_selectedRacecourseTypeMap[index] != selectedRacecourseType) {
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
  List<Map<String, dynamic>> get groundTypes => _courseTypeRepository.allItems;
  List<Map<String, dynamic>> get firstTurnData =>
      _firstTurnDataRepository.lengthData;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> get widthData => _widthDataRepository.widthData;

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
    if (_courseTypeRepository.allItems.isEmpty) {
      await _courseTypeRepository.fetchAllCourseTypes();
    }
    if (_firstTurnDataRepository.lengthData.isEmpty) {
      await _firstTurnDataRepository.fetchAllFirstTurns();
    }
    if (_widthDataRepository.widthData.isEmpty) {
      await _widthDataRepository.fetchAllWidthData();
    }
    _isLoading = false;
    notifyListeners();
  }
}
