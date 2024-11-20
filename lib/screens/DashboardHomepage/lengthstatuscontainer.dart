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
    // print(lengthStatus?.name);

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
        return const Color(0xffff0000);
      case LengthStatus.veryshort:
        return const Color(0xff980000);  
      case LengthStatus.medium:
        return const Color(0xffffff00);
      case LengthStatus.shortmedium:
        return const Color(0xffffbf00);
      case LengthStatus.longmedium:
        return const Color(0xff06b050);
      case LengthStatus.long:
        return const Color(0xff06b0f0);
      case LengthStatus.mediumlong:
        return const Color(0xff92d051);
      case LengthStatus.extralong:
        return const Color(0xff06b0f0);
      default:
        return Colors.grey; // Default color
    }
  }
   
}
