import 'package:flutter/material.dart';
import 'package:racecourse_tracks/ui/core/theme/appcolors.dart';

class CompareDashboardBox extends StatelessWidget {
  final Function(String racecourse)
      onRacecourseSelected;
  final Function(String racecourseType)
      onRacecourseTypeSelected;

  final String currentRaceCourseChoice;
  final String currentRaceCourseTypeChoice;
  final List<String> allRacecourses;
  const CompareDashboardBox({
    super.key,
    required this.onRacecourseSelected,
    required this.onRacecourseTypeSelected,
    required this.currentRaceCourseChoice,
    required this.currentRaceCourseTypeChoice,
    required this.allRacecourses,
  });
  static const menuitems = [
    'Gallops',
    'Harness',
    'Dogs',
  ];

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
        children: [
          Spacer(),
          IntrinsicWidth(
            child: Container(
              height: 50,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.dropdownButtonColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    width: 1, color: AppColors.lightGrayBackgroundColor),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: currentRaceCourseTypeChoice,
                dropdownColor: Colors.white,
                onChanged: (String? newValue) {
                  onRacecourseTypeSelected(newValue ?? '');
                },
                items: menuitems.map((String value) {
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
          SizedBox(width: 8),
          IntrinsicWidth(
            child: Container(
              height: 50,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.dropdownButtonColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    width: 1, color: AppColors.lightGrayBackgroundColor),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: currentRaceCourseChoice,
                dropdownColor: Colors.white,
                onChanged: (String? newValue) {
                  onRacecourseSelected(newValue ?? '');
                },
                items: allRacecourses
                    .map((String value) {
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
      )),
    );
  }
}