abstract class WidthDataRepository {
  List<Map<String, dynamic>> get widthData;

  Future<void> fetchAllWidthData();
}