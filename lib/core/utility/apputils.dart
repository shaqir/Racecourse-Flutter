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

  Color hexToColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      // Default to black if the input is null or empty
      return Color(0xFF000000);
    }
    hexColor = hexColor.replaceFirst('#', '0xff'); // Replace # with 0xff
    try {
      if (hexColor.length == 6) {
        return Color(int.parse("0xff$hexColor"));
      } else if (hexColor.length == 8) {
        return Color(int.parse("0x$hexColor"));
      } else {
        return Color(int.parse(hexColor));
      }
      //  // Parse as an integer
    } catch (e) {
      // Handle invalid input gracefully
      print("Invalid hexColor: $hexColor");
      return Color(0xFF000000); // Default to black
    }
  }

// Function to get color based on string
  Color getColor(String colorName) {
    switch (colorName) {
      case AppMenuButtonTitles.gallops_field:
        return AppColors.gallopsCheckboxColor.withOpacity(0.75);
      case AppMenuButtonTitles.harness_field:
        return AppColors.harnessCheckboxColor.withOpacity(0.75);
      case AppMenuButtonTitles.dogs_field:
        return const Color.fromARGB(255, 169, 2, 2).withOpacity(0.75);
      default:
        return AppColors.gallopsCheckboxColor
            .withOpacity(0.75); // Default color if the string doesn't match
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
