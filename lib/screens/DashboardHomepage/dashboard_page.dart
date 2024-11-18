import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:racecourse_tracks/core/appcolors.dart';
import 'package:racecourse_tracks/core/appimages.dart';
import 'package:racecourse_tracks/screens/DashboardHomepage/lengthstatuscontainer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool value = false;
  String title = "";
  String Selected = "";
  int start1 = 0;
  int end1 = 4;
  int start2 = 5;
  int end2 = 9;
  int start3 = 10;
  int end3 = 14;

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
  void initState() {
    super.initState();
    title = checkListItems[0]["title"];
  }

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
              Container(
                height: 250.0,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryDarkBlueColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Finishing Post',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Container(
                                height: 150.0,
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.rectangleBoxColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Length',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      Divider(
                                        thickness: 1.0,
                                        color: Colors.white,
                                        indent: 4.0,
                                        endIndent: 4.0,
                                      ),
                                      Text(
                                        'Calm',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Divider(
                                        thickness: 1.0,
                                        color: Colors.white,
                                        indent: 4.0,
                                        endIndent: 4.0,
                                      ),
                                      Text(
                                        '380 m',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Divider(
                                        thickness: 1.0,
                                        color: Colors.white,
                                        indent: 4.0,
                                        endIndent: 4.0,
                                      ),
                                      Text(
                                        'Long Medium',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Center(
                                child: Container(
                                  height: 150.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 1.0,
                                    ),
                                  ),
                                  child: const Image(
                                    image:
                                        AssetImage(AppImages.upArrowIconImage),
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Container(
                                height: 150.0,
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.rectangleBoxColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Wind',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      Divider(
                                        thickness: 1.0,
                                        color: Colors.white,
                                        indent: 4.0,
                                        endIndent: 4.0,
                                      ),
                                      Text(
                                        'Calm',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Divider(
                                        thickness: 1.0,
                                        color: Colors.white,
                                        indent: 4.0,
                                        endIndent: 4.0,
                                      ),
                                      Text(
                                        '↘',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Divider(
                                        thickness: 1.0,
                                        color: Colors.white,
                                        indent: 4.0,
                                        endIndent: 4.0,
                                      ),
                                      Text(
                                        '5.4km/h',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Stack(
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
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                                                  windData[index]["raceid"]
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
                                                  windData[index]["course"],
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
                                                  windData[index]["direction"],
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    color: AppColors
                                                        .primaryDarkBlueColor,
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
                                                  windData[index]["1stTurn"],
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
                                            LengthStatusContainer(statusString: windData[index]["Length"]),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
