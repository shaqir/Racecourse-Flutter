abstract class DirectionRepository {
  List<Map<String, dynamic>> get direction;

  Future<void> fetchDirection();
}