import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/utility/sharedpreferenceshelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding and decoding

class ItemListProvider extends ChangeNotifier {
  Set<Map<String, dynamic>> _allItems = {};
  Set<Map<String, dynamic>> _selectedItems = {};
  bool _clearButtonEnabled = false;
  bool _isSwipeEnabled = false;

  Set<Map<String, dynamic>> get allItems => _allItems;
  Set<Map<String, dynamic>> get selectedItems => _selectedItems;
  bool get clearButtonEnabled => _clearButtonEnabled;
  bool get isSwipeEnabled => _isSwipeEnabled;

  // Method to store all items in SharedPreferences
  Future<void> saveAllItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> itemsList =
        _allItems.map((item) => jsonEncode(item)).toList(); // Encode as JSON
    await prefs.setStringList('allItems', itemsList);
  }

  // Method to load all items from SharedPreferences
  Future<void> loadAllItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? itemsList = prefs.getStringList('allItems');
    if (itemsList != null) {
      _allItems = itemsList
          .map((item) => jsonDecode(item)
              as Map<String, dynamic>) // Cast to Map<String, dynamic>
          .toSet(); // Decode from JSON
      notifyListeners();
    }
  }

  // Method to load selected items from SharedPreferences
  Future<void> loadSelectedItems(Set<Map<String, dynamic>>? items) async {
    if (items != null && items.length > 0) {
      _selectedItems = items;
    }
    //  notifyListeners();
    setDefaultSelected();
  }

  void setAllItems(Set<Map<String, dynamic>> items) {
    _allItems = items;
    notifyListeners(); // Notify listeners about the new data
  }

  void resetAll() {
    for (var item in _allItems) {
      item['isSelected'] = false;
    }
    notifyListeners();
  }

  void resetSelectedItems() {
    _selectedItems.clear();
    notifyListeners();
  }

  // void setDefaultSelected() {
  //   List<Map<String, dynamic>> listFromSet2 = _allItems.toList();
  //   print("KLATEST : ${_selectedItems.length}");
  //   for (var element in _selectedItems) {
  //     print('element: $element');
  //     if (_allItems.contains(element)) {
  //       int indexofelement = listFromSet2.indexOf(element);
  //       print('$element exists in both lists');
  //       listFromSet2[indexofelement]['isSelected'] = true;
  //     }
  //   }
  //   notifyListeners();
  // }

  void setDefaultSelected() {
  List<Map<String, dynamic>> listFromSet2 = _allItems.toList();
  print("KLATEST : ${_selectedItems.length}");
  if(_selectedItems.isEmpty){
    _isSwipeEnabled = false;
  }
  else{
    _isSwipeEnabled = true;
  }
  // Convert _allItems set to a list and loop through _selectedItems
  for (var element in _selectedItems) {
    //print('element: $element');
    
    // Use a custom comparison function instead of contains
    
    // Use custom comparison and ignore 'isSelected' field
    if (_allItems.any((item) => areMapsEqualIgnoringField(item, element, 'isSelected'))) {
      int indexofelement = listFromSet2.indexWhere((item) => areMapsEqualIgnoringField(item, element, 'isSelected'));
      print('$element exists in both lists');
      // Mark the element as selected (update the map with the 'isSelected' field)
      listFromSet2[indexofelement]['isSelected'] = true;
    }
    else{
      print('Maps are not equal');
    }
  }
  notifyListeners();
}

// Custom comparison that ignores the 'isSelected' field
bool areMapsEqualIgnoringField(Map<String, dynamic> map1, Map<String, dynamic> map2, String ignoreField) {
  // Create copies of the maps without the field to ignore
  Map<String, dynamic> filteredMap1 = Map.from(map1)..remove(ignoreField);
  Map<String, dynamic> filteredMap2 = Map.from(map2)..remove(ignoreField);

  // Compare the filtered maps using mapEquals
  return mapEquals(filteredMap1, filteredMap2);
}


bool areMapsEqual(Map<String, dynamic> map1, Map<String, dynamic> map2) {
  // Compare map keys and values (ignoring the 'isSelected' field)
  return map1.keys.every((key) => map2.containsKey(key) && map1[key] == map2[key]);
}

  void toggleClearSelection(bool value) {
    _clearButtonEnabled = value;
    saveUserData(_selectedItems);
    notifyListeners(); 
  }
   void toggleSwipeEnable(bool value) {
     print("_isSwipeEnabled set to: ${value}");
    _isSwipeEnabled = value;
    notifyListeners(); 
  }

  void updateSelectedList(Map<String, dynamic> item, bool value) {
     print("value:${value}");
     print("selectedItems length BEFORE: ${_selectedItems.length}");
    if (value) {
      _selectedItems.add(item);
      print("ADDED");
    } else {
      _selectedItems.remove(item);
      // Remove elements where 'id' == 2 and 'name' == 'Bob'
     _selectedItems.removeWhere((map) => map['Racecourse'] == item["Racecourse"] && map['Racecourse Type'] == item["Racecourse Type"]);
      print("REMOVED");
      print("selectedItems length AFTER: ${_selectedItems.length}");

    }
    saveUserData(_selectedItems);
    notifyListeners(); // Notify listeners about the state change
  }

  void toggleSelection(int index, bool value) {
    List<Map<String, dynamic>> listFromSet = _allItems.toList();
    listFromSet[index]['isSelected'] = value;
    _allItems = listFromSet.toSet();
    notifyListeners(); // Notify listeners about the state change
  }

  void saveUserData(Set<Map<String, dynamic>> userData) {
    toggleSwipeEnable(_selectedItems.isNotEmpty ? true : false); 
    SharedPreferencesHelper.saveSetToPreferences(userData);
  }
}
