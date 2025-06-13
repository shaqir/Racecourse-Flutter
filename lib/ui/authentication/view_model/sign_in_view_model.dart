import 'package:flutter/material.dart';
import 'package:racecourse_tracks/data/repositories/user/user_repository.dart';
import 'package:racecourse_tracks/utils/request_state.dart';

class SignInViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  SignInViewModel(this._userRepository);

  RequestState _signInWithEmailAndPasswordRequestState = RequestState.idle;
  RequestState get signInWithEmailAndPasswordRequestState =>
      _signInWithEmailAndPasswordRequestState;
  String? _signInWithEmailAndPasswordErrorMessage;
  String? get signInWithEmailAndPasswordErrorMessage =>
      _signInWithEmailAndPasswordErrorMessage;
  RequestState _signInWithGoogleRequestState = RequestState.idle;
  RequestState get signInWithGoogleRequestState =>
      _signInWithGoogleRequestState;
  String? _signInWithGoogleErrorMessage;
  String? get signInWithGoogleErrorMessage =>
      _signInWithGoogleErrorMessage;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _signInWithEmailAndPasswordRequestState = RequestState.pending;
    notifyListeners(); // Notify listeners about the state change
    try {
      await _userRepository.signInWithEmailAndPassword(email, password);
      _signInWithEmailAndPasswordRequestState = RequestState.completed;
      notifyListeners(); // Notify listeners after successful sign-in
    } catch (e) {
      _signInWithEmailAndPasswordRequestState = RequestState.failed;
      _signInWithEmailAndPasswordErrorMessage = e.toString();
      notifyListeners(); // Notify listeners about the error
    }
  }

  Future<void> signInWithGoogle() async {
    _signInWithGoogleRequestState = RequestState.pending;
    notifyListeners(); // Notify listeners about the state change
    try {
      await _userRepository.signInWithGoogle();
      _signInWithGoogleRequestState = RequestState.completed;
      notifyListeners(); // Notify listeners after successful sign-in
    } catch (e) {
      _signInWithGoogleRequestState = RequestState.failed;
      _signInWithGoogleErrorMessage = e.toString();
      notifyListeners(); // Notify listeners about the error
    }
  }
}