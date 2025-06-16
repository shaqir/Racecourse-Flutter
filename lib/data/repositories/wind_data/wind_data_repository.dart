abstract class WindDataRepository {
  List<Map<String, dynamic>> get windData;
  Future<void> fetchWindData();
}