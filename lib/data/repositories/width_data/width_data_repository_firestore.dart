import 'package:racecourse_tracks/data/repositories/width_data/width_data_repository.dart';
import 'package:racecourse_tracks/data/services/firestore_service.dart';

class WidthDataRepositoryFirestore implements WidthDataRepository {
  final FirestoreService _firestoreService;
  WidthDataRepositoryFirestore(this._firestoreService);
  List<Map<String, dynamic>> _widthData = [];
  @override
  Future<void> fetchAllWidthData() async {
    _widthData = await _firestoreService.getWidthData();
  }

  @override
  List<Map<String, dynamic>> get widthData => _widthData;
}