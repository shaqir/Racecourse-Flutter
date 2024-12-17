import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/utility/apputils.dart';

class LengthStatusContainer extends StatelessWidget {
  final String statusString;
  final String colorCode;

  const LengthStatusContainer({
    required this.statusString,
    required this.colorCode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 4,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Apputils().hexToColor(colorCode).withOpacity(0.75),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Align(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                statusString,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SourceSansVariable',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
