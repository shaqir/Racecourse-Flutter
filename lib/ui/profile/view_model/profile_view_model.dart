import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
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
  RequestState get restorePurchasesRequestState =>
      _restorePurchasesRequestState;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  RequestState _signOutRequestState = RequestState.idle;
  RequestState get signOutRequestState => _signOutRequestState;
  RequestState _deleteAccountRequestState = RequestState.idle;
  RequestState get deleteAccountRequestState => _deleteAccountRequestState;
  final _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;
  bool _showPasswordField = false;
  bool get showPasswordField => _showPasswordField;
  bool _isReauthenticating = false;
  bool get isReauthenticating => _isReauthenticating;

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
      _signOutRequestState = RequestState.pending;
      notifyListeners();
      await _userRepository.signOut();
      _currentUser = null;
      _signOutRequestState = RequestState.completed;
      notifyListeners();
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

  Future<bool> deleteAccount() async {
    try {
      _deleteAccountRequestState = RequestState.pending;
      notifyListeners();
      await _userRepository.deleteAccount();
      _currentUser = null;
      _deleteAccountRequestState = RequestState.completed;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _isReauthenticating = true;
        notifyListeners();
        final provider =
            _userRepository.authUser?.providerData.first.providerId;
        switch (provider) {
          case 'google.com':
            await _userRepository.reauthenticateWithGoogle();
            return deleteAccount();
          case 'apple.com':
            await _userRepository.reauthenticateWithApple();
            return deleteAccount();
          default:
            _showPasswordField = true;
            notifyListeners();
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
      _deleteAccountRequestState = RequestState.failed;
      notifyListeners();
    }
    return false;
  }

  Future<void> reauthenticateWithPassword(String password) async {
    try {
      await _userRepository.reauthenticateWithPassword(password);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> reauthenticateWithGoogle() async {
    try {
      await _userRepository.reauthenticateWithGoogle();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> reauthenticateWithApple() async {
    try {
      await _userRepository.reauthenticateWithApple();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
