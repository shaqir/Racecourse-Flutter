import 'package:flutter/foundation.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:racecourse_tracks/data/length/length_repository.dart';
import 'package:racecourse_tracks/data/repositories/course_type/course_type_repository.dart';
import 'package:racecourse_tracks/data/repositories/direction/direction_repository.dart';
import 'package:racecourse_tracks/data/repositories/racecourse_repository.dart';
import 'package:racecourse_tracks/data/repositories/user_subscription/user_subscription_repository.dart';
import 'package:racecourse_tracks/data/repositories/width_data/width_data_repository.dart';
import 'package:racecourse_tracks/data/repositories/wind_data/wind_data_repository.dart';
import 'package:racecourse_tracks/domain/models/user_subscription.dart';
import 'package:racecourse_tracks/utils/request_state.dart';

class FreeDashboardViewModel extends ChangeNotifier {
  FreeDashboardViewModel(
      {required RacecourseRepository racecourseRepository,
      required UserSubscriptionRepository userSubscriptionRepository,
      required WindDataRepository windDataRepository,
      required DirectionRepository directionRepository,
      required LengthRepository lengthDataRepository,
      required CourseTypeRepository courseTypeRepository,
      required WidthDataRepository widthDataRepository})
      : _racecourseRepository = racecourseRepository,
        _userSubscriptionRepository = userSubscriptionRepository,
        _windDataRepository = windDataRepository,
        _directionRepository = directionRepository,
        _lengthDataRepository = lengthDataRepository,
        _courseTypeRepository = courseTypeRepository,
        _widthDataRepository = widthDataRepository;

  void init() {
      _isLoading = true;
      notifyListeners();
      _loadRacecourses();
    
      _loadUserSubscription();
      _loadWindData();
      _loadDirectionData();
      _loadLengthData();
      _fetchAllCourseTypes();
      _fetchAllWidthData();
      _isLoading = false;
      notifyListeners();
  }

  final RacecourseRepository _racecourseRepository;
  final UserSubscriptionRepository _userSubscriptionRepository;
  final WindDataRepository _windDataRepository;
  final DirectionRepository _directionRepository;
  final LengthRepository _lengthDataRepository;
  final CourseTypeRepository _courseTypeRepository;
  final WidthDataRepository _widthDataRepository;
  RequestState get loadingRacecoursesRequestState =>
      _racecourseRepository.allItems.isEmpty
          ? RequestState.pending
          : RequestState.completed;
  RequestState _loadingSubscriptionRequestState = RequestState.pending;
  RequestState get loadingSubscriptionRequestState =>
      _loadingSubscriptionRequestState;
  RequestState _presentPaywallRequestState = RequestState.idle;
  RequestState get presentPaywallRequestState => _presentPaywallRequestState;
  List<Map<String, dynamic>> get racecourses =>
      _racecourseRepository.allItems.toList();
  Map<String, dynamic>? _selectedRacecourse;
  
  Map<String, dynamic>? get selectedRacecourse => _selectedRacecourse;
  UserSubscription? _userSubscription;
  UserSubscription? get userSubscription => _userSubscription;
  Map<String, dynamic> get groundType => _courseTypeRepository.allItems.firstWhere(
      (item) => item['id'] == _selectedRacecourse?['Type'],
      orElse: () => {'color': null, 'Name': 'Unknown'}
    );

  void setSelectedRacecourse(String racecourse) {
    _selectedRacecourse =
        racecourses.firstWhere((rc) => rc['Racecourse'] == racecourse && 
            rc['Racecourse Type'] == _selectedRacecourseType);
    notifyListeners();
  }

  String _selectedRacecourseType = 'Gallops';
  String get selectedRacecourseType => _selectedRacecourseType;
  void setSelectedRacecourseType(String racecourseType) {
    _selectedRacecourseType = racecourseType;
    _selectedRacecourse = racecourses.firstWhere(
        (rc) => rc['Racecourse Type'] == racecourseType);
    notifyListeners();
  }

  List<String> get filteredRacecourses {
    return racecourses
        .where((racecourse) =>
            racecourse['Racecourse Type'] == _selectedRacecourseType)
        .map((racecourse) => racecourse['Racecourse'] as String)
        .toList();
  }

  List<Map<String, dynamic>> get windData => _windDataRepository.windData;

  List<Map<String, dynamic>> get direction => _directionRepository.direction;

  List<Map<String, dynamic>> get lengthData => _lengthDataRepository.lengthData;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> get widthData => _widthDataRepository.widthData;

  Future<void> _loadUserSubscription() async {
    _userSubscription = await _userSubscriptionRepository.getSubscription();
    _loadingSubscriptionRequestState = RequestState.completed;
    notifyListeners();
    _userSubscriptionRepository
        .getSubscriptionStream()
        .listen((UserSubscription subscription) {
      _userSubscription = subscription;
      notifyListeners();
    });
  }

  Future<void> presentPaywall() async {
    _presentPaywallRequestState = RequestState.pending;
    notifyListeners();
    try {
      await RevenueCatUI.presentPaywall();
      _presentPaywallRequestState = RequestState.completed;
    } catch (e) {
      _presentPaywallRequestState = RequestState.failed;
      notifyListeners();
      // Handle the error, e.g., log it or show a message
      if (kDebugMode) {
        print('Error presenting paywall: $e');
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> _loadRacecourses() async {
    notifyListeners();
    await _racecourseRepository.loadData();
    _selectedRacecourse = _racecourseRepository.allItems
        .firstWhere((racecourse) => racecourse['Racecourse Type'] == 'Gallops');
  
    notifyListeners();
  }

  Future<void> _loadWindData() async {
    if(_windDataRepository.windData.isNotEmpty) {
      return; // No need to fetch if data is already loaded
    }
    await _windDataRepository.fetchWindData();
    notifyListeners();
  }

  Future<void> _loadDirectionData() async {
    if(_directionRepository.direction.isNotEmpty) {
      return; // No need to fetch if data is already loaded
    }
    await _directionRepository.fetchDirection();
    notifyListeners();
  }

  Future<void> _loadLengthData() async {
    if(_lengthDataRepository.lengthData.isNotEmpty) {
      return; // No need to fetch if data is already loaded
    }
    await _lengthDataRepository.fetchLengthData();
    notifyListeners();
  }

  Future<void> _fetchAllCourseTypes() async {
    if(_courseTypeRepository.allItems.isNotEmpty) {
      return; // No need to fetch if data is already loaded
    }
    await _courseTypeRepository.fetchAllCourseTypes();
    notifyListeners();
  }

  Future<void> _fetchAllWidthData() async {
    if(_widthDataRepository.widthData.isNotEmpty) {
      return; // No need to fetch if data is already loaded
    }
    await _widthDataRepository.fetchAllWidthData();
    notifyListeners();
  }
}
