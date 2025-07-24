import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/ui/core/theme/appcolors.dart';
import 'package:racecourse_tracks/ui/core/theme/appfonts.dart';
import 'package:racecourse_tracks/ui/compare/view_model/compare_dashboard_view_model.dart';
import 'package:racecourse_tracks/ui/core/ui/finishing_port.dart';
import 'package:racecourse_tracks/ui/compare/widgets/compare_dashboard_box.dart';
import 'package:racecourse_tracks/ui/compare/widgets/direction_racecourse.dart';
import 'package:racecourse_tracks/data/repositories/racecourse_repository.dart';
import 'package:racecourse_tracks/ui/subscription/widgets/user_subscription_widget.dart';
import 'package:racecourse_tracks/utils/apputils.dart';

class CompareDashboardScreen extends StatefulWidget {
  const CompareDashboardScreen({
    super.key,
    required this.viewModel,
  });
  final CompareDashboardViewModel viewModel;

  @override
  State<CompareDashboardScreen> createState() => _CompareDashboardScreenState();
}

class _CompareDashboardScreenState extends State<CompareDashboardScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    widget.viewModel.init();
    Future.delayed(Duration.zero, () {
      if (mounted) {
        final selectedRacecourseMap = widget.viewModel.selectedRacecourseMap;
        if (selectedRacecourseMap.isEmpty) {
          final firstRacecourse = widget.viewModel.allItems
              .firstWhere((item) => item['Racecourse Type'] == 'Gallops');
          widget.viewModel
              .setSelectedRacecourse(1, firstRacecourse['Racecourse']);
          widget.viewModel
              .setSelectedRacecourse(2, firstRacecourse['Racecourse']);
          widget.viewModel
              .setSelectedRacecourse(3, firstRacecourse['Racecourse']);

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
    return ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          final selectedRacecourseMap = widget.viewModel.selectedRacecourseMap;
          final selectedRacecourseTypeMap =
              widget.viewModel.selectedRacecourseTypeMap;
          return Scaffold(
            appBar: AppBar(
              leading: UserSubscriptionWidget(),
              backgroundColor: Colors.deepPurple,
              title: const Text(
                'Compare Courses',
                style: AppFonts.title1,
              ),
              centerTitle: true,
            ),
            body: widget.viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
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
                              final racecourseData = context
                                  .read<RacecourseRepository>()
                                  .allItems
                                  .firstWhere((item) =>
                                      item['Racecourse'] ==
                                          selectedRacecourseMap[boxIndex] &&
                                      item['Racecourse Type'] ==
                                          selectedRacecourseTypeMap[boxIndex]);

                              final racecourseName = racecourseData['Name'];
                              final groundType =
                                  widget.viewModel.groundTypes.firstWhere(
                                (item) => item['id'] == racecourseData['Type'],
                                orElse: () =>
                                    {'Color': Colors.grey, 'Name': 'Unknown'},
                              );
                              final racecourseWidthData =
                                  widget.viewModel.widthData.isNotEmpty == true
                                      ? widget.viewModel.widthData.firstWhere(
                                          (data) =>
                                              data['RacecourseType'] ==
                                                  racecourseData[
                                                      'Racecourse Type'] &&
                                              racecourseData['Width'] != null &&
                                              racecourseData['Width'] != 0 &&
                                              racecourseData['Width'] >=
                                                  data['Min'] &&
                                              racecourseData['Width'] <=
                                                  data['Max'],
                                          orElse: () => {})
                                      : null;

                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    CompareDashboardBox(
                                      onRacecourseSelected: (racecourse) =>
                                          widget.viewModel
                                              .setSelectedRacecourse(
                                                  boxIndex, racecourse),
                                      currentRaceCourseChoice:
                                          '${selectedRacecourseMap[boxIndex]}',
                                      currentRaceCourseTypeChoice:
                                          '${selectedRacecourseTypeMap[boxIndex]}',
                                      onRacecourseTypeSelected:
                                          (String racecourseType) {
                                        widget.viewModel
                                            .setSelectedRacecourseType(
                                                boxIndex, racecourseType);
                                      },
                                      allRacecourses: List<String>.from(widget
                                          .viewModel.allItems
                                          .where((item) =>
                                              item['Racecourse Type'] ==
                                              selectedRacecourseTypeMap[
                                                  boxIndex])
                                          .map((item) =>
                                              item['Racecourse'] ?? '')
                                          .toSet()
                                          .toList()),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.tablecontentBgColor
                                            .withValues(alpha: 0.7),
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.brown,
                                        ),
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Center(
                                          child: selectedRacecourseMap
                                                  .isNotEmpty
                                              ? Text(
                                                  racecourseName.isNotEmpty
                                                      ? racecourseName
                                                      : selectedRacecourseMap[
                                                          boxIndex],
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      AppFonts.titleRaceCourse,
                                                )
                                              : Text(
                                                  "No Data Available",
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      AppFonts.titleRaceCourse,
                                                ),
                                        ),
                                      ),
                                    ),
                                    FinishingPort(
                                      winddata: widget.viewModel.windData,
                                      direction: widget.viewModel.direction,
                                      lengthData: widget.viewModel.lengthData,
                                      isFromHome: true,
                                      hideWindColumn: true,
                                      selectedRacecourseData: racecourseData,
                                      showUpgradeButton: false,
                                      groundColor: groundType['color'],
                                      groundName: groundType['type'],
                                      showWeatherIcon: false,
                                    ),
                                    if (racecourseWidthData != null &&
                                        racecourseWidthData.isNotEmpty)
                                      Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.4,
                                          padding:
                                              EdgeInsets.symmetric(vertical: 1),
                                          decoration: BoxDecoration(
                                            color: Apputils()
                                                .hexToColor(racecourseWidthData[
                                                    'ColorCode'])
                                                .withValues(alpha: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Text(
                                            '${racecourseWidthData['Width Type']}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                          )),
                                    Consumer<RacecourseRepository>(
                                      builder: (context, provider, child) {
                                        return DirectionRacecourse(
                                          selectedRacecourse: provider.allItems
                                              .firstWhere((item) =>
                                                  item['Racecourse'] ==
                                                      selectedRacecourseMap[
                                                          boxIndex] &&
                                                  item['Racecourse Type'] ==
                                                      selectedRacecourseTypeMap[
                                                          boxIndex]),
                                          winddata: widget.viewModel.windData,
                                          direction: widget.viewModel.direction,
                                          isFromHome: true,
                                          lengthData:
                                              widget.viewModel.firstTurnData,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
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
                                  color: Colors.deepPurple.withAlpha(230),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(Icons.chevron_left,
                                    size: 22, color: Colors.white),
                              ),
                              onPressed: _currentPage > 0
                                  ? () => _pageController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 300),
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
                                  color: Colors.deepPurple.withAlpha(230),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(Icons.chevron_right,
                                    size: 22, color: Colors.white),
                              ),
                              onPressed: _currentPage < 2
                                  ? () => _pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      )
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }
}
