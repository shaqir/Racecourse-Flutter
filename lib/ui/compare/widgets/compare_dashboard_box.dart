import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:racecourse_tracks/ui/core/theme/appcolors.dart';

class CompareDashboardBox extends StatelessWidget {
  final Function(String racecourse) onRacecourseSelected;
  final Function(String racecourseType) onRacecourseTypeSelected;

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
    final textEditingController = TextEditingController();
    return Container(
      margin: const EdgeInsets.all(8),
      padding: EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: AppColors.checkboxlist2Color,
        borderRadius: BorderRadius.circular(25),
      ),
      height: 80,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 50,
                padding: const EdgeInsets.all(4),
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
                          style: const TextStyle(
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
            Expanded(
              flex: 3,
              child: Container(
                height: 50,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.dropdownButtonColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      width: 1, color: AppColors.lightGrayBackgroundColor),
                ),
                child: DropdownButton2<String>(
                  isExpanded: true,
                  value: currentRaceCourseChoice,
                  menuItemStyleData: const MenuItemStyleData(
                    overlayColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  onChanged: (String? newValue) {
                    onRacecourseSelected(newValue ?? '');
                  },
                  items: allRacecourses.map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceSansVariable',
                          )),
                    );
                  }).toList(),
                  dropdownSearchData: DropdownSearchData(
                    searchController: textEditingController,
                    searchInnerWidgetHeight: 50,
                    searchInnerWidget: Container(
                      height: 50,
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 4,
                        right: 8,
                        left: 8,
                      ),
                      child: TextFormField(
                        expands: true,
                        maxLines: null,
                        controller: textEditingController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          hintText: 'Search for an item...',
                          hintStyle: const TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      return item.value.toString().toLowerCase().startsWith(searchValue.toLowerCase());
                    },
                  ),
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      textEditingController.clear();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
