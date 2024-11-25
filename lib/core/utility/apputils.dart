import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appmenubuttontitles.dart';

class Apputils {

 // Private constructor to prevent direct instantiation
  Apputils._privateConstructor();

  // The single instance of the class
  static final Apputils _instance = Apputils._privateConstructor();

  // Factory constructor to return the same instance
  factory Apputils() {
    return _instance;
  }
 
// A function to format text into title case
String toTitleCase(String text) {
  if (text.isEmpty) return text;
  return text
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(' ');
}

// Function to get color based on string
  Color getColor(String colorName) {
    switch (colorName) {
      case AppMenuButtonTitles.gallops_field:
        return AppColors.gallopsCheckboxColor;
      case AppMenuButtonTitles.harness_field:
        return AppColors.harnessCheckboxColor;
      case AppMenuButtonTitles.dogs_field:
        return AppColors.dogsCheckboxColor;
      default:
        return AppColors.gallopsCheckboxColor; // Default color if the string doesn't match
    }
  }

// A function to format a date as a readable string
String formatDate(DateTime date) {
  return "${date.day}/${date.month}/${date.year}";
}

// A function to calculate the sum of a list of integers
int sum(List<int> numbers) {
  return numbers.reduce((a, b) => a + b);
}
}
