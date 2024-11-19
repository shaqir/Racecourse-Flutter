import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/appcolors.dart';
import 'package:racecourse_tracks/core/firestoreservice.dart';
import 'package:racecourse_tracks/screens/DashboardHomepage/lengthstatuscontainer.dart';

class DirectionRacecourse extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> winddata;
  final List<Map<String, dynamic>> direction;

  const DirectionRacecourse({
    Key? key,
    required this.users,
    required this.winddata,
    required this.direction,
  }) : super(key: key);

  @override
  _DirectionRacecourse createState() => _DirectionRacecourse();
}

class _DirectionRacecourse extends State<DirectionRacecourse> {
  List<Map<String, dynamic>> windDirectionData = [];

  final List<Map<String, dynamic>> lengthdata = FirestoreService.lengthdata;

  Map<String, dynamic> user = {};
  void addDynamicWindData() {
    if (widget.users.isNotEmpty && widget.users.length > 1) {
      user = widget.users[25];
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
        setState(() {
          windDirectionData.add({
            "raceid": windDirectionData.length + 1,
            "course": '${user[courseKey]} m',
            "direction": '${findDirectionData(
              '${user[direct]}',
              '${user[rel]}',
              widget.direction,
            )?["ASCII Arrow"]}',
            "1stTurn": '${user[turnKey]} m',
            "Length":
                '${getLengthData(int.parse('${user[turnKey]}'), '${user['Racecourse Type']}')?['Length Type']}',
          });
        });
      }
    }
  }

  Map<String, dynamic>? getLengthData(int turn, String racecourseType) {
    for (var data in lengthdata) {
      if (racecourseType == data['RacecourseType'] &&
          turn >= data['Min'] &&
          turn <= data['Max']) {
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
      return null; // Return null if invalid data
    }

    // Iterate through directionData to find matching entry
    for (var item in directionData) {
      // Ensure that 'Angle' and 'Direction' exist in the map

      double itemangle = item['Angle'] is double
          ? item['Angle'].ceilToDouble()
          : double.parse(item['Angle'].toString()).ceilToDouble();

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

    return {"Direction": "ENE"}; // Return default value if no match is found
  }

  // direct1

  @override
  Widget build(BuildContext context) {
    final user = widget.users[25];

    addDynamicWindData();

    // print(user);
    return Stack(
      children: [
        Container(
          height: 450.0,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.lableyellowBgColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Padding(
            padding: EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last Update 18/11/2024',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  'Time: 10:15:50',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned.fill(
          top: 30,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: 420.0,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.tablecontentBgColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 40.0,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(
                      color: AppColors.tabletitleBgColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Race',
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Course',
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 0,
                        ),
                        Flexible(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Direction',
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '1st Turn',
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Length',
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
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
                                      child: Text(
                                        windDirectionData[index]["raceid"]
                                            .toString(),
                                        maxLines: 1,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
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
                                        '${windDirectionData[index]['course']} m',
                                        maxLines: 1,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
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
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${windDirectionData[index]['direction']}',
                                        maxLines: 1,
                                        style: const TextStyle(
                                          color: AppColors.primaryDarkBlueColor,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
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
                                        '${windDirectionData[index]['1stTurn']}',
                                        maxLines: 1,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
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
                                      statusString: windDirectionData[index]
                                          ["Length"]),
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
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
