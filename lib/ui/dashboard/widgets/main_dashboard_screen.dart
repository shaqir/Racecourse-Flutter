import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/ui/core/theme/appfonts.dart';
import 'package:racecourse_tracks/data/services/firestore_service.dart';
import 'package:racecourse_tracks/ui/compare/widgets/direction_racecourse.dart';
import 'package:racecourse_tracks/ui/core/ui/finishing_port.dart';
import 'package:racecourse_tracks/ui/dashboard/widgets/selected_racecourse_list.dart';
import 'package:racecourse_tracks/data/repositories/racecourse_repository.dart';
import 'package:racecourse_tracks/ui/core/ui/user_subscription_widget.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({
    super.key,
  });

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This will be called after the build method
      final itemListProvider =
          Provider.of<RacecourseRepository>(context, listen: false);
      if (itemListProvider.selectedItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select at least one item."),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemListProvider = Provider.of<RacecourseRepository>(context);

    return Scaffold(
      appBar: AppBar(
        leading: UserSubscriptionWidget(userSubscription: 'Trial'),
        centerTitle: true, // Centers the text in the AppBar
        title: Text(
          'Racecourses.Tracks',
          style: AppFonts.title1,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => itemListProvider.refreshData()),
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
                      SelectedRacecourseList(
                        onUserSelected:
                            (selectedRacecourse, selectedRacecourseType) =>
                                itemListProvider.setSelectedRacecource(
                                    selectedRacecourse, selectedRacecourseType),
                      ),
                      FinishingPort(
                        winddata: FirestoreService.winddata,
                        direction: FirestoreService.direction,
                        isFromHome: true,
                        hideWindColumn: false,
                        selectedRacecourseData:
                            itemListProvider.selectedRacecourse,
                        showUpgradeButton: false,
                      ),
                      DirectionRacecourse(
                        winddata: FirestoreService.winddata,
                        direction: FirestoreService.direction,
                        isFromHome: true,
                        selectedRacecourse: itemListProvider.selectedRacecourse,
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
                          SizedBox(height: 8), // Space between loader and text
                          Text(
                            'Refreshing...',
                            style: AppFonts.body6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Container()
            ],
          ),
        ),
      ),
    );
  }
}
