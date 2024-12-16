import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/utility/apputils.dart';
import 'package:racecourse_tracks/screens/SelectionPage/itemlistprovider.dart';

class SelectedRacecourseList extends StatefulWidget {
  final Function(String selectedRacecourse, String selectedRacecourseType)
      onUserSelected;
  //final Set<Map<String, dynamic>> selectedItems;
  ItemListProvider provider;


   SelectedRacecourseList({
    super.key,
    required this.provider,
    required this.onUserSelected,
  });

  @override
  State<SelectedRacecourseList> createState() => _SelectedRacecourseListState();
}

class _SelectedRacecourseListState extends State<SelectedRacecourseList> {
  String title = "";
  late int _selectedIndex;
  late String _selectedType;

  @override
  void initState() {
    super.initState();
    // Retrieve the index from PageStorage if available, or default to 0
    _selectedIndex = 0;
    title = 'RaceCourse';
    _selectedType = '';

    // Notify parent widget about the selected item initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.provider.selectedItems.isNotEmpty) {
        widget.onUserSelected(
          widget.provider.selectedItems.toList()[_selectedIndex]["Racecourse"] ?? '',
          widget.provider.selectedItems.toList()[_selectedIndex]["Racecourse Type"] ??
              '',
        );
      }
    });
  }

  void _updateSelectedIndex(int index, String type) {
    setState(() {
      _selectedIndex = index;
      _selectedType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
        
    List<Map<String, dynamic>> selectedItemList = widget.provider.selectedItems.toList();

    return Column(
      children: [
        Container(
          child: Column(
            children: [
              Wrap(
                spacing: 0.5, // Horizontal spacing
                runSpacing: 0.1, // Vertical spacing
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: List.generate(selectedItemList.length, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: _selectedIndex == index
                          ? Apputils()
                              .getColor(
                                  selectedItemList[index]["Racecourse Type"])
                              .withOpacity(0.6)
                          : Colors.transparent,
                      borderRadius: _selectedIndex == index
                          ? BorderRadius.circular(8)
                          : BorderRadius.circular(0),
                      boxShadow: _selectedIndex == index
                          ? [
                              BoxShadow(
                                color: Apputils()
                                    .getColor(selectedItemList[index]
                                        ["Racecourse Type"])
                                    .withOpacity(0.6), // Glow color
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ]
                          : [], // No shadow for unselected buttons
                    ),
                    child: ChoiceChip(
                      padding: EdgeInsets.all(4),
                      labelPadding: _selectedIndex == index
                          ? EdgeInsets.all(6)
                          : EdgeInsets.all(4),
                      selectedShadowColor: _selectedIndex == index
                          ? Apputils().getColor(selectedItemList[index]["Racecourse Type"])
                          : Colors.transparent,
                      label: Text(
                        selectedItemList[index]['Racecourse'] ?? 'Unknown',
                        style: TextStyle(
                          color: _selectedIndex == index
                              ? Colors.white
                              : Colors.white70,
                          fontWeight: _selectedIndex == index
                              ? FontWeight.w700
                              : FontWeight.w500,
                          fontSize: _selectedIndex == index ? 17 : 15,
                          fontFamily: AppFonts.myCutsomeSourceSansFont,
                        ),
                      ),
                      side: BorderSide(
                        color: _selectedIndex == index
                            ? Colors.black
                            : Colors.white,
                        width: _selectedIndex == index ? 1.0 : 0,
                      ),
                      selected: _selectedIndex == index,
                      showCheckmark: false,
                      onSelected: (bool selected) {
                        if (selected) {
                          _updateSelectedIndex(index,
                              selectedItemList[index]["Racecourse Type"]);
                          widget.onUserSelected(
                            selectedItemList[index]["Racecourse"] ?? '',
                            selectedItemList[index]["Racecourse Type"] ?? '',
                          );
                        }
                      },
                      selectedColor: Apputils()
                          .getColor(selectedItemList[index]["Racecourse Type"])
                          .withOpacity(1),
                      backgroundColor: Apputils()
                          .getColor(selectedItemList[index]["Racecourse Type"])
                          .withOpacity(0.7),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.tablecontentBgColor.withOpacity(0.7), // Background color
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              width: 1,
              color: Colors.brown,
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
