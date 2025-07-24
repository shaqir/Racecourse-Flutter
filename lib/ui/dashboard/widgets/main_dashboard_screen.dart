import 'package:flutter/material.dart';
import 'package:racecourse_tracks/ui/core/theme/appfonts.dart';
import 'package:racecourse_tracks/ui/compare/widgets/direction_racecourse.dart';
import 'package:racecourse_tracks/ui/core/ui/finishing_port.dart';
import 'package:racecourse_tracks/ui/dashboard/view_model/main_dashboard_view_model.dart';
import 'package:racecourse_tracks/ui/dashboard/widgets/selected_racecourse_list.dart';
import 'package:racecourse_tracks/ui/subscription/widgets/user_subscription_widget.dart';
import 'package:racecourse_tracks/utils/apputils.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({
    super.key,
    required this.viewModel,
  });
  final MainDashboardViewModel viewModel;

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.init();
    if (widget.viewModel.selectedItemList.isEmpty) {
      // show a message or handle the case where no items are selected
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No racecourses selected. Please select a racecourse to continue.',
              style: AppFonts.body6,
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(
              leading: UserSubscriptionWidget(),
              centerTitle: true, // Centers the text in the AppBar
              title: Text(
                'Racecourses.Tracks',
                style: AppFonts.title1,
              ),
              actions: [
                IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () =>
                        widget.viewModel.refreshSelectedRacecourse()),
              ],
            ),
            body: SafeArea(
              child: Container(
                color: Colors.white,
                width: double
                    .infinity, // Ensures the container fills the screen width
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
                              selectedItemList:
                                  widget.viewModel.selectedItemList,
                              selectedRaceCourse:
                                  widget.viewModel.selectedRacecourse,
                              onUserSelected: (selectedRacecourse,
                                      selectedRacecourseType) =>
                                  widget.viewModel.setSelectedRacecource(
                                      selectedRacecourse,
                                      selectedRacecourseType),
                            ),
                            FinishingPort(
                              groundColor: widget.viewModel.groundType['color'],
                              groundName: widget.viewModel.groundType['type'],
                              winddata: widget.viewModel.windData,
                              direction: widget.viewModel.direction,
                              lengthData: widget.viewModel.lengthData,
                              isFromHome: true,
                              hideWindColumn: false,
                              selectedRacecourseData:
                                  widget.viewModel.selectedRacecourse,
                              showUpgradeButton: false,
                            ),
                            if (widget.viewModel.racecourseWidthData != null &&
                                widget
                                    .viewModel.racecourseWidthData!.isNotEmpty)
                              Container(
                                  width: MediaQuery.sizeOf(context).width * 0.4,
                                  padding: EdgeInsets.symmetric(vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Apputils().hexToColor(widget
                                        .viewModel
                                        .racecourseWidthData!['ColorCode']).withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    '${widget.viewModel.racecourseWidthData!['Width Type']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  )),
                            if (!widget.viewModel.isLoading)
                              DirectionRacecourse(
                                winddata: widget.viewModel.windData,
                                direction: widget.viewModel.direction,
                                lengthData: widget.viewModel.firstTurnData,
                                isFromHome: true,
                                selectedRacecourse:
                                    widget.viewModel.selectedRacecourse,
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Loader overlay

                    if (widget.viewModel.isLoading)
                      Positioned.fill(
                        child: Container(
                          width: double.infinity, // Full width
                          height: double.infinity, // Full height
                          color: Colors.black.withValues(
                              alpha: 0.75), // Semi-transparent overlay
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(
                                    height: 8), // Space between loader and text
                                Text(
                                  'REFRESHING...',
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
        });
  }
}
