import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/appcolors.dart';
import 'package:racecourse_tracks/core/firestoreservice.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/comparedashboardbox.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/dataprovider.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/direction_racecourse.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/finishing_port.dart';

class CompareDashboardPage extends StatefulWidget {
  const CompareDashboardPage({super.key});

  @override
  _CompareDashboardPage createState() => _CompareDashboardPage();
}

class _CompareDashboardPage extends State<CompareDashboardPage> {
  String selectedRacecourse = "";

  void onUserSelected(String racecourse) {
    setState(() {
      selectedRacecourse = racecourse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DataProvider(
      selectedRacecourse: selectedRacecourse,
      updateValue: onUserSelected,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryLightBgColor,
          title: const Text(
            'Compare RaceCourse',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: AppColors.primaryBgColor1,
        body: SingleChildScrollView(
          child: Column(
            children: [
              CompareDashboardBox(
                users: FirestoreService.users,
                onUserSelected: onUserSelected,
              ),
              const SizedBox(
                height: 8,
              ),
              FinishingPort(
                users: FirestoreService.users,
                winddata: FirestoreService.winddata,
                direction: FirestoreService.direction,
                isFromHome: false,
              ),
              DirectionRacecourse(
                users: FirestoreService.users,
                winddata: FirestoreService.winddata,
                direction: FirestoreService.direction,
                isFromHome: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
