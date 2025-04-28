import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/common/appmenubuttontitles.dart';
import 'package:racecourse_tracks/core/utility/firestoreservice.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/comparedashboardbox.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/finishing_port.dart';
import 'package:racecourse_tracks/screens/SelectionPage/itemlistprovider.dart';

class FreeDashboardPage extends StatelessWidget {
  const FreeDashboardPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final itemListProvider = Provider.of<ItemListProvider>(context);
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
              onPressed: () =>
                  Provider.of<ItemListProvider>(context, listen: false)
                      .refreshData()),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width:
              double.infinity, // Ensures the container fills the screen width
          height:
              double.infinity, // Ensures the container fills the screen height
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CompareDashboardBox(
                            onRacecourseSelected: (racecourse, racecourseType) => Provider
                                    .of<ItemListProvider>(context, listen: false)
                                .setSelectedRacecource(racecourse, racecourseType), 
                                currentRaceCourseChoice: itemListProvider.selectedRacecourse['Racecourse'] ?? '', 
                                currentRaceCourseTypeChoice: itemListProvider.selectedRacecourse['Racecourse Type'] ?? '',
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
                          height: 40,
                          width: double.infinity,
                          child: Center(
                              child: itemListProvider.selectedRacecourse.isNotEmpty
                                  ? Text(
                                      itemListProvider.selectedRacecourse['Name'] ??
                                          itemListProvider
                                              .selectedRacecourse['Racecourse'],
                                      textAlign: TextAlign.center,
                                      style: AppFonts.titleRaceCourse,
                                    )
                                  : Text(
                                      "No Data Available", // Fallback text when no valid selection
                                      textAlign: TextAlign.center,
                                      style: AppFonts.titleRaceCourse,
                                    ),
                            )
                        ),
                      ),
                      FinishingPort(
                        winddata: FirestoreService.winddata,
                        direction: FirestoreService.direction,
                        isFromHome: true,
                        hideWindColumn: true, 
                        selectedRacecourseData: itemListProvider.selectedRacecourse,
                      ),
                    ],
                  ),
                ),
              ),

              // Loader overlay

              if (itemListProvider.isLoading) 
                  Positioned.fill(
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
                  )
                
            ],
          ),
        ),
      ),
    );
  }
}
