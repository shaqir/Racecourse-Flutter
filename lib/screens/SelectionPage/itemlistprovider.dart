import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:racecourse_tracks/core/utility/sharedpreferenceshelper.dart';
import 'package:collection/collection.dart';

class ItemListProvider extends ChangeNotifier {
  Set<Map<String, dynamic>> _allItems = {};
  Set<Map<String, dynamic>> _savedItems = {};
  bool _clearButtonEnabled = false;
  bool _isSwipeEnabled = false;
  Map<String, dynamic> _selectedRacecourse = {};

  Set<Map<String, dynamic>> get allItems => _allItems;
  Set<Map<String, dynamic>> get savedItems => _savedItems;
  Set<Map<String, dynamic>> get selectedItems =>
      _allItems.where((item) => item['isSelected'] == true).toSet();
  bool get clearButtonEnabled => _clearButtonEnabled;
  bool get isSwipeEnabled => _isSwipeEnabled;
  Map<String, dynamic> get selectedRacecourse => _selectedRacecourse;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Method to load selected items from SharedPreferences
  Future<void> loadSelectedItems(Set<Map<String, dynamic>>? items) async {
    if (kDebugMode) {
      print(allItems.length);
    }

    if (items!.isNotEmpty) {
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

  // Future<void> loadSelectedItems() async {
  //   Set<Map<String, dynamic>>? loadedSelectedItems = Set();
  //   loadedSelectedItems = await SharedPreferencesHelper.getSetFromPreferences();

  //   if (loadedSelectedItems.isNotEmpty) {
  //     // _selectedItems = {};

  //     for (var allItem in _allItems) {
  //       for (var loadedItem in loadedSelectedItems) {
  //         if (loadedItem['Racecourse'] == allItem['Racecourse'] &&
  //             loadedItem['Racecourse Type'] == allItem['Racecourse Type']) {
  //           _selectedItems.remove(allItem);
  //           _selectedItems.removeWhere((map) =>
  //               map['Racecourse'] == allItem["Racecourse"] &&
  //               map['Racecourse Type'] == allItem["Racecourse Type"]);

  //           allItem['isSelected'] = loadedItem['isSelected'];
  //           allItem['isFavorite'] = loadedItem['isFavorite'];
  //           _selectedItems.add(allItem);
  //         }
  //       }
  //     }
  //   }

  //   setDefaultSelected(); // Call to update UI if needed
  // }

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
    if (kDebugMode) {
      print("KLATEST : ${_savedItems.length}");
    }
    if (_savedItems.isEmpty) {
      _isSwipeEnabled = false;
    } else {
      _isSwipeEnabled = true;
    }
    // Convert _allItems set to a list and loop through _selectedItems
    for (var element in _savedItems) {
      //print('element: $element');

      // Use a custom comparison function instead of contains

      // Use custom comparison and ignore 'isSelected' field
      if (_allItems.any((item) => areMapsEqualIgnoringField(
          item, element, 'isSelected', 'isFavorite'))) {
        int indexofelement = listFromSet2.indexWhere((item) =>
            areMapsEqualIgnoringField(
                item, element, 'isSelected', 'isFavorite'));
        if (kDebugMode) {
          print(element['Name']);
        }
        // Mark the element as selected (update the map with the 'isSelected' field)
        listFromSet2[indexofelement]['isSelected'] = element['isSelected'];
        listFromSet2[indexofelement]['isFavorite'] = element['isFavorite'];
      } else {
        if (kDebugMode) {
          print('Maps are not equal');
        }
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
    if (kDebugMode) {
      print("_isSwipeEnabled set to: $value");
    }
    _isSwipeEnabled = value;
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
    if (kDebugMode) {
      print("selectedItems length AFTER: ${_savedItems.length}");
    }
    saveUserData(_savedItems);
    if(value == false && _selectedRacecourse['Racecourse'] == item['Racecourse'] &&
        _selectedRacecourse['Racecourse Type'] == item['Racecourse Type']){
      _selectedRacecourse = _savedItems.first;
      SharedPreferencesHelper.saveSelectedRaceCourseToPreferences(
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
    // } else {
    //   _selectedItems.remove(item);
    //   _selectedItems.removeWhere((map) =>
    //       map['Racecourse'] == item["Racecourse"] &&
    //       map['Racecourse Type'] == item["Racecourse Type"]);
    //   Map<String, dynamic> updatedItem = Map.from(item);
    //   updatedItem['isFavorite'] = value;
    //   _selectedItems.add(updatedItem);
    //   // _selectedItems.remove(item);
    //   // _selectedItems.removeWhere((map) =>
    //   //     map['Racecourse'] == item["Racecourse"] &&
    //   //     map['Racecourse Type'] == item["Racecourse Type"]);
    // }
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

  // void toggleSelection(int index, bool value) {
  //   List<Map<String, dynamic>> listFromSet = _allItems.toList();
  //   listFromSet[index]['isSelected'] = value;
  //   _allItems = listFromSet.toSet();
  //   notifyListeners(); // Notify listeners about the state change
  // }

  Future<void> toggleSelection(Map<String, dynamic> item, bool value) async {
    List<Map<String, dynamic>> listFromSet = _allItems.toList();
    if (listFromSet.contains(item)) {
      listFromSet.remove(item);
      Map<String, dynamic> updatedItem = Map.from(item);
      updatedItem['isSelected'] = value;
      listFromSet.add(updatedItem);
      _allItems = listFromSet.toSet();
    } else {
      Map<String, dynamic> newItem = Map.from(item);
      newItem['isSelected'] = value;
      listFromSet.add(newItem);
      _allItems = listFromSet.toSet();
    }
    notifyListeners();
  }

  Future<void> saveUserData(Set<Map<String, dynamic>> userData) async {
    toggleSwipeEnable(_savedItems.isNotEmpty ? true : false);
    await SharedPreferencesHelper.saveSetToPreferences(userData);
  }

  void saveSelectedRacecourseData(Map<String, dynamic> userData) {
    SharedPreferencesHelper.saveSelectedRaceCourseToPreferences(userData);
  }

  void setSelectedRacecource(String racecourse, String racecourseType) {
    var list = _savedItems.toList(); // Convert Set to List
    if (kDebugMode) {
      print('racecourse=> $racecourse');
      print('racecourseType=> $racecourseType');
    }
    
    int index = list.indexWhere((map) =>
        map['Racecourse'] == racecourse &&
        map['Racecourse Type'] == racecourseType);
    if (kDebugMode) {
      print('_index: $index');
    }

    if (index == -1) {
      index = 0;
    }
    _selectedRacecourse = list[index];
    SharedPreferencesHelper.saveSelectedRaceCourseToPreferences(
        _selectedRacecourse);
    notifyListeners();

    if (kDebugMode) {
      print('_selectedRacecourse ===> $_selectedRacecourse');
    }
  }

  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final rowNumber = _selectedRacecourse['rowIndex'];

      final refreshWeatherDataScriptUrl =
          'https://checkbox-1092072715142.asia-east2.run.app';

      final dio = Dio();
      final response =
          await dio.get(refreshWeatherDataScriptUrl, queryParameters: {
        'rowNumbers': rowNumber,
      });
      final refreshedItem = (jsonDecode(response.data) as List).first;
      if (refreshedItem['Name'].isEmpty) {
        refreshedItem['Name'] = refreshedItem['Racecourse'];
      }
      if (kDebugMode) {
        print('refreshedItem name: ${refreshedItem['Name']}');
      }
      refreshedItem['isSelected'] = true;
      refreshedItem['rowIndex'] = rowNumber;
      final allItemsList = _allItems.toList();
      for (var i = 0; i < allItemsList.length; i++) {
        if (allItemsList[i]['rowIndex'] == rowNumber) {
          refreshedItem['isFavorite'] = allItemsList[i]['isFavorite'] ?? false;
          allItemsList[i] = refreshedItem;
          break;
        }
      }
      _allItems = allItemsList.toSet();
      final selectedItemsList =
          _savedItems.where((item) => item['isSelected'] == true).toList();
      for (var i = 0; i < selectedItemsList.length; i++) {
        if (selectedItemsList[i]['rowIndex'] == rowNumber) {
          selectedItemsList[i] = refreshedItem;
          break;
        }
      }
      _savedItems = selectedItemsList.toSet();

      // Notify the user (optional)
      if (kDebugMode) {
        print('Data refreshed successfully!');
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing data: $e');
      }
      _isLoading = false;
      notifyListeners();
    }
  }
}
