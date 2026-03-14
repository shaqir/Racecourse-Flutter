import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/ui/core/theme/appcolors.dart';
import 'package:racecourse_tracks/ui/core/ui/lengthstatuscontainer.dart';
import 'package:racecourse_tracks/data/repositories/settings_repository.dart';
import 'package:racecourse_tracks/ui/core/ui/wind_arrow.dart';

class DirectionRacecourse extends StatefulWidget {
  final List<Map<String, dynamic>> winddata;
  final List<Map<String, dynamic>> direction;
  final List<Map<String, dynamic>> lengthData;
  final bool isFromHome;
  final Map<String, dynamic> selectedRacecourse;

  const DirectionRacecourse(
      {super.key,
      required this.winddata,
      required this.direction,
      required this.isFromHome,
      required this.selectedRacecourse,
      required this.lengthData});

  @override
  State<DirectionRacecourse> createState() => _DirectionRacecourse();
}

class _DirectionRacecourse extends State<DirectionRacecourse> {
  late final List<Map<String, dynamic>> lengthdata = widget.lengthData;
  List<Map<String, dynamic>> windDirectionData = [];

  @override
  void initState() {
    super.initState();
    
  }

  void _addDynamicWindData(Map<String, dynamic> selectedRacecourse) {
    windDirectionData.clear();

    if (selectedRacecourse.isEmpty) {
      return;
    }

    for (int i = 1;; i++) {
      String courseKey = 'course$i';
      String turnKey = '1st turn$i';
      String rel = 'Rel$i';

      if (selectedRacecourse[courseKey] != null &&
          selectedRacecourse[turnKey] != null) {
        // if (selectedRacecourse[courseKey] == '') {
        //   return;
        // }

        var courseData = getTurnData('${selectedRacecourse[courseKey]}');
        var turnData = getTurnData('${selectedRacecourse[turnKey]}');

        // Skip adding if either courseData or turnData is null
        if (courseData.contains("null") || turnData.contains("null")) {
          return;
        }

        windDirectionData.add({
          "raceid": windDirectionData.length + 1,
          "course": getTurnData('${selectedRacecourse[courseKey]}'),
          "direction": double.parse('${selectedRacecourse[rel] ?? '0'}'),
          "1stTurn": getTurnData('${selectedRacecourse[turnKey]}'),
          "colorCode":
              '${getLengthData(safeParseInt('${selectedRacecourse[turnKey]}'), '${selectedRacecourse['Racecourse Type']}')?['ColorCode']}',
          "Length":
              '${getLengthData(safeParseInt('${selectedRacecourse[turnKey]}'), '${selectedRacecourse['Racecourse Type']}')?['Length Type']}',
        });
      } else {
        break; // Exit the loop if the keys are not found
      }
    }
  }

  int safeParseInt(String? value, {int defaultValue = 0}) {
    try {
      if (value == null || value.isEmpty) {
        return defaultValue;
      }
      return double.parse(value).toInt(); // Convert float to int safely
    } catch (e) {
      return defaultValue;
    }
  }

  String getTurnData(String turndata) {
    if (!turndata.contains('m')) {
      return turndata.split('.').first += ' m';
    } else {
      return turndata;
    }
  }

  Map<String, dynamic>? getLengthData(int turn, String racecourseType) {
    for (var data in lengthdata) {
      if (racecourseType == data['RacecourseType'] &&
          turn >= safeParseInt(data['Min'].toString()) &&
          turn <= safeParseInt(data['Max'].toString())) {
        return data; // Return the first match
      }
    }
    return null; // If no match is found
  }

  // direct1

