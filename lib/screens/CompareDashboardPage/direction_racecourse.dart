import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/appcolors.dart';
import 'package:racecourse_tracks/screens/DashboardHomepage/lengthstatuscontainer.dart';

class DirectionRacecourse extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> winddata;
  const DirectionRacecourse(
      {Key? key, required this.users, required this.winddata})
      : super(key: key);

  @override
  _DirectionRacecourse createState() => _DirectionRacecourse();
}

class _DirectionRacecourse extends State<DirectionRacecourse> {
  List windData = [
    {
      "raceid": 1,
      "course": "1000m",
      "direction": "↗",
      "1stTurn": "200m",
      "Length": "Medium",
    },
    {
      "raceid": 2,
      "course": "1200m",
      "direction": "↖",
      "1stTurn": "200m",
      "Length": "Short",
    },
    {
      "raceid": 3,
      "course": "1300m",
      "direction": "←",
      "1stTurn": "300m",
      "Length": "Medium",
    },
    {
      "raceid": 4,
      "course": "1400m",
      "direction": "↘",
      "1stTurn": "300m",
      "Length": "Medium",
    },
    {
      "raceid": 5,
      "course": "1500m",
      "direction": "↗",
      "1stTurn": "400m",
      "Length": "Long Medium",
    },
    {
      "raceid": 5,
      "course": "2000m",
      "direction": "→",
      "1stTurn": "300m",
      "Length": "Very Short",
    },
    {
      "raceid": 7,
      "course": "2000m",
      "direction": "↖",
      "1stTurn": "300m",
      "Length": "Very Short",
    },
    {
      "raceid": 8,
      "course": "2300m",
      "direction": "↗",
      "1stTurn": "300m",
      "Length": "Very Short",
    },
    {
      "raceid": 9,
      "course": "2300m",
      "direction": "↙",
      "1stTurn": "300m",
      "Length": "Very Short",
    },
    {
      "raceid": 10,
      "course": "2600m",
      "direction": "↗",
      "1stTurn": "300m",
      "Length": "Very Short",
    },
  ];
  @override
  Widget build(BuildContext context) {
    final user = widget.users[1];
    print(user);
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
                    children: List.generate(10, (index) {
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
                                        windData[index]["raceid"].toString(),
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
                                        '${user['course1']} m',
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
                                        '${user['course1']} m',
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
                                        '${user['1st turn1']} m',
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
                                      statusString: windData[index]["Length"]),
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
