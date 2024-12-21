import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/common/appmenubuttontitles.dart';
import 'package:racecourse_tracks/core/utility/firestoreservice.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/comparedashboardbox.dart';
import 'package:racecourse_tracks/core/utility/dataprovider.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/direction_racecourse.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/finishing_port.dart';
import 'package:racecourse_tracks/screens/SelectionPage/itemlistprovider.dart';

class CompareDashboardPage extends StatefulWidget {
  ItemListProvider provider;
  CompareDashboardPage({super.key, required this.provider});

  @override
  _CompareDashboardPage createState() => _CompareDashboardPage();
}

class _CompareDashboardPage extends State<CompareDashboardPage> {
  String selectedRacecourse = "";
  String selectedRacecourseType = "";
  

  void onUserSelected(String racecourse, String racecourseType) {
    setState(() {
      selectedRacecourse = racecourse;
      selectedRacecourseType = racecourseType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DataProvider(
      selectedRacecourse: selectedRacecourse,
      selectedRacecourseType: selectedRacecourseType,
      updateValue: onUserSelected,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text(
            AppMenuButtonTitles.compareRacecourses,
            style: AppFonts.title1,
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              CompareDashboardBox(
                users: FirestoreService.users,
                onUserSelected: onUserSelected,
                provider: widget.provider,
              ),
              FinishingPort(
                users: FirestoreService.users,
                winddata: FirestoreService.winddata,
                direction: FirestoreService.direction,
                isFromHome: false,
              ),
              Visibility(
                visible: false,
                child: DirectionRacecourse(
                  users: FirestoreService.users,
                  winddata: FirestoreService.winddata,
                  direction: FirestoreService.direction,
                  isFromHome: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
