import 'package:flutter/material.dart';
import 'package:racecourse_tracks/ui/core/theme/appcolors.dart';
import 'package:racecourse_tracks/config/appmenubuttontitles.dart';

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

  String removeTrailingSpace(String input) {
    if (input.isNotEmpty && input.endsWith(' ')) {
      return input.substring(
          0, input.length - 1); // Remove the last character if it's a space
    }
    return input; // Return the string as is if no trailing space
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
    } catch (_) {
      return Color(0xFF000000); // Default to black
    }
  }

// Function to get color based on string
  Color getColor(String colorName) {
    switch (colorName) {
      case AppMenuButtonTitles.gallopsField:
        return AppColors.gallopsCheckboxColor.withValues(alpha: 0.75);
      case AppMenuButtonTitles.harnessField:
        return AppColors.harnessCheckboxColor.withValues(alpha: 0.75);
      case AppMenuButtonTitles.dogsField:
        return const Color.fromARGB(255, 136, 1, 1).withValues(alpha: 0.75);
      default:
        return AppColors.gallopsCheckboxColor
            .withValues(alpha: 0.75); // Default color if the string doesn't match
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
