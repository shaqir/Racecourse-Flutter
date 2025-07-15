abstract class CourseTypeRepository {
  List<Map<String, dynamic>> get allItems;
  Future<void> fetchAllCourseTypes();
}