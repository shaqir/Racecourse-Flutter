import 'package:racecourse_tracks/domain/models/scenario.dart';

abstract class ScenarioRepository {
  Future<List<Scenario>> getAllScenarios();
}
