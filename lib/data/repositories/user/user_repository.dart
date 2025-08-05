import 'package:racecourse_tracks/domain/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract class UserRepository {
  firebase_auth.User? get authUser;

  Future<User> getCurrentUser();
  Future<void> signOut();
  Future<void> deleteAccount();
  Future<void> reauthenticateWithPassword(String password);
  Future<void> reauthenticateWithGoogle();
  Future<void> reauthenticateWithApple();

  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> signInWithGoogle();
  Future<void> signInWithApple();

  Future<void> signUpWithEmailAndPassword(String email, String password, String name);
  Stream<List<User>> getAllUsers();
}