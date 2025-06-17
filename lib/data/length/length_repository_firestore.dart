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

  @override
  Map<String, dynamic>? getLengthColor(String racecourseType, size) {
    for (var data in lengthData) {
      if (racecourseType == data['RacecourseType'] &&
          size == data['Length Type']) {
        return data; // Return the first match
      }
    }
    return null; // Return null if no match is found
  }
}