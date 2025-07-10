import 'package:flutter/material.dart';
import 'package:racecourse_tracks/data/repositories/user/user_repository.dart';
import 'package:racecourse_tracks/utils/request_state.dart';

class SignUpViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  SignUpViewModel(this._userRepository);
  RequestState _signUpWithEmailAndPasswordRequestState = RequestState.idle;
  RequestState get signUpWithEmailAndPasswordRequestState =>
      _signUpWithEmailAndPasswordRequestState;
  String? _signUpWithEmailAndPasswordErrorMessage;
  String? get signUpWithEmailAndPasswordErrorMessage =>
      _signUpWithEmailAndPasswordErrorMessage;
  RequestState _signUpWithGoogleRequestState = RequestState.idle;
  RequestState get signUpWithGoogleRequestState =>
      _signUpWithGoogleRequestState;
  String? _signUpWithGoogleErrorMessage;
  String? get signUpWithGoogleErrorMessage =>
      _signUpWithGoogleErrorMessage;

  Future<void> signUpWithEmailAndPassword(
      String email, String password, String name) async {
    _signUpWithEmailAndPasswordRequestState = RequestState.pending;
    notifyListeners(); // Notify listeners about the state change
    try {
      await _userRepository.signUpWithEmailAndPassword(email, password, name);
      _signUpWithEmailAndPasswordRequestState = RequestState.completed;
      notifyListeners(); // Notify listeners after successful sign-up
    } catch (e) {
      _signUpWithEmailAndPasswordRequestState = RequestState.failed;
      _signUpWithEmailAndPasswordErrorMessage = e.toString();
      notifyListeners(); // Notify listeners about the error
    }
  }
  Future<void> signUpWithGoogle() async {
    _signUpWithGoogleRequestState = RequestState.pending;
    notifyListeners(); // Notify listeners about the state change
    try {
      await _userRepository.signInWithGoogle();
      _signUpWithGoogleRequestState = RequestState.completed;
      notifyListeners(); // Notify listeners after successful sign-up
    } catch (e) {
      _signUpWithGoogleRequestState = RequestState.failed;
      _signUpWithGoogleErrorMessage = e.toString();
      notifyListeners(); // Notify listeners about the error
    }
  }
}