import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/common/appmenubuttontitles.dart';
import 'package:racecourse_tracks/core/utility/firestoreservice.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/direction_racecourse.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/finishing_port.dart';
import 'package:racecourse_tracks/screens/DashboardHomepage/selected_racecourse_list.dart';
import 'package:racecourse_tracks/screens/SelectionPage/itemlistprovider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Centers the text in the AppBar
        title: Text(
          AppMenuButtonTitles.racecourses,
          style: AppFonts.title1,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => Provider.of<ItemListProvider>(context, listen: false)
                  .refreshData()),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width:
              double.infinity, // Ensures the container fills the screen width
          height: double
              .infinity, // Ensures the container fills the screen height
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SelectedRacecourseList(
                        onUserSelected: (selectedRacecourse, selectedRacecourseType) => Provider.of<ItemListProvider>(context, listen: false)
                            .setSelectedRacecource(selectedRacecourse, selectedRacecourseType),
                      ),
                      FinishingPort(
                        winddata: FirestoreService.winddata,
                        direction: FirestoreService.direction,
                        isFromHome: true,
                      ),
                      DirectionRacecourse(
                        winddata: FirestoreService.winddata,
                        direction: FirestoreService.direction,
                        isFromHome: true,
                      ),
                    ],
                  ),
                ),
              ),
    
              // Loader overlay
    
              Consumer<ItemListProvider>(builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Positioned.fill(
                    child: Container(
                      width: double.infinity, // Full width
                      height: double.infinity, // Full height
                      color: Colors.black
                          .withValues(alpha: 0.75), // Semi-transparent overlay
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                                height: 8), // Space between loader and text
                            Text(
                              'Refreshing...',
                              style: AppFonts.body6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(); // No overlay when not loading
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
