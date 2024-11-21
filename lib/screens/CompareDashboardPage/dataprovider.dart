import 'package:flutter/material.dart';

class DataProvider extends InheritedWidget {
  String? selectedRacecourse;
  final Function(String) updateValue;

  DataProvider({
    required this.selectedRacecourse,
    required this.updateValue,
    required Widget child,
  }) : super(child: child);

  static DataProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataProvider>()!;
  }

  @override
  bool updateShouldNotify(DataProvider oldWidget) {
    // Rebuild dependent widgets only if the list has changed
    return oldWidget.selectedRacecourse != selectedRacecourse;
  }
}