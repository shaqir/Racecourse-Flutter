import 'package:flutter/material.dart';
import 'package:racecourse_tracks/data/repositories/settings_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsRepository _settingsRepository;
  SettingsViewModel(this._settingsRepository);

  String get distanceUnitValue => _settingsRepository.distanceUnitValue;

  void setSelectedDistanceUnit(DistanceUnit unit) {
    _settingsRepository.setSelectedDistanceUnit(unit);
    notifyListeners();
  }
}