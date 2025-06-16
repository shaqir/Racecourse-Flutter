abstract class LengthRepository {
  List<Map<String, dynamic>> get lengthData;

  Future<void> fetchLengthData();
}