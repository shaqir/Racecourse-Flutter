import 'dart:async';

import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/common/appmenubuttontitles.dart';

class SelectedRacecourseList extends StatefulWidget {
  final Function(String selectedRacecourse, String selectedRacecourseType)
      onUserSelected; // Add callback
  final Set<Map<String, dynamic>> selectedItems;

  const SelectedRacecourseList({
    super.key,
    required this.selectedItems,
    required this.onUserSelected,
  });

  @override
  State<SelectedRacecourseList> createState() => _SelectedRacecourseListState();
}

class _SelectedRacecourseListState extends State<SelectedRacecourseList> {
  String title = "";
  String Selected = "";

  List checkListItems = [
    {
      "id": 0,
      "value": true,
      "title": "Ascot",
    },
    {
      "id": 1,
      "value": false,
      "title": "Darwin",
    },
    {
      "id": 2,
      "value": false,
      "title": "Albany",
    },
    {
      "id": 3,
      "value": false,
      "title": "Gundagai",
    },
    {
      "id": 4,
      "value": false,
      "title": "Toowoomba",
    },
    {
      "id": 5,
      "value": false,
      "title": "Hi",
    },
    {
      "id": 6,
      "value": false,
      "title": "SunShine Coast",
    },
    {
      "id": 7,
      "value": false,
      "title": "Dunkeld",
    },
    {
      "id": 8,
      "value": false,
      "title": "Kembla Grange",
    },
    {
      "id": 9,
      "value": false,
      "title": "short",
    },
    {
      "id": 10,
      "value": false,
      "title": "Hii NewCastle",
    },
    {
      "id": 11,
      "value": false,
      "title": "Morphetville",
    },
    {
      "id": 12,
      "value": false,
      "title": "Bathrust",
    },
    {
      "id": 13,
      "value": false,
      "title": "Test this name Ipswitch",
    },
    {
      "id": 14,
      "value": false,
      "title": "Very long name the RicartonPark",
    },
  ];

  // Track the selected button index (initially none is selected)
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    title = 'RaceCourse';
    Timer(Duration(seconds: 1), () {
      widget.onUserSelected(
        widget.selectedItems.toList()[_selectedIndex]["Racecourse"] ?? '',
        widget.selectedItems.toList()[_selectedIndex]["Racecourse Type"] ?? '',
      );
    });
  }

  /*
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 225,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //createExpandedWidget(5, 0),
          //createExpandedWidget(5, 5),
          //createExpandedWidget(5, 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select an option:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ToggleButtons(
                onPressed: (int index) {
                  setState(() {
                    // Deselect all other buttons
                    for (int i = 0; i < _isSelected.length; i++) {
                      _isSelected[i] = false;
                    }
                    // Select the tapped button
                    _isSelected[index] = true;
                  });
                },
                isSelected: _isSelected,
                children: List.generate(
                  5,
                  (index) {
                    int value1 = 0 + index;
                    return createRaceCourseButton(value1);
                  },
                ),
                // Customizations
                color: Colors.blue, // Unselected text color
                selectedColor: Colors.white, // Selected text color
                fillColor: Colors.blue, // Background color when selected
                borderColor: Colors.grey, // Border color
                selectedBorderColor: Colors.blue, // Border color when selected
                borderRadius: BorderRadius.circular(8), // Rounded corners
                borderWidth: 2, // Border width
                constraints: BoxConstraints(
                  minWidth: 100, // Minimum width of buttons
                  minHeight: 50, // Minimum height of buttons
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Selected: ${_isSelected.indexOf(true) != -1 ? "Option ${_isSelected.indexOf(true) + 1}" : "None"}',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ],
          )
        ],
      ),
    );
  }
  */

  Widget build(BuildContext context) {
    List<Map<String, dynamic>> selectedItemList = widget.selectedItems.toList();
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(8),
          
          child: Column(children: [
            SizedBox(height: 8),
            Column(
              children: [
                Wrap(
                  spacing: 8.0, // Horizontal spacingR
                  runSpacing: 4.0, // Vertical spacing
                  children: List.generate(selectedItemList.length, (index) {
                    return ChoiceChip(
                      label: Text(
                        selectedItemList[index]['Racecourse'] ?? 'Unknown',
                        style: TextStyle(
                          color: _selectedIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          fontFamily: AppFonts.myCutsomeSourceSansFont,
                        ),
                      ),
                      side: BorderSide(
                        color: _selectedIndex == index
                            ? AppColors.primaryDarkBlueColor
                            : AppColors.checkboxlist3Color,
                        width: 1,
                      ),
                      selected: _selectedIndex == index,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedIndex = (selected
                              ? index
                              : null)!; // Allow nullable index
                        });

                        widget.onUserSelected(
                          selectedItemList[index]["Racecourse"] ?? '',
                          selectedItemList[index]["Racecourse Type"] ?? '',
                        );
                      },
                      selectedColor: AppColors.selectedDarkBrownColor,
                      backgroundColor: AppColors.primaryLightBgColor,
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 8),
          ]),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.tablecontentBgColor, // Background color
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
                width: 1, //
                color: AppColors.checkboxlist2Color),
          ),
          child: SizedBox(
            height: 40,
            width: double.infinity,
            child: Center(
              child: Text('${selectedItemList[_selectedIndex]['Racecourse']}',
                textAlign: TextAlign.center,
                style: AppFonts.titleRaceCourse,
              ),
            ),
          ),
        )
      ],
    );
  }

  Padding createRaceCourseButton(int indexValue) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        textAlign: TextAlign.left,
        maxLines: 1,
        widget.selectedItems.toList()[indexValue]["RaceCourse"],
        style: AppFonts.body,
      ),
    );
  }

  // Method to return an Expanded widget
  Expanded createExpandedWidget(int totalCount, int start) {
    return Expanded(
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Container(
              color: AppColors.selectedDarkBrownColor,
              height: 40,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 2,
                  ),
                  Text(AppMenuButtonTitles.select,
                      textAlign: TextAlign.left, style: AppFonts.body1),
                  SizedBox(
                    width: 8,
                  ),
                  Text(AppMenuButtonTitles.racecourses,
                      textAlign: TextAlign.left, style: AppFonts.body1),
                ],
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  totalCount,
                  (index) {
                    int value1 = start + index;
                    return createRaceCourseSizedBox(indexValue: value1);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to return a SizedBox widget
  SizedBox createRaceCourseSizedBox(
      {double height = 35, required int indexValue}) {
    return SizedBox(
      height: height,
      child: ListTileTheme(
        horizontalTitleGap: 0,
        minLeadingWidth: 0,
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          checkColor: Colors.white,
          activeColor: AppColors.checkboxlist1Color,
          side: const BorderSide(color: AppColors.checkboxlist1Color, width: 2),
          dense: true,
          title: Text(
            textAlign: TextAlign.left,
            maxLines: 1,
            widget.selectedItems.toList()[indexValue]["RaceCourse"],
            style: AppFonts.body,
          ),
          value: widget.selectedItems.toList()[indexValue]["RaceCourse"],
          onChanged: (value) {
            setState(() {
              for (var element in widget.selectedItems.toList()[indexValue]
                  ["RaceCourse"]) {
                element["value"] = false;
              }
              checkListItems[indexValue]["value"] = value;
              Selected =
                  "${checkListItems[indexValue]["id"]}, ${widget.selectedItems.toList()[indexValue]["RaceCourse"]}, ${checkListItems[indexValue]["value"]}";
              title = widget.selectedItems.toList()[indexValue]["RaceCourse"];
            });
          },
        ),
      ),
    );
  }
}
