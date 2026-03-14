import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:racecourse_tracks/data/services/cloud_functions_service.dart';
import 'package:racecourse_tracks/data/services/firestore_service.dart';
import 'package:racecourse_tracks/data/services/shared_preferences_service.dart';
import 'package:collection/collection.dart';

class RacecourseRepository extends ChangeNotifier {
  final CloudFunctionsService _cloudFunctionsService;
  final FirestoreService _firestoreService;
  Set<Map<String, dynamic>> _allItems = {};
  Set<Map<String, dynamic>> _savedItems = {};
  bool _clearButtonEnabled = false;
  Map<String, dynamic> _selectedRacecourse = {};

  Set<Map<String, dynamic>> get allItems => _allItems;
  Set<Map<String, dynamic>> get savedItems => _savedItems;
  Set<Map<String, dynamic>> get selectedItems => _savedItems
          .where((item) => item['isSelected'] == true)
          .sorted((a, b) => a['Racecourse'].compareTo(b['Racecourse']))
          .sorted((a, b) {
        final aType = switch (a['Racecourse Type']) {
          'Gallops' => 0,
          'Harness' => 1,
          _ => 2
        };
        final bType = switch (b['Racecourse Type']) {
          'Gallops' => 0,
          'Harness' => 1,
          _ => 2
        };
        return aType.compareTo(bType);
      }).toSet();
  bool get clearButtonEnabled => _clearButtonEnabled;
  Map<String, dynamic> get selectedRacecourse => _selectedRacecourse;

  RacecourseRepository(
      {required CloudFunctionsService cloudFunctionsService,
      required FirestoreService firestoreService})
      : _cloudFunctionsService = cloudFunctionsService,
        _firestoreService = firestoreService;

  Future<void> loadData() async {
    final racecourses = await _firestoreService.getRacecourses();
    setAllItems(racecourses.toSet());
    resetAll();
    notifyListeners();
  }

  // Method to load selected items from SharedPreferences
  Future<void> loadSelectedItems(Set<Map<String, dynamic>> items) async {
    if (items.isNotEmpty) {
      for (var allItem in _allItems) {
        for (var loadedItem in items) {
          if (loadedItem['Racecourse'] == allItem['Racecourse'] &&
              loadedItem['Racecourse Type'] == allItem['Racecourse Type']) {
            _savedItems.remove(allItem);
            _savedItems.removeWhere((map) =>
                map['Racecourse'] == allItem["Racecourse"] &&
                map['Racecourse Type'] == allItem["Racecourse Type"]);

            allItem['isSelected'] = loadedItem['isSelected'];
            allItem['isFavorite'] = loadedItem['isFavorite'];
            _savedItems.add(allItem);
          }
        }
      }
    }

    // if (items != null && items.length > 0) {
    //   _selectedItems = items;
    // }
    setDefaultSelected();
  }

  void setAllItems(Set<Map<String, dynamic>> items) {
    _allItems = items;
    notifyListeners(); // Notify listeners about the new data
  }

  void resetAll() {
    for (var item in _allItems) {
      item['isSelected'] = false;
      item['isFavorite'] = false;
    }
    notifyListeners();
  }

  void resetSelectedItems() {
    _savedItems.clear();
    notifyListeners();
  }

  void setDefaultSelected() {
    List<Map<String, dynamic>> listFromSet2 = _allItems.toList();
    // Convert _allItems set to a list and loop through _selectedItems
    for (var element in _savedItems) {
      // Use custom comparison and ignore 'isSelected' field
      if (_allItems.any((item) => areMapsEqualIgnoringField(
          item, element, 'isSelected', 'isFavorite'))) {
        int indexofelement = listFromSet2.indexWhere((item) =>
            areMapsEqualIgnoringField(
                item, element, 'isSelected', 'isFavorite'));
        // Mark the element as selected (update the map with the 'isSelected' field)
        listFromSet2[indexofelement]['isSelected'] = element['isSelected'];
        listFromSet2[indexofelement]['isFavorite'] = element['isFavorite'];
      }
    }
    notifyListeners();
  }

// Custom comparison that ignores the 'isSelected' field
  bool areMapsEqualIgnoringField(Map<String, dynamic> map1,
      Map<String, dynamic> map2, String ignoreField, String ignoreField1) {
    // Create copies of the maps without the field to ignore
    Map<String, dynamic> filteredMap1 = Map.from(map1)
      ..remove(ignoreField)
      ..remove(ignoreField1);
    Map<String, dynamic> filteredMap2 = Map.from(map2)
      ..remove(ignoreField)
      ..remove(ignoreField1);

    // Compare the filtered maps using mapEquals
    return mapEquals(filteredMap1, filteredMap2);
  }

  bool areMapsEqual(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    // Compare map keys and values (ignoring the 'isSelected' field)
    return map1.keys
        .every((key) => map2.containsKey(key) && map1[key] == map2[key]);
  }

  void toggleClearSelection() {
    _clearButtonEnabled = savedItems.isNotEmpty;
    saveUserData(_savedItems);
    notifyListeners();
  }

  void toggleSwipeEnable(bool value) {
    notifyListeners();
  }

  bool _isEqualMap(Map<String, dynamic> a, Map<String, dynamic> b) {
    return MapEquality().equals(a, b);
  }

