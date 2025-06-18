import 'package:racecourse_tracks/data/repositories/user/user_repository.dart';
import 'package:racecourse_tracks/domain/models/user.dart';

class AllUsersViewModel {
  final UserRepository _userRepository;

  AllUsersViewModel(this._userRepository);

  Stream<List<User>> getAllUsers() => _userRepository.getAllUsers();
}