import 'package:flutter/material.dart';

class ItemListProvider extends ChangeNotifier {

  Set<Map<String, dynamic>> _allItems = {};
  Set<Map<String, dynamic>> _selectedItems = {};
  bool _clearButtonEnabled = false;

  Set<Map<String, dynamic>> get allItems => _allItems;
  Set<Map<String, dynamic>> get selectedItems => _selectedItems;
  bool get clearButtonEnabled => _clearButtonEnabled;
 
  void setAllItems(Set<Map<String, dynamic>> items) {
    _allItems = items;
    notifyListeners(); // Notify listeners about the new data
  }
  // Method to reset all items to false
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
    if(value){
      _selectedItems.add(item);
    }
    else{
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