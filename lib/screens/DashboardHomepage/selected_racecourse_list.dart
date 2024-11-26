import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/utility/apputils.dart';
import 'package:racecourse_tracks/screens/SelectionPage/itemlistprovider.dart';

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
      if (widget.selectedItems.isNotEmpty) {
        widget.onUserSelected(
          widget.selectedItems.toList()[_selectedIndex]["Racecourse"] ?? '',
          widget.selectedItems.toList()[_selectedIndex]["Racecourse Type"] ??
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

    List<Map<String, dynamic>> selectedItemList = widget.selectedItems.toList();
    //  final _itemListProvider =
    //     Provider.of<ItemListProvider>(context, listen: false);
    //     List<Map<String, dynamic>> selectedItemList = _itemListProvider.selectedItems.toList();
    
    String selectedRaceCourseType1 = selectedItemList[0]["Racecourse Type"];

    return Column(
      children: [
        Container(
          child: Column(
            children: [
              Wrap(
                spacing: 1, // Horizontal spacing
                runSpacing: 1, // Vertical spacing
               
                children: List.generate(selectedItemList.length, (index) {
                  return ChoiceChip(
                    
                    label: Text(
                      selectedItemList[index]['Racecourse'] ?? 'Unknown',
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        fontFamily: AppFonts.myCutsomeSourceSansFont,
                      ),
                    ),
                    side: BorderSide(
                      color: _selectedIndex == index
                          ? AppColors.primaryLightBgColor
                          : Colors.brown,
                      width: 1,
                    ),
                    selected: _selectedIndex == index,
                    onSelected: (bool selected) {
                      if (selected) {
                        _updateSelectedIndex(index, selectedItemList[index]["Racecourse Type"]);
                        widget.onUserSelected(
                          selectedItemList[index]["Racecourse"] ?? '',
                          selectedItemList[index]["Racecourse Type"] ?? '',
                        );
                      }
                    },
                    selectedColor: Apputils().getColor(_selectedType),
                    backgroundColor: AppColors.primaryLightBgColor,
                  );
                }),
              ),
            ],
          ),
        ),
        SizedBox(height: 4,),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.tablecontentBgColor, // Background color
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
