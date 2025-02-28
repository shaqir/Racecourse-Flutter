import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/common/appimages.dart';
import 'package:racecourse_tracks/core/common/appmenubuttontitles.dart';
import 'package:racecourse_tracks/core/utility/apputils.dart';
import 'package:racecourse_tracks/core/utility/firestoreservice.dart';
import 'package:racecourse_tracks/core/utility/getwindquality.dart';

class FinishingPort extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> winddata;
  final List<Map<String, dynamic>> direction;
  final String selectedRacecourse;
  final String selectedRacecourseType;
  bool isFromHome = false;

  FinishingPort(
      {Key? key,
      required this.users,
      required this.winddata,
      required this.direction,
      required this.isFromHome,
      required this.selectedRacecourse,
      required this.selectedRacecourseType})
      : super(key: key);

  @override
  _FinishingPortState createState() => _FinishingPortState();
}

class _FinishingPortState extends State<FinishingPort> {
  final List<Map<String, dynamic>> lengthdata = FirestoreService.lengthdata;

  @override
  Widget build(BuildContext context) {
    String selectedRacecourse = widget.selectedRacecourse;
    String selectedRacecourseType = widget.selectedRacecourseType;

    Map<String, dynamic>? user = widget.users.firstWhere(
      (u) =>
          u['Racecourse'] == selectedRacecourse &&
          u['Racecourse Type'] == selectedRacecourseType,
      orElse: () => {},
    );

    String windSpeed =
        user.containsKey('Wind Speed') && user['Wind Speed'] != null
            ? user['Wind Speed'].toString()
            : '';

    String homeData = (user.isNotEmpty &&
            user['Home'] != null &&
            user['Home'].toString().trim().isNotEmpty)
        ? user['Home'].toString()
        : '-';

    var result =
        GetWindQuality().getWindQualityFromSpeed(windSpeed, widget.winddata);

    String windRelHomeArrow = user.containsKey('WindRel_HomeArrow') &&
            user['WindRel_HomeArrow'] != null
        ? user['WindRel_HomeArrow'].toString()
        : '-';

    String straight = user.containsKey('Straight') && user['Straight'] != null
        ? user['Straight'].toString()
        : '';

    String size = Apputils().removeTrailingSpace(
        user.containsKey('Size') && user['Size'] != null
            ? user['Size'].toString()
            : '');

    Map<String, dynamic>? getLengthColor(String racecourseType) {
      // print("Size : ${size}");
      // print("racecourseType : ${racecourseType}");
      for (var data in lengthdata) {
        // print("RacecourseType : ${data['RacecourseType']}");
        // print("Length Type : ${data['Length Type']}");
        if (racecourseType == data['RacecourseType'] &&
            size == data['Length Type']) {
          // print("Color : ${data}");
          return data; // Return the first match
        }
      }
      return null; // Return null if no match is found
    }

    Map<String, dynamic>? getWindColor(String windType) {
      for (var data in widget.winddata) {
        if (windType == data['Wind Quality'])
          return data; // Return the first match
      }
      return null;
    }

    // print("MY : ${user}");
    Color lengthColor = Colors.transparent;
    // if (!user.isEmpty) {
    lengthColor = Apputils()
        .hexToColor((getLengthColor(user["Racecourse Type"])?["ColorCode"]
                ?.toString() ??
            "#000000"))
        .withOpacity(0.5);
    // }

    Color windColor = Apputils().hexToColor(
        getWindColor(result['quality'])?["colorcode"].toString() ?? "#000000");

    Color getGroundColor(String groundType) {
      if (groundType == "S") {
        return Color(0xffededed).withOpacity(1);
      } else if (groundType == "G") {
        return Color(0xffa9d08e).withOpacity(1);
      } else if (groundType == "P") {
        return Color(0xffe6b8af).withOpacity(1);
      }
      return Color(0xff454545).withOpacity(0.75);
    }

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: getGroundColor(user['Type']),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          width: 0.5,
          color: AppColors.primaryDarkBlueColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 6),
            const Text(
              AppMenuButtonTitles.finishingpost,
              style: AppFonts.caption1,
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.tablecontentBgColor,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          width: 0.25, //
                          color: Colors.brown),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'Home Straight\nLength',
                              style: AppFonts.body2_1,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                            ),
                          ),
                          Divider(color: Colors.white, thickness: 1.0),
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              '$straight m',
                              style: AppFonts.body3,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Divider(color: Colors.white, thickness: 1.0),
                          Container(
                            decoration: BoxDecoration(
                              color: lengthColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  size,
                                  style: AppFonts.body3,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                ),
                              ),
                            ),
                          ),
                          Divider(color: Colors.white, thickness: 1.0),
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              homeData.isNotEmpty ? homeData : " ",
                              style: AppFonts.body3,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 4,
                          blurRadius: 7,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        AppImages.upArrowMapIconImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.tablecontentBgColor,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          width: 0.25, //
                          color: Colors.brown),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'Wind Relative\n To Straight',
                              style: AppFonts.body2_1,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                            ),
                          ),
                          Divider(color: Colors.white, thickness: 1.0),
                          FittedBox(
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            child: Text(
                              windRelHomeArrow,
                              style: AppFonts.body4,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Divider(color: Colors.white, thickness: 1.0),
                          Container(
                            decoration: BoxDecoration(
                              color: result['quality'] == '-'
                                  ? windColor.withOpacity(0)
                                  : windColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Center(
                                child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                result['quality'],
                                textAlign: TextAlign.center,
                                style: AppFonts.body3,
                                maxLines: 2,
                              ),
                            )),
                          ),
                          Divider(color: Colors.white, thickness: 1.0),
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              windSpeed.isNotEmpty ? windSpeed : " ",
                              style: AppFonts.body3,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
