import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/utility/firestoreservice.dart';
import 'package:racecourse_tracks/core/utility/dataprovider.dart';
import 'package:racecourse_tracks/core/utility/lengthstatuscontainer.dart';

// ignore: must_be_immutable
class DirectionRacecourse extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> winddata;
  final List<Map<String, dynamic>> direction;
  bool isFromHome;

  DirectionRacecourse({
    Key? key,
    required this.users,
    required this.winddata,
    required this.direction,
    required this.isFromHome,
  }) : super(key: key);

  @override
  _DirectionRacecourse createState() => _DirectionRacecourse();
}

class _DirectionRacecourse extends State<DirectionRacecourse> {
  final List<Map<String, dynamic>> lengthdata = FirestoreService.lengthdata;
  List<Map<String, dynamic>> windDirectionData = [];

  Map<String, dynamic> user = {};

  void addDynamicWindData(String racecourseName, String racesourseType) {
    windDirectionData.clear();

    if (widget.users.isNotEmpty && widget.users.length > 1) {
      user = widget.users.firstWhere(
        (u) =>
            u['Racecourse'] == racecourseName &&
            u['Racecourse Type'] == racesourseType,
        orElse: () => {},
      );
    } else {
      print("widget.users is empty or does not have enough elements.");
      return;
    }

    for (int i = 1; i <= 10; i++) {
      String courseKey = 'course$i';
      String turnKey = '1st turn$i';
      String direct = 'DirRel$i';
      String rel = 'Rel$i';

      if (user.containsKey(courseKey) && user.containsKey(turnKey)) {
        if(user[courseKey] == ''){
          return;
        }
        setState(() {
          windDirectionData.add({
            "raceid": windDirectionData.length + 1,
            "course": getTurnData('${user[courseKey]}'),
            "direction": '${findDirectionData(
              '${user[direct]}',
              '${user[rel]}',
              widget.direction,
            )?["ASCII Arrow"] ?? '-'}',
            "1stTurn": getTurnData('${user[turnKey]}'),
            "colorCode":
                '${getLengthData(safeParseInt('${user[turnKey]}'), '${user['Racecourse Type']}')?['ColorCode']}',
            "Length":
                '${getLengthData(safeParseInt('${user[turnKey]}'), '${user['Racecourse Type']}')?['Length Type']}',
          });
        });
      }
    }
  }

  int safeParseInt(String? value, {int defaultValue = 0}) {
  try {
    if (value == null || value.isEmpty) {
      return defaultValue;
    }
    return int.parse(value);
  } catch (e) {
    return defaultValue;
  }
}

  String getTurnData(String turndata) {
    if (!turndata.contains('m')) {
      return turndata += ' m';
    } else {
      return turndata;
    }
  }

  Map<String, dynamic>? getLengthData(int turn, String racecourseType) {
    for (var data in lengthdata) {
      if (racecourseType == data['RacecourseType'] &&
          turn >=  int.parse(data['Min']) &&
          turn <= int.parse(data['Max'])) {
        return data; // Return the first match
      }
    }
    return null; // If no match is found
  }

  static Map<String, dynamic>? findDirectionData(
    String direction,
    String angle,
    List<Map<String, dynamic>> directionData,
  ) {
    // Validate inputs before proceeding
    if (direction.isEmpty || angle.isEmpty || directionData.isEmpty) {
      print("Invalid input: direction, angle, or directionData is empty");
      print('direction $direction');
      print('angle $angle');
      print('directionData $directionData');
      
      return null; // Return null if invalid data
    }

    double customCeil(double value) {
      return value.isNegative
          ? -value.abs().ceilToDouble()
          : value.ceilToDouble();
    }

    // Iterate through directionData to find matching entry
    for (var item in directionData) {
      // Ensure that 'Angle' and 'Direction' exist in the map

      double itemangle = item['Angle'] != null
          ? (item['Angle'] is double
              ? customCeil(item['Angle'])
              : customCeil(double.parse(item['Angle'].toString())))
          : 0.0; // Default value

      //print("ITEM ANGLE : ${itemangle}");
      //print("ANGLE  come from USER: ${angle}");
      if (item.containsKey('Angle') && item.containsKey('Direction')) {
        try {
          if ((itemangle) == (double.parse(angle)) &&
              (item['Direction'].toString()) == (direction)) {
            // if ((item['Direction'].toString()) == (direction)) {
            return item; // Return the matched item
          }
        } catch (e) {
          print("Error comparing data: $e");
          continue; // In case of error, continue with the next item
        }
      }
    }

    return {"ASCII Arrow": ""}; // Return default value if no match is found
  }

  // direct1

  @override
  Widget build(BuildContext context) {
    String selectedRacecourse = '';
    String selectedRacecourseType = '';

    // if (!widget.isFromHome) {
    String? val = DataProvider.of(context).selectedRacecourse;
    String? val1 = DataProvider.of(context).selectedRacecourseType;
    selectedRacecourse = val ?? '';
    selectedRacecourseType = val1 ?? '';
    // }

    addDynamicWindData(
      selectedRacecourse,
      selectedRacecourseType,
    );

    user = widget.users.firstWhere(
      (u) =>
          u['Racecourse'] == selectedRacecourse &&
          u['Racecourse Type'] == selectedRacecourseType,
      orElse: () => {},
    );
    ;

    return Align(
      alignment: Alignment.center,
      child: Container(
        height: windDirectionData.length == 0
            ? 0
            : 106 + windDirectionData.length * 35,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.tablecontentBgColor,
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
                color: AppColors.tablecontentBgColor.withOpacity(0.75),
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
                  Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Race',
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
                        child: Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Text(
                            'Course',
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
                  ),
                  
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Padding(
                          padding: EdgeInsets.only(left: 2),
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
                  ),
                  
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            '1st Turn',
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
                  ),
               
                  Flexible(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Length',
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
                  )
                ],
              ),
            ),
            Column(
              children: List.generate(windDirectionData.length, (index) {
                return SizedBox(
                  height: 35,
                  child: Column(
                    children: [
                      Container(
                        height: 34,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.center,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    windDirectionData[index]["raceid"]
                                        .toString(),
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'SourceSansVariable',
                                    ),
                                  ),
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
                            Flexible(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.center,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    '${windDirectionData[index]['course'] ?? ''}',
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'SourceSansVariable',
                                    ),
                                  ),
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
                            Flexible(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '${windDirectionData[index]['direction'].isEmpty ? '-' : windDirectionData[index]['direction'] ?? '-'}',
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppColors.primaryDarkBlueColor,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SourceSansVariable',
                                  ),
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
                            Flexible(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.center,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    '${windDirectionData[index]['1stTurn'] ?? ''}',
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'SourceSansVariable',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const VerticalDivider(
                              thickness: 1.0,
                              color: Colors.white,
                            ),
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
