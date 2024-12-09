import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/common/appmenubuttontitles.dart';
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

  void onUserSelected(String racecourse, String racecourseType) {
    setState(() {
      selectedRacecourse = racecourse;
      selectedRacecourseType = racecourseType;
    });
  }

  Future<void> _refreshData() async {
    try {
      final firestoreService = FirestoreService();

      // Fetching data from Firestore
      await firestoreService.getUsers();
      await firestoreService.getWinddata();
      await firestoreService.getDirectiondata();
      await firestoreService.getLengthdata();

      // Notify the user (optional)
      print('Data refreshed successfully!');

      setState(() {});
    } catch (e) {
      print('Error refreshing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DataProvider(
      selectedRacecourse: selectedRacecourse,
      selectedRacecourseType: selectedRacecourseType,
      updateValue: onUserSelected,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true, // Centers the text in the AppBar
          title: Text(
            AppMenuButtonTitles.racecourses,
            style: AppFonts.title1,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                await _refreshData();
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          width:
              double.infinity, // Ensures the container fills the screen width
          height:
              double.infinity, // Ensures the container fills the screen height

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
                /*
                DirectionRacecourse(
                  users: FirestoreService.users,
                  winddata: FirestoreService.winddata,
                  direction: FirestoreService.direction,
                  isFromHome: true,
                ),
                */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
