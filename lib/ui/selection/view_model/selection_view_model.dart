import 'package:flutter/foundation.dart';
import 'package:racecourse_tracks/data/repositories/racecourse_repository.dart';

class SelectionViewModel extends ChangeNotifier {
  final RacecourseRepository _racecourseRepository;
  SelectionViewModel(this._racecourseRepository);
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Set<Map<String, dynamic>> get allItems => _racecourseRepository.allItems;

  Set<Map<String, dynamic>> get savedItems => _racecourseRepository.savedItems;

  bool get clearButtonEnabled => _racecourseRepository.clearButtonEnabled;

  void init() {
    _racecourseRepository.addListener(() {
      notifyListeners();
    });
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();
    if (_racecourseRepository.allItems.isEmpty) {
      await _racecourseRepository.loadData();
    }
    if (_racecourseRepository.selectedItems.isEmpty) {
      await _racecourseRepository.fetchSelectedItems();
    }
    _isLoading = false;
    notifyListeners();
  }

  void resetSelectedItems() => _racecourseRepository.resetSelectedItems();

  void resetAll() => _racecourseRepository.resetAll();

  void toggleClearSelection() => _racecourseRepository.toggleClearSelection();

  void favoriteSelection(Map<String, dynamic> item, bool newFavoriteStatus) =>
      _racecourseRepository.favoriteSelection(item, newFavoriteStatus);

  void updateFavoriteList(Map<String, dynamic> item, bool newFavoriteStatus) =>
      _racecourseRepository.updateFavoriteList(item, newFavoriteStatus);

  void toggleSelection(Map<String, dynamic> item, bool bool) =>
      _racecourseRepository.toggleSelection(item, bool);

  void updateSelectedList(Map<String, dynamic> item, bool bool) =>
      _racecourseRepository.updateSelectedList(item, bool);
}