  @override
  Widget build(BuildContext context) {
    _addDynamicWindData(widget.selectedRacecourse);
    return Align(
      alignment: Alignment.center,
      child: Container(
        height:
            windDirectionData.isEmpty ? 0 : 106 + windDirectionData.length * 35,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.silverdataColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              width: 0.5, //
              color: AppColors.primaryDarkBlueColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 35.0,
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              decoration: BoxDecoration(
                color: AppColors.tabletitleBgColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  'Common Courses with Lengths to 1st Turn',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SourceSansVariable',
                  ),
                ),
              ),
            ),
            Container(
              height: 35.0,
              decoration: BoxDecoration(
                color: AppColors.tablecontentBgColor.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    width: 0.5, //
                    color: Colors.brown),
              ),
              child: const Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  // Flexible(
                  //   flex: 1,
                  //   child: Align(
                  //     alignment: Alignment.center,
                  //     child: FittedBox(
                  //       fit: BoxFit.contain,
                  //       child: Text(
                  //         'Race',
                  //         maxLines: 1,
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //           color: Colors.black87,
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w600,
                  //           fontFamily: 'SourceSansVariable',
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Flexible(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Distances',
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SourceSansVariable',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Direction',
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SourceSansVariable',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.center, // Change this line
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'To 1st Turn Lengths',
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SourceSansVariable',
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Flexible(
                  //   flex: 3,
                  //   child: Align(
                  //     alignment: Alignment.center,
                  //     child: FittedBox(
                  //       fit: BoxFit.contain,
                  //       child: Text(
                  //         'Lengths',
                  //         maxLines: 1,
                  //         textAlign: TextAlign.left,
                  //         style: TextStyle(
                  //           color: Colors.black87,
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w600,
                  //           fontFamily: 'SourceSansVariable',
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            Column(
              children: List.generate(windDirectionData.length, (index) {
                return SizedBox(
                  height: 35,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 34,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            // Flexible(
                            //   flex: 1,
                            //   child: Align(
                            //     alignment: Alignment.center,
                            //     child: FittedBox(
                            //       fit: BoxFit.contain,
                            //       child: Text(
                            //         windDirectionData[index]["raceid"]
                            //             .toString(),
                            //         maxLines: 1,
                            //         textAlign: TextAlign.center,
                            //         style: TextStyle(
                            //           color: Colors.grey[800],
                            //           fontSize: 14.0,
                            //           fontWeight: FontWeight.w500,
                            //           fontFamily: 'SourceSansVariable',
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // // const VerticalDivider(
                            // //   thickness: 1.0,
                            // //   color: Colors.white,
                            // // ),
                            // const SizedBox(
                            //   width: 8,
                            // ),
                            Consumer<SettingsRepository>(
                                builder: (context, settingsProvider, child) {
                              return Flexible(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      settingsProvider.formatDistance(
                                          double.tryParse(
                                                  windDirectionData[index]
                                                          ['course']
                                                      .replaceAll(' m', '')) ??
                                              0.0),
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'SourceSansVariable',
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                            const VerticalDivider(
                              thickness: 1.0,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.center,
                                child: WindArrow(
                                  angle: windDirectionData[index]['direction'],
                                  color: AppColors.primaryDarkBlueColor,
                                ),
                              ),
                            ),
                            const VerticalDivider(
                              thickness: 1.0,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Consumer<SettingsRepository>(
                                builder: (context, settingsProvider, child) {
                              return Flexible(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      settingsProvider.formatDistance(
                                          double.tryParse(
                                                  windDirectionData[index]
                                                          ['1stTurn']
                                                      .replaceAll(' m', '')) ??
                                              0.0),
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'SourceSansVariable',
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(
                              width: 8,
                            ),
                            // const VerticalDivider(
                            //   thickness: 1.0,
                            //   color: Colors.white,
                            // ),
                            LengthStatusContainer(
                              statusString: windDirectionData[index]["Length"],
                              colorCode: windDirectionData[index]["colorCode"],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 1.0,
                        height: 1,
                        color: Colors.white,
                        indent: 1.0,
                        endIndent: 1.0,
                      ),
                    ],
                  ),
                );
              }),
            ),
            Container(
              height: 35.0,
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              decoration: BoxDecoration(
                color: AppColors.tabletitleBgColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  'Directions Relative to Home Straight',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SourceSansVariable',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
