import 'package:flutter/material.dart';
import 'package:racecourse_tracks/utils/apputils.dart';

class LengthStatusContainer extends StatelessWidget {
  final String statusString;
  final String colorCode;

  const LengthStatusContainer({
    required this.statusString,
    required this.colorCode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 3,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 2, 2, 2),
        decoration: BoxDecoration(
          color: Apputils().hexToColor(colorCode).withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Align(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              statusString,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 13,
                fontWeight: FontWeight.w400,
                fontFamily: 'SourceSansVariable',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
