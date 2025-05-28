import 'package:racecourse_tracks/domain/models/user.dart';

abstract class UserRepository {
  Future<User> getCurrentUser();
  Future<void> signOut();
}