import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding and decoding

class ItemListProvider extends ChangeNotifier {
  Set<Map<String, dynamic>> _allItems = {};
  Set<Map<String, dynamic>> _selectedItems = {};
  bool _clearButtonEnabled = false;

  Set<Map<String, dynamic>> get allItems => _allItems;
  Set<Map<String, dynamic>> get selectedItems => _selectedItems;
  bool get clearButtonEnabled => _clearButtonEnabled;

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

  // Method to store selected items in SharedPreferences
  // Future<void> saveSelectedItems() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> selectedList =
  //       _selectedItems.map((item) => jsonEncode(item)).toList();
  //   await prefs.setStringList('selectedItems', selectedList);
  // }

  Future<void> saveSelectedItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Set<String> jsonSet = _selectedItems.map((map) {
      // Handle Timestamp in maps (if exists)
      map.forEach((key, value) {
        if (value is Timestamp) {
          // Convert Timestamp to ISO8601 string
          map[key] = value.toDate().toIso8601String();
        }
      });
      return json.encode(map); // Convert map to JSON string
    }).toSet();
    // _selectedItems.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('selectedItems', jsonSet.toList());
  }

  // Method to load selected items from SharedPreferences
  Future<void> loadSelectedItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? selectedList = prefs.getStringList('selectedItems');
    if (selectedList != null) {
      _selectedItems = selectedList
          .map((item) => jsonDecode(item)
              as Map<String, dynamic>) // Cast to Map<String, dynamic>
          .toSet(); // Decode JSON
      final firstItem = jsonDecode(selectedList[0]) as Map<String, dynamic>;
      final isSelectedValue = firstItem["isSelected"];

      if (isSelectedValue is bool) {
        print("LOAD : $isSelectedValue");
      }
      notifyListeners();
    }
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

  void setDefaultSelected() {
    List<Map<String, dynamic>> listFromSet2 = _allItems.toList();
    print("KLATEST : ${_selectedItems.length}");
    for (var element in _selectedItems) {
      if (_allItems.contains(element)) {
        int indexofelement = listFromSet2.indexOf(element);
        print('$element exists in both lists');
        listFromSet2[indexofelement]['isSelected'] = true;
      }
    }
    notifyListeners();
  }

  void toggleClearSelection(bool value) {
    _clearButtonEnabled = value;
    notifyListeners();
  }

  void updateSelectedList(Map<String, dynamic> item, bool value) {
    if (value) {
      _selectedItems.add(item);
      saveSelectedItems();
    } else {
      _selectedItems.remove(item);
    }
    notifyListeners(); // Notify listeners about the state change
  }

  void toggleSelection(int index, bool value) {
    List<Map<String, dynamic>> listFromSet = _allItems.toList();
    listFromSet[index]['isSelected'] = value;
    _allItems = listFromSet.toSet();
    notifyListeners(); // Notify listeners about the state change
  }
}
