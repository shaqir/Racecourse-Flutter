import 'package:racecourse_tracks/data/repositories/direction/direction_repository.dart';
import 'package:racecourse_tracks/data/services/firestore_service.dart';

class DirectionRepositoryFirestore implements DirectionRepository {
  final FirestoreService _firestoreService;
  List<Map<String, dynamic>> _direction = [];
  DirectionRepositoryFirestore(this._firestoreService);
  @override
  List<Map<String, dynamic>> get direction => _direction;
  
  @override
  Future<void> fetchDirection() async {
    _direction = await _firestoreService.getDirectiondata();
  }
} 