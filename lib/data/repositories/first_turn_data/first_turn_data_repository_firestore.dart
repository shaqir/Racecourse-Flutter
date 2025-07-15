import 'package:racecourse_tracks/data/repositories/first_turn_data/first_turn_data_repository.dart';
import 'package:racecourse_tracks/data/services/firestore_service.dart';

class FirstTurnDataRepositoryFirestore implements FirstTurnDataRepository {
  final FirestoreService _firestoreService;
  FirstTurnDataRepositoryFirestore(this._firestoreService);
  List<Map<String, dynamic>> _firstTurnData = [];

  @override
  Future<void> fetchAllFirstTurns() async {
    _firstTurnData = await _firestoreService.getAllFirstTurnData();
  }
  
  @override
  List<Map<String, dynamic>> get lengthData => _firstTurnData;
}