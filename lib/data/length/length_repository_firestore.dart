import 'package:racecourse_tracks/data/length/length_repository.dart';
import 'package:racecourse_tracks/data/services/firestore_service.dart';

class LengthRepositoryFirestore implements LengthRepository {
  final FirestoreService _firestoreService;
  List<Map<String, dynamic>> _lengthData = [];
  LengthRepositoryFirestore(this._firestoreService);
  @override
  List<Map<String, dynamic>> get lengthData => _lengthData;
  
  @override
  Future<void> fetchLengthData() async {
    _lengthData = await _firestoreService.getLengthdata();
  }
}