  void updateSelectedList(Map<String, dynamic> item, bool value) {
    // if (value) {
    if (_savedItems.any((element) => _isEqualMap(element, item))) {
      _savedItems.remove(item);
      _savedItems.removeWhere((map) =>
          map['Racecourse'] == item["Racecourse"] &&
          map['Racecourse Type'] == item["Racecourse Type"]);
      Map<String, dynamic> updatedItem = Map.from(item);
      updatedItem['isSelected'] = value;
      _savedItems.add(updatedItem);
    } else {
      Map<String, dynamic> newItem = Map.from(item);
      newItem['isSelected'] = value;
      _savedItems.add(newItem);
    }
    saveUserData(_savedItems);
    if (value == false &&
        _selectedRacecourse['Racecourse'] == item['Racecourse'] &&
        _selectedRacecourse['Racecourse Type'] == item['Racecourse Type']) {
      _selectedRacecourse = selectedItems.isNotEmpty ? selectedItems.first : {};
      SharedPreferencesService.saveSelectedRaceCourseToPreferences(
          _selectedRacecourse);
    }
    notifyListeners();
  }

  void updateFavoriteList(Map<String, dynamic> item, bool value) {
    // if (value) {
    if (_savedItems.any((element) => _isEqualMap(element, item))) {
      _savedItems.remove(item);
      _savedItems.removeWhere((map) =>
          map['Racecourse'] == item["Racecourse"] &&
          map['Racecourse Type'] == item["Racecourse Type"]);
      Map<String, dynamic> updatedItem = Map.from(item);
      updatedItem['isFavorite'] = value;
      _savedItems.add(updatedItem);
    } else {
      Map<String, dynamic> newItem = Map.from(item);
      newItem['isFavorite'] = value;
      _savedItems.add(newItem);
    }

    saveUserData(_savedItems);
    notifyListeners();
  }

  void favoriteSelection(Map<String, dynamic> item, bool value) {
    List<Map<String, dynamic>> listFromSet = _allItems.toList();
    if (listFromSet.contains(item)) {
      listFromSet.remove(item);
      Map<String, dynamic> updatedItem = Map.from(item);
      updatedItem['isFavorite'] = value;
      listFromSet.add(updatedItem);
      _allItems = listFromSet.toSet();
    } else {
      Map<String, dynamic> newItem = Map.from(item);
      newItem['isFavorite'] = value;
      listFromSet.add(newItem);
      _allItems = listFromSet.toSet();
    }
    notifyListeners();
  }

  Future<void> toggleSelection(Map<String, dynamic> item, bool value) async {
    List<Map<String, dynamic>> listFromSet = _allItems.toList();
    final index = listFromSet.indexWhere((map) =>
        map['Racecourse'] == item['Racecourse'] &&
        map['Racecourse Type'] == item['Racecourse Type']);
    listFromSet[index]['isSelected'] = value;
    _allItems = listFromSet.toSet();

    notifyListeners();
  }

  Future<void> saveUserData(Set<Map<String, dynamic>> userData) async {
    toggleSwipeEnable(_savedItems.isNotEmpty ? true : false);
    await SharedPreferencesService.saveSetToPreferences(userData);
  }

  void saveSelectedRacecourseData(Map<String, dynamic> userData) {
    SharedPreferencesService.saveSelectedRaceCourseToPreferences(userData);
  }

  void setSelectedRacecource(String racecourse, String racecourseType) {
    var list = selectedItems.toList(); // Convert Set to List
    if (list.isEmpty) {
      _selectedRacecourse = {};
      return;
    }
    int index = list.indexWhere((map) =>
        map['Racecourse'] == racecourse &&
        map['Racecourse Type'] == racecourseType);

    if (index == -1) {
      index = 0;
    }
    _selectedRacecourse = list[index];
    SharedPreferencesService.saveSelectedRaceCourseToPreferences(
        _selectedRacecourse);
    notifyListeners();

  }

  Future<void> refreshSelectedRacecourse() async {
    try {
      final racecourseId = _selectedRacecourse['id'] ?? '';
      _selectedRacecourse =
          await _cloudFunctionsService.refreshRacecourseData(racecourseId);
      if (_selectedRacecourse['Name'].isEmpty) {
        _selectedRacecourse['Name'] = _selectedRacecourse['Racecourse'];
      }
      _selectedRacecourse['isSelected'] = true;
      final allItemsList = _allItems.toList();
      for (var i = 0; i < allItemsList.length; i++) {
        if (allItemsList[i]['id'] == racecourseId) {
          _selectedRacecourse['isFavorite'] =
              allItemsList[i]['isFavorite'] ?? false;
          allItemsList[i] = _selectedRacecourse;
          break;
        }
      }
      _allItems = allItemsList.toSet();
      final selectedItemsList =
          _savedItems.where((item) => item['isSelected'] == true).toList();
      for (var i = 0; i < selectedItemsList.length; i++) {
        if (selectedItemsList[i]['id'] == racecourseId) {
          selectedItemsList[i] = _selectedRacecourse;
          break;
        }
      }
      _savedItems = selectedItemsList.toSet();

      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  Future<void> fetchSelectedRacecourse() async {
    final selectedRaceCourse =
        await SharedPreferencesService.getSelectedRacecourseFromPreferences();
    setSelectedRacecource(
        selectedRaceCourse['Racecourse'] ?? '',
        selectedRaceCourse['Racecourse Type'] ?? '');
  }

  Future<void> fetchSelectedItems() async {
    Set<Map<String, dynamic>> loadselectedItems = {};
    loadselectedItems = await SharedPreferencesService.getSetFromPreferences();
    loadSelectedItems(loadselectedItems);
  }
}
