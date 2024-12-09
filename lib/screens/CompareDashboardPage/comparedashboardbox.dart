import 'dart:async';

import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/utility/apputils.dart';

class CompareDashboardBox extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final Function(String selectedRacecourse, String selectedRacecourseType)
      onUserSelected; // Add callback

  CompareDashboardBox({
    super.key,
    required this.users,
    required this.onUserSelected,
  });

  @override
  _CompareDashboardBoxState createState() => _CompareDashboardBoxState();
}

class _CompareDashboardBoxState extends State<CompareDashboardBox> {
  final List<String> _menuitems = [
    'Gallops',
    'Dogs',
    'Harness',
  ];
  List<String> _useritems = [];
  String? currentRaceCourseTypeChoice;
  String? currentRaceCourseChoice;

  @override
  void initState() {
    currentRaceCourseTypeChoice = _menuitems[0];
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _filterUsers();
    });
  }

  void _filterUsers() {
    setState(() {
      _useritems = widget.users
          .where(
              (user) => user['Racecourse Type'] == currentRaceCourseTypeChoice)
          .map((user) => user['Racecourse'].toString())
          .toList();

      _useritems.sort((a, b) => a.compareTo(b));

      // Sort alphabetically by the "Racecourse" key
      currentRaceCourseChoice = _useritems.isNotEmpty ? _useritems[0] : null;
      // Timer(Duration(seconds: 1), () {
      if (currentRaceCourseChoice != null) {
        widget.onUserSelected(currentRaceCourseChoice ?? '',
            currentRaceCourseTypeChoice ?? ''); // Notify parent
      }
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.checkboxlist2Color,
        borderRadius: BorderRadius.circular(25),
      ),
      height: 80,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Container(
              height: 50,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.rectangleBoxColor, // Background color
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    width: 1, //
                    color: AppColors.lightGrayBackgroundColor),
              ),
              child: Center(
                child: DropdownButton<String>(
                  value: currentRaceCourseTypeChoice,
                  alignment: Alignment.bottomCenter,
                  dropdownColor: Colors.white,
                  elevation: 10,
                  onChanged: (String? newValue) {
                    setState(() {
                      currentRaceCourseTypeChoice = newValue;
                      _filterUsers();
                    });
                  },
                  items: _menuitems.map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceSansVariable',
                          )),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 50,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.rectangleBoxColor, // Background color
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    width: 1, //
                    color: AppColors.lightGrayBackgroundColor),
              ),
              child: Center(
                child: DropdownButton<String>(
                  value: currentRaceCourseChoice,
                  alignment: Alignment.bottomCenter,
                  dropdownColor: Colors.white,
                  elevation: 0,
                  onChanged: (String? newValue) {
                    setState(() {
                      currentRaceCourseChoice = newValue;
                      if (newValue != null) {
                        widget.onUserSelected(newValue,
                            currentRaceCourseTypeChoice ?? ''); // Notify parent
                      }
                    });
                  },
                  items: _useritems.map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceSansVariable',
                          )),
                    );
                  }).toList(),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
