import 'package:flutter/material.dart';

class LengthStatusContainer extends StatelessWidget {
  final String statusString;
  final String colorCode;

  const LengthStatusContainer({
    required this.statusString,
    required this.colorCode,
    Key? key,
  }) : super(key: key);

  Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceFirst('#', '0xff'); // Replace # with 0xff
    return Color(int.parse(hexColor)); // Parse as an integer
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 4,
      child: Container(
        decoration: BoxDecoration(
          color: hexToColor(colorCode),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            statusString,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'SourceSansVariable',
            ),
          ),
        ),
      ),
    );
  }
}
