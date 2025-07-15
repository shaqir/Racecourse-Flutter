import 'package:racecourse_tracks/data/repositories/course_type/course_type_repository.dart';
import 'package:racecourse_tracks/data/services/firestore_service.dart';

class CourseTypeRepositoryFirestore implements CourseTypeRepository {
  final FirestoreService _firestoreService;
  List<Map<String, dynamic>> _allItems = [];
  @override
  List<Map<String, dynamic>> get allItems => _allItems;

  CourseTypeRepositoryFirestore(this._firestoreService);

  @override
  Future<void> fetchAllCourseTypes() async {
    try {
      _allItems = await _firestoreService.getAllCourseTypes();
    } catch (e) {
      throw Exception('Failed to fetch course types: $e');
    }
  }
}
