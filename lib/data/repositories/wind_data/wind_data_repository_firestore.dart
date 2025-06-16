import 'package:racecourse_tracks/data/repositories/wind_data/wind_data_repository.dart';
import 'package:racecourse_tracks/data/services/firestore_service.dart';

class WindDataRepositoryFirestore implements WindDataRepository {
  final FirestoreService _firestoreService;
  List<Map<String, dynamic>> _windData = [];

  WindDataRepositoryFirestore(this._firestoreService);
  
  @override
  Future<void> fetchWindData() async {
    _windData = await _firestoreService.getWinddata();
  }
  
  @override
  List<Map<String, dynamic>> get windData => _windData;
}