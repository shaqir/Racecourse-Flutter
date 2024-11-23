import 'dart:async';

import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/common/appmenubuttontitles.dart';

class SelectedRacecourseList extends StatefulWidget {
  final Function(String selectedRacecourse, String selectedRacecourseType)
      onUserSelected;
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
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    // Retrieve the index from PageStorage if available, or default to 0
    _selectedIndex = 0;
    title = 'RaceCourse';

    // Notify parent widget about the selected item initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedItems.isNotEmpty) {
        widget.onUserSelected(
          widget.selectedItems.toList()[_selectedIndex]["Racecourse"] ?? '',
          widget.selectedItems.toList()[_selectedIndex]["Racecourse Type"] ??
              '',
        );
      }
    });
  }

  void _updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> selectedItemList = widget.selectedItems.toList();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0, // Horizontal spacing
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
                      if (selected) {
                        _updateSelectedIndex(index);
                        widget.onUserSelected(
                          selectedItemList[index]["Racecourse"] ?? '',
                          selectedItemList[index]["Racecourse Type"] ?? '',
                        );
                      }
                    },
                    selectedColor: AppColors.selectedDarkBrownColor,
                    backgroundColor: AppColors.primaryLightBgColor,
                  );
                }),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.tablecontentBgColor, // Background color
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              width: 1,
              color: AppColors.checkboxlist2Color,
            ),
          ),
          child: SizedBox(
            height: 40,
            width: double.infinity,
            child: Center(
              child: Text(
                selectedItemList[_selectedIndex]['Racecourse'] ?? '',
                textAlign: TextAlign.center,
                style: AppFonts.titleRaceCourse,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
