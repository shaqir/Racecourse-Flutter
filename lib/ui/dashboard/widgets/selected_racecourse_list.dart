import 'package:flutter/material.dart';
import 'package:racecourse_tracks/ui/core/theme/appcolors.dart';
import 'package:racecourse_tracks/ui/core/theme/appfonts.dart';
import 'package:racecourse_tracks/utils/apputils.dart';

class SelectedRacecourseList extends StatelessWidget {
  final Function(String selectedRacecourse, String selectedRacecourseType)
      onUserSelected;
  final List<Map<String, dynamic>> selectedItemList;
  final Map<String, dynamic> selectedRaceCourse;
  const SelectedRacecourseList({
    super.key,
    required this.onUserSelected,
    required this.selectedItemList,
    required this.selectedRaceCourse,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Column(
          children: [
            Wrap(
              spacing: 0.5, // Horizontal spacing
              runSpacing: 0.1, // Vertical spacing
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: List.generate(selectedItemList.length, (index) {
                final isSelected = 
                    selectedItemList[index]["Racecourse Type"] ==
                        selectedRaceCourse["Racecourse Type"] &&
                    selectedItemList[index]["Racecourse"] ==
                        selectedRaceCourse["Racecourse"];
                return Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Apputils()
                            .getColor(
                                selectedItemList[index]["Racecourse Type"])
                            .withValues(alpha: 0.6)
                        : Colors.transparent,
                    borderRadius: isSelected
                        ? BorderRadius.circular(8)
                        : BorderRadius.circular(0),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Apputils()
                                  .getColor(selectedItemList[index]
                                      ["Racecourse Type"])
                                  .withValues(alpha: 0.6), // Glow color
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ]
                        : [], // No shadow for unselected buttons
                  ),
                  child: ChoiceChip(
                    padding: EdgeInsets.all(4),
                    labelPadding: isSelected
                        ? EdgeInsets.all(6)
                        : EdgeInsets.all(4),
                    selectedShadowColor: isSelected
                        ? Apputils().getColor(
                            selectedItemList[index]["Racecourse Type"])
                        : Colors.transparent,
                    label: Text(
                      selectedItemList[index]['Racecourse'] ?? 'Unknown',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.white70,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: isSelected ? 17 : 15,
                        fontFamily: AppFonts.myCutsomeSourceSansFont,
                      ),
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? Colors.black
                          : Colors.white,
                      width: isSelected ? 1.0 : 0,
                    ),
                    selected: isSelected,
                    showCheckmark: false,
                    onSelected: (bool selected) {
                      if (selected) {
                        onUserSelected(
                          selectedItemList[index]["Racecourse"] ?? '',
                          selectedItemList[index]["Racecourse Type"] ?? '',
                        );
                      }
                    },
                    selectedColor: Apputils()
                        .getColor(selectedItemList[index]["Racecourse Type"]),
                    backgroundColor: Apputils()
                        .getColor(selectedItemList[index]["Racecourse Type"])
                        .withValues(alpha: 0.7),
                  ),
                );
              }),
            ),
          ],
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.tablecontentBgColor
                .withValues(alpha: 0.7), // Background color
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              width: 1,
              color: Colors.brown,
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Center(
              child: selectedItemList.isNotEmpty &&
                      selectedRaceCourse.isNotEmpty
                  ? Text(
                      selectedRaceCourse['Name'] ??
                          selectedRaceCourse['Racecourse'],
                      textAlign: TextAlign.center,
                      style: AppFonts.titleRaceCourse,
                    )
                  : Text(
                      "No Data Available", // Fallback text when no valid selection
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
