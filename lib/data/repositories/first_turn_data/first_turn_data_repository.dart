abstract class FirstTurnDataRepository {
  List<Map<String, dynamic>> get lengthData;

  Future<void> fetchAllFirstTurns();
}
