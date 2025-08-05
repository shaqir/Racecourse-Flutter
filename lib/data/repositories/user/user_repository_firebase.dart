import 'package:racecourse_tracks/data/repositories/user/user_repository.dart';
import 'package:racecourse_tracks/data/services/authentication_service.dart';
import 'package:racecourse_tracks/data/services/firestore_service.dart';
import 'package:racecourse_tracks/domain/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserRepositoryFirebase implements UserRepository {
  final AuthenticationService _authenticationService;
  final FirestoreService _firestoreService;
  UserRepositoryFirebase(this._authenticationService, this._firestoreService);

  @override
  Future<User> getCurrentUser() async {
    final userId = _authenticationService.currentUser?.uid;
    if (userId == null) {
      throw Exception('No user is currently authenticated');
    }

    final userData = await _firestoreService.getUserById(userId);
    if (userData == null) {
      throw Exception('User data not found for user ID: $userId');
    }

    return userData;
  }
  
  @override
  Future<void> signOut() async {
    try {
      await _authenticationService.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
  
  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _authenticationService.signInWithEmailAndPassword(email, password);
    } catch (e) {
      throw Exception('Sign-in failed: $e');
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      await _authenticationService.signInWithGoogle();
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }
  
  @override
  Future<void> signUpWithEmailAndPassword(String email, String password, String name) async {
    try {
      await _authenticationService.signUpWithEmailAndPassword(email, password);
      await _authenticationService.updateUserDisplayName(name);
    } catch (e) {
      throw Exception('Sign-up failed: $e');
    }
  }
  
  @override
  firebase_auth.User? get authUser => _authenticationService.currentUser;
  
  @override
  Stream<List<User>> getAllUsers() => _firestoreService.getAllUsers();
  
  @override
  Future<void> signInWithApple() async {
    try {
      await _authenticationService.signInWithApple();
    } catch (e) {
      throw Exception('Apple sign-in failed: $e');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final userId = _authenticationService.currentUser?.uid;
      if (userId != null) {
        // Optionally delete user data from Firestore before deleting the auth account
        // await _firestoreService.deleteUser(userId);
      }
      await _authenticationService.deleteAccount();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> reauthenticateWithPassword(String password) async {
    try {
      await _authenticationService.reauthenticateWithPassword(password);
    } catch (e) {
      throw Exception('Failed to reauthenticate: $e');
    }
  }

  @override
  Future<void> reauthenticateWithGoogle() async {
    try {
      await _authenticationService.reauthenticateWithGoogle();
    } catch (e) {
      throw Exception('Failed to reauthenticate with Google: $e');
    }
  }
  
  @override
  Future<void> reauthenticateWithApple() async {
    try {
      await _authenticationService.reauthenticateWithApple();
    } catch (e) {
      throw Exception('Failed to reauthenticate with Apple: $e');
    }
  }
}