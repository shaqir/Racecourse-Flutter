import 'package:flutter/foundation.dart';
import 'package:racecourse_tracks/data/length/length_repository.dart';
import 'package:racecourse_tracks/data/repositories/direction/direction_repository.dart';
import 'package:racecourse_tracks/data/repositories/racecourse_repository.dart';
import 'package:racecourse_tracks/data/repositories/wind_data/wind_data_repository.dart';

class MainDashboardViewModel extends ChangeNotifier {
  final WindDataRepository _windDataRepository;
  final DirectionRepository _directionRepository;
  final LengthRepository _lengthRepository;
  final RacecourseRepository _racecourseRepository;

  MainDashboardViewModel(
      {required WindDataRepository windDataRepository,
      required DirectionRepository directionRepository,
      required LengthRepository lengthRepository,
      required RacecourseRepository racecourseRepository})
      : _windDataRepository = windDataRepository,
        _directionRepository = directionRepository,
        _lengthRepository = lengthRepository,
        _racecourseRepository = racecourseRepository;

  List<Map<String, dynamic>> get windData => _windDataRepository.windData;

  List<Map<String, dynamic>> get direction => _directionRepository.direction;

  List<Map<String, dynamic>> get lengthData => _lengthRepository.lengthData;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> get selectedItemList => _racecourseRepository.selectedItems.toList();
  Map<String, dynamic> get selectedRacecourse => _racecourseRepository.selectedRacecourse;

  void init() {
    _loadData();
    _racecourseRepository.addListener(() {
      notifyListeners();
    });
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();
    try {
      if(_racecourseRepository.selectedItems.isEmpty) {
        await _racecourseRepository.fetchSelectedItems();
      }
      if(_racecourseRepository.selectedRacecourse.isEmpty) {
        await _racecourseRepository.fetchSelectedRacecourse();
      }
      if(_windDataRepository.windData.isEmpty) {
        await _windDataRepository.fetchWindData();
      }
      if(_directionRepository.direction.isEmpty) {
        await _directionRepository.fetchDirection();
      }
      if(_lengthRepository.lengthData.isEmpty) {
        await _lengthRepository.fetchLengthData();
      }
    } catch (e) {
      // Handle errors if necessary
      if (kDebugMode) {
        print('Error loading data: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshSelectedRacecourse() async {
    _isLoading = true;
    notifyListeners();
    await _racecourseRepository.refreshSelectedRacecourse();
    _isLoading = false;
    notifyListeners();
  }

  void setSelectedRacecource(String selectedRacecourse, String selectedRacecourseType) {
    _racecourseRepository.setSelectedRacecource(selectedRacecourse, selectedRacecourseType);
  }
}
