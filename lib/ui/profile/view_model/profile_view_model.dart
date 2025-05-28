import 'package:flutter/material.dart';
import 'package:racecourse_tracks/data/repositories/user/user_repository.dart';
import 'package:racecourse_tracks/data/repositories/user_subscription/user_subscription_repository.dart';
import 'package:racecourse_tracks/domain/models/user.dart';
import 'package:racecourse_tracks/utils/request_state.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({
    required UserRepository userRepository,
    required UserSubscriptionRepository subscriptionRepository,
  })  : _userRepository = userRepository,
        _subscriptionRepository = subscriptionRepository {
    _load();
  }

  final UserRepository _userRepository;
  final UserSubscriptionRepository _subscriptionRepository;
  User? _currentUser;
  User? get currentUser => _currentUser;
  RequestState _loadRequestState = RequestState.pending;
  RequestState get loadRequestState => _loadRequestState;
  RequestState _restorePurchasesRequestState = RequestState.idle;
  RequestState get restorePurchasesRequestState => _restorePurchasesRequestState;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;


  void _load() async {
    try {
      _currentUser = await _userRepository.getCurrentUser();
      _loadRequestState = RequestState.completed;
    } catch (e) {
      _currentUser = null;
      _loadRequestState = RequestState.failed;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _userRepository.signOut();
      _currentUser = null;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> restorePurchases() async {
    _restorePurchasesRequestState = RequestState.pending;
    notifyListeners();

    try {
      await _subscriptionRepository.restorePurchases();
      _restorePurchasesRequestState = RequestState.completed;
    } catch (e) {
      _restorePurchasesRequestState = RequestState.failed;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}