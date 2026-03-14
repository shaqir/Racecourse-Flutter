import 'package:flutter/foundation.dart';
import 'package:racecourse_tracks/data/length/length_repository.dart';
import 'package:racecourse_tracks/data/repositories/course_type/course_type_repository.dart';
import 'package:racecourse_tracks/data/repositories/direction/direction_repository.dart';
import 'package:racecourse_tracks/data/repositories/first_turn_data/first_turn_data_repository.dart';
import 'package:racecourse_tracks/data/repositories/racecourse_repository.dart';
import 'package:racecourse_tracks/data/repositories/width_data/width_data_repository.dart';
import 'package:racecourse_tracks/data/repositories/wind_data/wind_data_repository.dart';

class MainDashboardViewModel extends ChangeNotifier {
  final WindDataRepository _windDataRepository;
  final DirectionRepository _directionRepository;
  final LengthRepository _lengthRepository;
  final RacecourseRepository _racecourseRepository;
  final CourseTypeRepository _courseTypeRepository;
  final FirstTurnDataRepository _firstTurnDataRepository;
  final WidthDataRepository _widthDataRepository;

  MainDashboardViewModel(
      {required WindDataRepository windDataRepository,
      required DirectionRepository directionRepository,
      required LengthRepository lengthRepository,
      required RacecourseRepository racecourseRepository,
      required CourseTypeRepository courseTypeRepository,
      required FirstTurnDataRepository firstTurnDataRepository,
      required WidthDataRepository widthDataRepository})
      : _windDataRepository = windDataRepository,
        _directionRepository = directionRepository,
        _lengthRepository = lengthRepository,
        _racecourseRepository = racecourseRepository,
        _courseTypeRepository = courseTypeRepository,
        _firstTurnDataRepository = firstTurnDataRepository,
        _widthDataRepository = widthDataRepository;

  List<Map<String, dynamic>> get windData => _windDataRepository.windData;

  List<Map<String, dynamic>> get direction => _directionRepository.direction;

  List<Map<String, dynamic>> get lengthData => _lengthRepository.lengthData;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> get selectedItemList => _racecourseRepository.selectedItems.toList();
  Map<String, dynamic> get selectedRacecourse => _racecourseRepository.selectedRacecourse;
  Map<String, dynamic> get groundType => _courseTypeRepository.allItems.firstWhere(
      (item) => item['id'] == selectedRacecourse['Type'],
      orElse: () => {'color': null, 'Name': 'Unknown'}
    );

  List<Map<String, dynamic>> get firstTurnData => _firstTurnDataRepository.lengthData;

  List<Map<String, dynamic>> get widthData => _widthDataRepository.widthData;

  Map<String, dynamic>? get racecourseWidthData => widthData.isNotEmpty == true
        ? widthData.firstWhere(
            (data) =>
                data['RacecourseType'] ==
                    selectedRacecourse['Racecourse Type'] && selectedRacecourse['Width'] != null && selectedRacecourse['Width'] != 0 &&
                selectedRacecourse['Width'] >= data['Min'] &&
                selectedRacecourse['Width'] <= data['Max'],
            orElse: () => {})
        : null;

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
      if(_courseTypeRepository.allItems.isEmpty) {
        await _courseTypeRepository.fetchAllCourseTypes();
      }
      if(_firstTurnDataRepository.lengthData.isEmpty) {
        await _firstTurnDataRepository.fetchAllFirstTurns();
      }
      if(_widthDataRepository.widthData.isEmpty) {
        await _widthDataRepository.fetchAllWidthData();
      }
    } catch (e) {
      // Handle errors if necessary
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
