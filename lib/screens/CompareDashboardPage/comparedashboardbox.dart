import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/utility/sharedpreferenceshelper.dart';
import 'package:racecourse_tracks/screens/SelectionPage/itemlistprovider.dart';

class CompareDashboardBox extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final Function(String selectedRacecourse, String selectedRacecourseType)
      onUserSelected;
  final ItemListProvider provider;
  final int index;

  const CompareDashboardBox({
    super.key,
    required this.users,
    required this.onUserSelected,
    required this.provider,
    required this.index,
  });

  @override
  State<CompareDashboardBox> createState() => _CompareDashboardBoxState();
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
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() async {
    Map<String, String> savedData =
        await SharedPreferencesHelper.getSelectedRacecourse(widget.index);
    setState(() {
      currentRaceCourseTypeChoice =
          savedData['type']!.isNotEmpty ? savedData['type'] : _menuitems[0];
      currentRaceCourseChoice =
          savedData['racecourse']!.isNotEmpty ? savedData['racecourse'] : null;
    });
    _filterUsers();
  }

  void _filterUsers() {
    setState(() {
      _useritems = widget.users
          .where(
              (user) => user['Racecourse Type'] == currentRaceCourseTypeChoice)
          .map((user) => user['Racecourse'].toString())
          .toList();

      _useritems.sort((a, b) => a.compareTo(b));

      if (_useritems.contains(currentRaceCourseChoice)) {
        currentRaceCourseChoice = currentRaceCourseChoice;
      } else {
        currentRaceCourseChoice = _useritems.isNotEmpty ? _useritems[0] : null;
      }

      if (currentRaceCourseChoice != null) {
        widget.onUserSelected(
            currentRaceCourseChoice!, currentRaceCourseTypeChoice ?? '');
      }
    });
    _saveData();
  }

  void _saveData() {
    if (currentRaceCourseChoice != null &&
        currentRaceCourseTypeChoice != null) {
      SharedPreferencesHelper.saveSelectedRaceCourse(
        widget.index,
        currentRaceCourseChoice!,
        currentRaceCourseTypeChoice!,
      );
    }
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
        children: [
          Spacer(),
          IntrinsicWidth(
            child: Container(
              height: 50,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.rectangleBoxColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    width: 1, color: AppColors.lightGrayBackgroundColor),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: currentRaceCourseTypeChoice,
                dropdownColor: Colors.white,
                onChanged: (String? newValue) {
                  setState(() {
                    currentRaceCourseTypeChoice = newValue;
                    _filterUsers();
                  });
                  _saveData();
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
          SizedBox(width: 8),
          IntrinsicWidth(
            child: Container(
              height: 50,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.rectangleBoxColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    width: 1, color: AppColors.lightGrayBackgroundColor),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: currentRaceCourseChoice,
                dropdownColor: Colors.white,
                onChanged: (String? newValue) {
                  setState(() {
                    currentRaceCourseChoice = newValue;
                    if (newValue != null) {
                      widget.onUserSelected(
                          newValue, currentRaceCourseTypeChoice ?? '');
                    }
                  });
                  _saveData();
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
      )),
    );
  }
}



// class CompareDashboardBox extends StatefulWidget {
//   final List<Map<String, dynamic>> users;
//   final Function(String selectedRacecourse, String selectedRacecourseType)
//       onUserSelected; // Add callback
//   ItemListProvider provider;
  

//   CompareDashboardBox({
//     super.key,
//     required this.users,
//     required this.onUserSelected,
//     required this.provider,
//   });

//   @override
//   _CompareDashboardBoxState createState() => _CompareDashboardBoxState();
// }

// class _CompareDashboardBoxState extends State<CompareDashboardBox> {
//   final List<String> _menuitems = [
//     'Gallops',
//     'Dogs',
//     'Harness',
//   ];
//   List<String> _useritems = [];
//   String? currentRaceCourseTypeChoice;
//   String? currentRaceCourseChoice;

//   @override
//   void initState() {
//     String? selectedRaceCourseType =
//         widget.provider.selectedRacecourse['Racecourse Type'] ?? '';

//     currentRaceCourseTypeChoice = selectedRaceCourseType?.isEmpty != null
//         ? selectedRaceCourseType
//         : _menuitems[0];

//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _filterUsers();
//     });
//   }

//   void _filterUsers() {
//     setState(() {
//       _useritems = widget.users
//           .where(
//               (user) => user['Racecourse Type'] == currentRaceCourseTypeChoice)
//           .map((user) => user['Racecourse'].toString())
//           .toList();

//       _useritems.sort((a, b) => a.compareTo(b));

//       // Sort alphabetically by the "Racecourse" key
//       currentRaceCourseChoice = _useritems.isNotEmpty ? _useritems[0] : null;
//       // Timer(Duration(seconds: 1), () {
//       if (currentRaceCourseChoice != null) {
//         widget.onUserSelected(currentRaceCourseChoice ?? '',
//             currentRaceCourseTypeChoice ?? ''); // Notify parent
//       }
//       // });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: AppColors.checkboxlist2Color,
//         borderRadius: BorderRadius.circular(25),
//       ),
//       height: 80,
//       child: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Spacer(),
//             Container(
//               height: 50,
//               padding: EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: AppColors.rectangleBoxColor, // Background color
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                     width: 1, //
//                     color: AppColors.lightGrayBackgroundColor),
//               ),
//               child: Center(
//                 child: DropdownButton<String>(
//                   value: currentRaceCourseTypeChoice,
//                   alignment: Alignment.bottomCenter,
//                   dropdownColor: Colors.white,
//                   elevation: 10,
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       currentRaceCourseTypeChoice = newValue;
//                       _filterUsers();
//                     });
//                   },
//                   items: _menuitems.map((String value) {
//                     return DropdownMenuItem(
//                       value: value,
//                       child: Text(value,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'SourceSansVariable',
//                           )),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             Container(
//               height: 50,
//               padding: EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: AppColors.rectangleBoxColor, // Background color
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                     width: 1, //
//                     color: AppColors.lightGrayBackgroundColor),
//               ),
//               child: Center(
//                 child: DropdownButton<String>(
//                   value: currentRaceCourseChoice,
//                   alignment: Alignment.bottomCenter,
//                   dropdownColor: Colors.white,
//                   elevation: 0,
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       currentRaceCourseChoice = newValue;
//                       if (newValue != null) {
//                         widget.onUserSelected(newValue,
//                             currentRaceCourseTypeChoice ?? ''); // Notify parent
//                       }
//                     });
//                   },
//                   items: _useritems.map((String value) {
//                     return DropdownMenuItem(
//                       value: value,
//                       child: Text(value,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'SourceSansVariable',
//                           )),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//             Spacer(),
//           ],
//         ),
//       ),
//     );
//   }
// }
