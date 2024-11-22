import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/common/appmenubuttontitles.dart';

class SelectedRacecourseList extends StatefulWidget {
  const SelectedRacecourseList({super.key});

  @override
  State<SelectedRacecourseList> createState() => _SelectedRacecourseListState();
}

class _SelectedRacecourseListState extends State<SelectedRacecourseList> {
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
    return SizedBox(
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
                        Text(AppMenuButtonTitles.select,
                            textAlign: TextAlign.left, style: AppFonts.body1),
                        SizedBox(
                          width: 8,
                        ),
                        Text(AppMenuButtonTitles.racecourse,
                            textAlign: TextAlign.left, style: AppFonts.body1),
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
                                activeColor: AppColors.checkboxlist1Color,
                                side: const BorderSide(
                                    color: AppColors.checkboxlist1Color,
                                    width: 2),
                                dense: true,
                                title: Text(
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  checkListItems[value1]["title"],
                                  style: AppFonts.body,
                                ),
                                value: checkListItems[value1]["value"],
                                onChanged: (value) {
                                  setState(() {
                                    for (var element in checkListItems) {
                                      element["value"] = false;
                                    }
                                    checkListItems[value1]["value"] = value;
                                    Selected =
                                        "${checkListItems[value1]["id"]}, ${checkListItems[value1]["title"]}, ${checkListItems[value1]["value"]}";
                                    title = checkListItems[value1]["title"];
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
                        Text(AppMenuButtonTitles.select, style: AppFonts.body1),
                        SizedBox(
                          width: 8,
                        ),
                        Text(AppMenuButtonTitles.racecourse,
                            style: AppFonts.body1),
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
                                activeColor: AppColors.checkboxlist2Color,
                                side: const BorderSide(
                                    color: AppColors.checkboxlist2Color,
                                    width: 2),
                                dense: true,
                                title: Text(
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  checkListItems[value2]["title"],
                                  style: AppFonts.body,
                                ),
                                value: checkListItems[value2]["value"],
                                onChanged: (value) {
                                  setState(() {
                                    for (var element in checkListItems) {
                                      element["value"] = false;
                                    }
                                    checkListItems[value2]["value"] = value;
                                    Selected =
                                        "${checkListItems[value2]["id"]}, ${checkListItems[value2]["title"]}, ${checkListItems[value2]["value"]}";
                                    title = checkListItems[value2]["title"];
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
                        Text(AppMenuButtonTitles.select, style: AppFonts.body1),
                        SizedBox(
                          width: 8,
                        ),
                        Text(AppMenuButtonTitles.racecourse,
                            style: AppFonts.body1),
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
                                activeColor: AppColors.checkboxlist3Color,
                                side: const BorderSide(
                                    color: AppColors.checkboxlist3Color,
                                    width: 2),
                                dense: true,
                                title: Text(
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  checkListItems[value3]["title"],
                                  style: AppFonts.body,
                                ),
                                value: checkListItems[value3]["value"],
                                onChanged: (value) {
                                  setState(() {
                                    for (var element in checkListItems) {
                                      element["value"] = false;
                                    }
                                    checkListItems[value3]["value"] = value;
                                    Selected =
                                        "${checkListItems[value3]["id"]}, ${checkListItems[value3]["title"]}, ${checkListItems[value3]["value"]}";
                                    title = checkListItems[value3]["title"];
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
    );
  }
}
