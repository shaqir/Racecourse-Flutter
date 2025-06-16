import 'package:flutter/material.dart';
import 'package:racecourse_tracks/data/repositories/racecourse_repository.dart';

class SelectionViewModel extends ChangeNotifier {
  final RacecourseRepository _racecourseRepository;
  SelectionViewModel(this._racecourseRepository) {
    _racecourseRepository.addListener(notifyListeners);
  }
  bool get isLoading => _racecourseRepository.isLoading;

  Future<void> loadSelectedItems(Set<Map<String, dynamic>>? items) async {
    await _racecourseRepository.loadSelectedItems(items);
  }
}