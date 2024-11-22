import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/utility/dataprovider.dart';
import 'package:racecourse_tracks/core/utility/firestoreservice.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/direction_racecourse.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/finishing_port.dart';
import 'package:racecourse_tracks/screens/DashboardHomepage/selected_racecourse_list.dart';

class DashboardPage extends StatefulWidget {
  final Set<Map<String, dynamic>> selectedItems;

  DashboardPage({
    super.key,
    required this.selectedItems,
  });

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedRacecourse = "";
  String selectedRacecourseType = "";
  bool value = false;
  String title = "Racecourses";

  void onUserSelected(String racecourse, String racecourseType) {
    print("JOTO AAYA : ${racecourse} ${racecourseType}");
    setState(() {
      selectedRacecourse = racecourse;
      selectedRacecourseType = racecourseType;
    });
  }

  List windData = [
    {
      "raceid": 1,
      "course": "1000m",
      "direction": "↗",
      "1stTurn": "200m",
      "Length": "Medium",
    },
    {
      "raceid": 2,
      "course": "1200m",
      "direction": "↖",
      "1stTurn": "200m",
      "Length": "Short",
    },
    {
      "raceid": 3,
      "course": "1300m",
      "direction": "←",
      "1stTurn": "300m",
      "Length": "Medium",
    },
    {
      "raceid": 4,
      "course": "1400m",
      "direction": "↘",
      "1stTurn": "300m",
      "Length": "Medium",
    },
    {
      "raceid": 5,
      "course": "1500m",
      "direction": "↗",
      "1stTurn": "400m",
      "Length": "Long Medium",
    },
    {
      "raceid": 5,
      "course": "2000m",
      "direction": "→",
      "1stTurn": "300m",
      "Length": "Very Short",
    },
    {
      "raceid": 7,
      "course": "2000m",
      "direction": "↖",
      "1stTurn": "300m",
      "Length": "Very Short",
    },
    {
      "raceid": 8,
      "course": "2300m",
      "direction": "↗",
      "1stTurn": "300m",
      "Length": "Very Short",
    },
    {
      "raceid": 9,
      "course": "2300m",
      "direction": "↙",
      "1stTurn": "300m",
      "Length": "Very Short",
    },
    {
      "raceid": 10,
      "course": "2600m",
      "direction": "↗",
      "1stTurn": "300m",
      "Length": "Very Short",
    },
  ];

  @override
  Widget build(BuildContext context) {
    print("SELECTD ITEMS : ${widget.selectedItems}");
    return DataProvider(
      selectedRacecourse: selectedRacecourse,
      selectedRacecourseType: selectedRacecourseType,
      updateValue: onUserSelected,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: AppFonts.title1,
          ),
        ),
        body: Container(
          color: AppColors.primaryBgColor1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SelectedRacecourseList(
                  selectedItems: widget.selectedItems,
                  onUserSelected: onUserSelected,
                ),
                FinishingPort(
                  users: FirestoreService.users,
                  winddata: FirestoreService.winddata,
                  direction: FirestoreService.direction,
                  isFromHome: true,
                ),
                DirectionRacecourse(
                  users: FirestoreService.users,
                  winddata: FirestoreService.winddata,
                  direction: FirestoreService.direction,
                  isFromHome: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
