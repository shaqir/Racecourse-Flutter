import 'package:racecourse_tracks/data/repositories/user/user_repository.dart';
import 'package:racecourse_tracks/data/services/authentication_service.dart';
import 'package:racecourse_tracks/data/services/firestore_service.dart';
import 'package:racecourse_tracks/domain/models/user.dart';

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
}