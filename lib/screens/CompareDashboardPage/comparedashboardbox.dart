import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/appcolors.dart';

class CompareDashboardBox extends StatefulWidget {
  const CompareDashboardBox({super.key});

  @override
  _CompareDashboardBoxState createState() => _CompareDashboardBoxState();
}

class _CompareDashboardBoxState extends State<CompareDashboardBox> {
  final List<String> _menuitems = [
    'Gallops',
    'Dogs',
    'Harness',
  ]; // List of options
  final List<String> _useritems = [
    'user1',
    'user2',
    'user3',
    'user4',
    'user5',
    'user6',
    'user7',
    'user8',
    'user9'
  ]; // List of options
  String? currentRaceCourseTypeChoice;
  String? currentRaceCourseChoice;

  @override
  void initState() {
    currentRaceCourseTypeChoice = _menuitems[0];
    currentRaceCourseChoice = _useritems[0];
    super.initState();
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
            Container(
              width: 100,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    width: 0.5, //
                    color: AppColors.tablecontentBgColor),
              ),
              child: DropdownButton<String>(
                value: currentRaceCourseTypeChoice, // Currently selected value
                hint: const Center(
                    child: Text(
                  '',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Custom hint text style
                  ),
                )),
                onChanged: (String? newValue) {
                  setState(() {
                    currentRaceCourseTypeChoice =
                        newValue; // Update selected value
                  });
                },
                items: _menuitems.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.white, // Custom item text style
                ),
              ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 150,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    width: 0.5, //
                    color: AppColors.tablecontentBgColor),
              ),
              child: DropdownButton<String>(
                value: currentRaceCourseChoice, // Currently selected value
                hint: const Text(''),
                onChanged: (String? newValue) {
                  setState(() {
                    currentRaceCourseChoice = newValue; // Update selected value
                  });
                },
                items: _useritems.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
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
