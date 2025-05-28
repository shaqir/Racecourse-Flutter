import 'package:flutter/material.dart';
import 'package:racecourse_tracks/data/services/firestore_service.dart';
import 'package:racecourse_tracks/ui/compare/view_model/compare_dashboard_view_model.dart';
import 'package:racecourse_tracks/ui/compare/widgets/compare_dashboard_box.dart';
import 'package:racecourse_tracks/ui/compare/widgets/direction_racecourse.dart';
import 'package:racecourse_tracks/ui/core/theme/appcolors.dart';
import 'package:racecourse_tracks/ui/core/theme/appfonts.dart';
import 'package:racecourse_tracks/ui/core/ui/finishing_port.dart';
import 'package:racecourse_tracks/ui/core/ui/user_subscription_widget.dart';

class CompareDashboardPage extends StatefulWidget {
  const CompareDashboardPage({
    super.key,
    required this.viewModel,
  });
  final CompareDashboardViewModel viewModel;

  @override
  State<CompareDashboardPage> createState() => _CompareDashboardPageState();
}

class _CompareDashboardPageState extends State<CompareDashboardPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      if (mounted) {
        final selectedRacecourseMap =
            widget.viewModel
                .selectedRacecourseMap;
        if (selectedRacecourseMap.isEmpty) {
          final firstRacecourse =
              widget.viewModel
                  .allItems
                  .firstWhere((item) => item['Racecourse Type'] == 'Gallops');
          widget.viewModel
              .setSelectedRacecourse(1, firstRacecourse['Racecourse']);
          widget.viewModel
              .setSelectedRacecourse(
            2,
            firstRacecourse['Racecourse'],
          );
          widget.viewModel
              .setSelectedRacecourse(
            3,
            firstRacecourse['Racecourse'],
          );

          widget.viewModel
              .setSelectedRacecourseType(1, firstRacecourse['Racecourse Type']);
          widget.viewModel
              .setSelectedRacecourseType(2, firstRacecourse['Racecourse Type']);
          widget.viewModel
              .setSelectedRacecourseType(3, firstRacecourse['Racecourse Type']);
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedRacecourseMap =
        widget.viewModel.selectedRacecourseMap;
    final selectedRacecourseTypeMap =
        widget.viewModel.selectedRacecourseTypeMap;

    return Scaffold(
      appBar: AppBar(
        leading: UserSubscriptionWidget(userSubscription: 'Trial'),
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Compare Courses',
          style: AppFonts.title1,
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350),
              child: PageView.builder(
                controller: _pageController,
                itemCount: selectedRacecourseMap.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, pageIndex) {
                  int boxIndex = pageIndex + 1;
                  final racecourseData = widget.viewModel
                      .allItems
                      .firstWhere((item) =>
                          item['Racecourse'] ==
                              selectedRacecourseMap[boxIndex] &&
                          item['Racecourse Type'] ==
                              selectedRacecourseTypeMap[boxIndex]);
                  final racecourseName = racecourseData['Name'];

                  return Align(
                    alignment: Alignment.topCenter, // Center content
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CompareDashboardBox(
                            onRacecourseSelected: (
                              racecourse,
                            ) =>
                                widget.viewModel
                                    .setSelectedRacecourse(
                              boxIndex,
                              racecourse,
                            ),
                            currentRaceCourseChoice:
                                '${selectedRacecourseMap[boxIndex]}',
                            currentRaceCourseTypeChoice:
                                '${selectedRacecourseTypeMap[boxIndex]}',
                            onRacecourseTypeSelected:
                                (String racecourseType) => widget.viewModel
                                    .setSelectedRacecourseType(
                              boxIndex,
                              racecourseType,
                            ),
                            allRacecourses: [],
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
                                child: selectedRacecourseMap.isNotEmpty
                                    ? Text(
                                        racecourseName.isNotEmpty
                                            ? racecourseName
                                            : selectedRacecourseMap[boxIndex],
                                        textAlign: TextAlign.center,
                                        style: AppFonts.titleRaceCourse,
                                      )
                                    : Text(
                                        "No Data Available", // Fallback text when no valid selection
                                        textAlign: TextAlign.center,
                                        style: AppFonts.titleRaceCourse,
                                      ),
                              ),
                            ),
                          ),
                          FinishingPort(
                            winddata: FirestoreService.winddata,
                            direction: FirestoreService.direction,
                            isFromHome: true,
                            hideWindColumn: true,
                            selectedRacecourseData: racecourseData,
                            showUpgradeButton: false,
                          ),
                          ListenableBuilder(
                              listenable: widget.viewModel,
                              builder: (context, child) {
                            return DirectionRacecourse(
                              selectedRacecourse: widget.viewModel.allItems.firstWhere(
                                  (item) =>
                                      item['Racecourse'] ==
                                          selectedRacecourseMap[boxIndex] &&
                                      item['Racecourse Type'] ==
                                          selectedRacecourseTypeMap[boxIndex]),
                              winddata: FirestoreService.winddata,
                              direction: FirestoreService.direction,
                              isFromHome: true,
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Left navigation button
          Positioned(
            left: 0,
            top: 0,
            bottom: 110,
            child: Center(
              child: IconButton(
                icon: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple.withValues(alpha: 0.9),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.chevron_left,
                      size: 22, color: Colors.white),
                ),
                onPressed: _currentPage > 0
                    ? () => _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        )
                    : null,
              ),
            ),
          ),
          // Right navigation button
          Positioned(
            right: 0,
            top: 0,
            bottom: 110,
            child: Center(
              child: IconButton(
                icon: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple.withValues(alpha: 0.9),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.chevron_right,
                      size: 22, color: Colors.white),
                ),
                onPressed: _currentPage < 2
                    ? () => _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
