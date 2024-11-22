import 'dart:async';

import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';

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
    _filterUsers();
  }

  void _filterUsers() {
    setState(() {
      _useritems = widget.users
          .where(
              (user) => user['Racecourse Type'] == currentRaceCourseTypeChoice)
          .map((user) => user['Racecourse'].toString())
          .toList();

      currentRaceCourseChoice = _useritems.isNotEmpty ? _useritems[0] : null;
      Timer(Duration(seconds: 1), () {
        if (currentRaceCourseChoice != null) {
          widget.onUserSelected(currentRaceCourseChoice ?? '',
              currentRaceCourseTypeChoice ?? ''); // Notify parent
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDarkBlueColor,
      height: 200,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DropdownButton<String>(
                value: currentRaceCourseTypeChoice,
                alignment: Alignment.center,
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
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SourceSansVariable',
                        )),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DropdownButton<String>(
                value: currentRaceCourseChoice,
                alignment: Alignment.center,
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
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SourceSansVariable',
                        )),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
