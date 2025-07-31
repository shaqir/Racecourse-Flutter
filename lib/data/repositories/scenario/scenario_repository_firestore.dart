import 'package:racecourse_tracks/data/repositories/scenario/scenario_repository.dart';
import 'package:racecourse_tracks/data/services/firestore_service.dart';
import 'package:racecourse_tracks/domain/models/scenario.dart';

class ScenarioRepositoryFirestore implements ScenarioRepository {
  final FirestoreService _firestoreService;
  ScenarioRepositoryFirestore(this._firestoreService);
  @override
  Future<List<Scenario>> getAllScenarios() async {
    final scenariosData = await _firestoreService.getAllScenarios();
    return scenariosData;
  }
}