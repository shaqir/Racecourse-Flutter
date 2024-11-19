import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/appcolors.dart';
import 'package:racecourse_tracks/core/firestoreservice.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/direction_racecourse.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/finishing_port.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _winddata = [];
  List<Map<String, dynamic>> _direction = [];

  bool value = false;
  String title = "";
  String Selected = "";
  int start1 = 0;
  int end1 = 4;
  int start2 = 5;
  int end2 = 9;
  int start3 = 10;
  int end3 = 14;

  @override
  void initState() {
    super.initState();
    title = checkListItems[0]["title"];
    // _fetchUsers();
    // _fetchWinddata();
    // _fetchDirectiondata();
  }

  // void _fetchUsers() {
  //   _firestoreService.getUsers().listen((user) {
  //     setState(() {
  //       _users = user;
  //     });
  //   });
  // }

  // void _fetchWinddata() {
  //   _firestoreService.getWinddata().listen((winddata) {
  //     setState(() {
  //       _winddata = winddata;
  //     });
  //   });
  // }

  // void _fetchDirectiondata() {
  //   _firestoreService.getDirectiondata().listen((directiondata) {
  //     setState(() {
  //       _direction = directiondata;
  //     });
  //   });
  // }

  List checkListItems = [
    {
      "id": 0,
      "value": true,
      "title": "Ascot",
    },
    {
      "id": 1,
      "value": false,
      "title": "Darwin",
    },
    {
      "id": 2,
      "value": false,
      "title": "Albany",
    },
    {
      "id": 3,
      "value": false,
      "title": "Gundagai",
    },
    {
      "id": 4,
      "value": false,
      "title": "Toowoomba",
    },
    {
      "id": 5,
      "value": false,
      "title": "Caulfield",
    },
    {
      "id": 6,
      "value": false,
      "title": "SunShine Coast",
    },
    {
      "id": 7,
      "value": false,
      "title": "Dunkeld",
    },
    {
      "id": 8,
      "value": false,
      "title": "Kembla Grange",
    },
    {
      "id": 9,
      "value": false,
      "title": "Tauranga",
    },
    {
      "id": 10,
      "value": false,
      "title": "NewCastle",
    },
    {
      "id": 11,
      "value": false,
      "title": "Morphetville",
    },
    {
      "id": 12,
      "value": false,
      "title": "Bathrust",
    },
    {
      "id": 13,
      "value": false,
      "title": "Ipswitch",
    },
    {
      "id": 14,
      "value": false,
      "title": "RicartonPark",
    },
  ];
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: AppColors.primaryBgColor1,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 0),
              SizedBox(
                height: 225,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Container(
                              color: AppColors.selectedDarkBrownColor,
                              height: 40,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text('Select',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text('Racecourse',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  end1 - start1 + 1,
                                  (index) {
                                    int value1 = start1 + index;
                                    return SizedBox(
                                      height: 35,
                                      child: ListTileTheme(
                                        horizontalTitleGap: 8,
                                        minLeadingWidth: 0,
                                        child: CheckboxListTile(
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          checkColor: Colors.white,
                                          activeColor:
                                              AppColors.checkboxlist1Color,
                                          side: const BorderSide(
                                              color:
                                                  AppColors.checkboxlist1Color,
                                              width: 2),
                                          dense: true,
                                          title: Text(
                                            textAlign: TextAlign.left,
                                            maxLines: 1,
                                            checkListItems[value1]["title"],
                                            style: const TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          value: checkListItems[value1]
                                              ["value"],
                                          onChanged: (value) {
                                            setState(() {
                                              for (var element
                                                  in checkListItems) {
                                                element["value"] = false;
                                              }
                                              checkListItems[value1]["value"] =
                                                  value;
                                              Selected =
                                                  "${checkListItems[value1]["id"]}, ${checkListItems[value1]["title"]}, ${checkListItems[value1]["value"]}";
                                              title = checkListItems[value1]
                                                  ["title"];
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Container(
                              color: AppColors.selectedDarkBrownColor,
                              height: 40,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text('Select',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text('Racecourse',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  end2 - start2 + 1,
                                  (index) {
                                    int value2 = start2 + index;
                                    return SizedBox(
                                      height: 35,
                                      child: ListTileTheme(
                                        horizontalTitleGap: 8,
                                        minLeadingWidth: 0,
                                        child: CheckboxListTile(
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          checkColor: Colors.white,
                                          activeColor:
                                              AppColors.checkboxlist2Color,
                                          side: const BorderSide(
                                              color:
                                                  AppColors.checkboxlist2Color,
                                              width: 2),
                                          dense: true,
                                          title: Text(
                                            textAlign: TextAlign.left,
                                            maxLines: 1,
                                            checkListItems[value2]["title"],
                                            style: const TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          value: checkListItems[value2]
                                              ["value"],
                                          onChanged: (value) {
                                            setState(() {
                                              for (var element
                                                  in checkListItems) {
                                                element["value"] = false;
                                              }
                                              checkListItems[value2]["value"] =
                                                  value;
                                              Selected =
                                                  "${checkListItems[value2]["id"]}, ${checkListItems[value2]["title"]}, ${checkListItems[value2]["value"]}";
                                              title = checkListItems[value2]
                                                  ["title"];
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Container(
                              color: AppColors.selectedDarkBrownColor,
                              height: 40,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text('Select',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text('Racecourse',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(
                                  end3 - start3 + 1,
                                  (index) {
                                    int value3 = start3 + index;
                                    return SizedBox(
                                      height: 35,
                                      child: ListTileTheme(
                                        horizontalTitleGap: 8,
                                        minLeadingWidth: 0,
                                        child: CheckboxListTile(
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          checkColor: Colors.white,
                                          activeColor:
                                              AppColors.checkboxlist3Color,
                                          side: const BorderSide(
                                              color:
                                                  AppColors.checkboxlist3Color,
                                              width: 2),
                                          dense: true,
                                          title: Text(
                                            textAlign: TextAlign.left,
                                            maxLines: 1,
                                            checkListItems[value3]["title"],
                                            style: const TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          value: checkListItems[value3]
                                              ["value"],
                                          onChanged: (value) {
                                            setState(() {
                                              for (var element
                                                  in checkListItems) {
                                                element["value"] = false;
                                              }
                                              checkListItems[value3]["value"] =
                                                  value;
                                              Selected =
                                                  "${checkListItems[value3]["id"]}, ${checkListItems[value3]["title"]}, ${checkListItems[value3]["value"]}";
                                              title = checkListItems[value3]
                                                  ["title"];
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FinishingPort(
                users: FirestoreService.users,
                winddata: FirestoreService.winddata,
                direction: FirestoreService.direction,
              ),
              DirectionRacecourse(
                users: FirestoreService.users,
                winddata: FirestoreService.winddata,
                direction: FirestoreService.direction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
