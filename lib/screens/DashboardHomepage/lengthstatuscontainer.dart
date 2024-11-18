import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/appconstants.dart';

class LengthStatusContainer extends StatelessWidget {
  final String statusString;

  const LengthStatusContainer({required this.statusString, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Map the string to the corresponding enum value
    LengthStatus? lengthStatus = _stringToStatus(statusString);
    // print(statusString);
    // print(lengthStatus?.name);
    // print(lengthStatus?.toString());

    return Flexible(
      flex: 4,
      child: Container(
        color: lengthStatus?.color ?? Colors.grey,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            statusString,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to convert string to enum
  LengthStatus? _stringToStatus(String value) {
    switch (value) {
      case "Very Short":
        return LengthStatus.veryshort;
      case "Short":
        return LengthStatus.short;
      case "Medium":
        return LengthStatus.medium;
      case "Short Medium":
        return LengthStatus.shortmedium;
      case "Long Medium":
        return LengthStatus.longmedium;
      case "Long":
        return LengthStatus.long;
      case "Extra Long":
        return LengthStatus.extralong;
      default:
        return LengthStatus.none;
    }
  }
}

// Extension to map enum values to colors
extension StatusColor on LengthStatus {
  Color get color {
    switch (this) {
      case LengthStatus.short:
        return Colors.green;
      case LengthStatus.shortmedium:
        return Colors.red;
      case LengthStatus.long:
        return Colors.orange;
      case LengthStatus.medium:
        return Colors.blue;
      case LengthStatus.extralong:
        return Colors.purple;
      case LengthStatus.veryshort:
        return Colors.cyan;
      default:
        return Colors.grey; // Default color
    }
  }
}
