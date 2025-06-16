import 'package:flutter/foundation.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:racecourse_tracks/data/repositories/racecourse_repository.dart';
import 'package:racecourse_tracks/data/repositories/user_subscription/user_subscription_repository.dart';
import 'package:racecourse_tracks/data/repositories/wind_data/wind_data_repository.dart';
import 'package:racecourse_tracks/domain/models/user_subscription.dart';
import 'package:racecourse_tracks/utils/request_state.dart';

class FreeDashboardViewModel extends ChangeNotifier {
  FreeDashboardViewModel(
      {required RacecourseRepository racecourseRepository,
      required UserSubscriptionRepository userSubscriptionRepository,
      required WindDataRepository windDataRepository})
      : _racecourseRepository = racecourseRepository,
        _userSubscriptionRepository = userSubscriptionRepository,
        _windDataRepository = windDataRepository {
    if(_racecourseRepository.allItems.isEmpty) {
      _loadRacecourses();
    }
    _loadUserSubscription();
  }
  final RacecourseRepository _racecourseRepository;
  final UserSubscriptionRepository _userSubscriptionRepository;
  final WindDataRepository _windDataRepository;
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
  late Map<String, dynamic> _selectedRacecourse;
  String _selectedRacecourseType = 'Gallops';
  Map<String, dynamic> get selectedRacecourse => _selectedRacecourse;
  UserSubscription? _userSubscription;
  UserSubscription? get userSubscription => _userSubscription;

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
        .where((racecourse) =>
            racecourse['Racecourse Type'] == _selectedRacecourseType)
        .map((racecourse) => racecourse['Racecourse'] as String)
        .toList();
  }

  List<Map<String, dynamic>> get windData => _windDataRepository.windData;

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
    await _racecourseRepository.loadData();
    _selectedRacecourse = _racecourseRepository.allItems
        .firstWhere((racecourse) => racecourse['Racecourse Type'] == 'Gallops');
    notifyListeners();
  }
}
