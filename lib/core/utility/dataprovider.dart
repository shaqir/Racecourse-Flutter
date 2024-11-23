import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DataProvider extends InheritedWidget {
  String? selectedRacecourse;
  String? selectedRacecourseType;
  final Function(String, String) updateValue;

  DataProvider({
    required this.selectedRacecourse,
    required this.selectedRacecourseType,
    required this.updateValue,
    required Widget child,
  }) : super(child: child);

  static DataProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataProvider>()!;
  }

  @override
  bool updateShouldNotify(DataProvider oldWidget) {
    // Rebuild dependent widgets only if either value has changed
    return oldWidget.selectedRacecourse != selectedRacecourse ||
        oldWidget.selectedRacecourseType != selectedRacecourseType;
  }
}
