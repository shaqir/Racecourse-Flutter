import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/appcolors.dart';

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

  @override
  void initState() {
    super.initState();
    title = checkListItems[0]["title"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryLightBgColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 50),
                height: 50.0,
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
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
                              height: 45,
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
                              height: 45,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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
                              height: 45,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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
                height: 300.0,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryDarkBlueColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text(
                    'Finishing Point Content',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 330.0,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Center(
                      child: Text(
                        'Finishing Point Content',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    top: 30,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 300.0,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLightBgColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Center(
                          child: Text(
                            'Table Content',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                            ),
                          ),
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
