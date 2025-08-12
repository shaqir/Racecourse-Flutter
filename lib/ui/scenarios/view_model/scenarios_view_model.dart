import 'package:flutter/foundation.dart';
import 'package:racecourse_tracks/data/repositories/app_text/app_text_repository.dart';
import 'package:racecourse_tracks/data/repositories/scenario/scenario_repository.dart';
import 'package:racecourse_tracks/domain/models/app_text.dart';
import 'package:racecourse_tracks/domain/models/scenario.dart';

class ScenariosViewModel extends ChangeNotifier {
  bool _loading = false;
  List<Scenario> _scenarios = [];
  Scenario? _selectedScenario;

  bool get loading => _loading;
  List<Scenario> get scenarios => _scenarios;
  Scenario? get selectedScenario => _selectedScenario;
  Map<String, AppText> get appTexts => _appTextRepository.appTexts;
  final ScenarioRepository _scenarioRepository;
  final AppTextRepository _appTextRepository;

  ScenariosViewModel(this._scenarioRepository, this._appTextRepository) {
    _initializeScenarios();
  }

  Future<void> _initializeScenarios() async {
    _loading = true;
    notifyListeners();

    _scenarios = await _scenarioRepository.getAllScenarios();
    if(_appTextRepository.appTexts.isEmpty) {
      await _appTextRepository.fetchAppTexts();
    }
    _loading = false;
    notifyListeners();
  }

  void selectScenario(Scenario scenario) {
    _selectedScenario = scenario;
    notifyListeners();
  }

  void clearSelection() {
    _selectedScenario = null;
    notifyListeners();
  }

  List<Scenario> getScenariosByType(String type) {
    return _scenarios.where((scenario) => scenario.type == type).toList();
  }

  Scenario? getScenarioById(String id) {
    try {
      return _scenarios.firstWhere((scenario) => scenario.id == id);
    } catch (e) {
      return null;
    }
  }
}
