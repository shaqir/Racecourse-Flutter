import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/common/appimages.dart';
import 'package:racecourse_tracks/core/common/appmenubuttontitles.dart';
import 'package:racecourse_tracks/core/utility/apputils.dart';
import 'package:racecourse_tracks/core/utility/firestoreservice.dart';
import 'package:racecourse_tracks/core/utility/getwindquality.dart';

class FinishingPort extends StatelessWidget {
  final List<Map<String, dynamic>> winddata;
  final List<Map<String, dynamic>> direction;
  final bool? isFromHome;
  final bool hideWindColumn;
  final Map<String, dynamic> selectedRacecourseData;

  FinishingPort({
    super.key,
    required this.winddata,
    required this.direction,
    this.isFromHome = false,
    required this.hideWindColumn,
    required this.selectedRacecourseData,
  });

  final List<Map<String, dynamic>> lengthdata = FirestoreService.lengthdata;

  @override
  Widget build(BuildContext context) {

    String windSpeed = selectedRacecourseData.containsKey('Wind Speed') &&
            selectedRacecourseData['Wind Speed'] != null
        ? selectedRacecourseData['Wind Speed'].toString()
        : '';

    String homeData = (selectedRacecourseData.isNotEmpty &&
            selectedRacecourseData['Home'] != null &&
            selectedRacecourseData['Home'].toString().trim().isNotEmpty)
        ? selectedRacecourseData['Home'].toString()
        : '-';

    var result =
        GetWindQuality().getWindQualityFromSpeed(windSpeed, winddata);

    String windRelHomeArrow =
        selectedRacecourseData.containsKey('WindRel_HomeArrow') &&
                selectedRacecourseData['WindRel_HomeArrow'] != null
            ? selectedRacecourseData['WindRel_HomeArrow'].toString()
            : '-';

    String straight = selectedRacecourseData.containsKey('Straight') &&
            selectedRacecourseData['Straight'] != null
        ? selectedRacecourseData['Straight'].toString().split('.').first
        : '';

    String size = Apputils().removeTrailingSpace(
        selectedRacecourseData.containsKey('Size') &&
                selectedRacecourseData['Size'] != null
            ? selectedRacecourseData['Size'].toString()
            : '');

    Map<String, dynamic>? getLengthColor(String racecourseType) {
      // print("Size : ${size}");
      // print("racecourseType : ${racecourseType}");
      for (var data in lengthdata) {
        // print("RacecourseType : ${data['RacecourseType']}");
        // print("Length Type : ${data['Length Type']}");
        if (racecourseType.toString().toLowerCase() ==
                data['RacecourseType'].toString().toLowerCase() &&
            size.toString().toLowerCase() ==
                data['Length Type'].toString().toLowerCase()) {
          return data; // Return the first match
        }
      }
      return null; // Return null if no match is found
    }

    Map<String, dynamic>? getWindColor(String windType) {
      for (var data in winddata) {
        if (windType == data['Wind Quality']) {
          return data; // Return the first match
        }
      }
      return null;
    }

    // print("MY : ${user}");
    Color lengthColor = Colors.transparent;
    if (selectedRacecourseData.isNotEmpty) {
      lengthColor = Apputils()
          .hexToColor((getLengthColor(
                      selectedRacecourseData["Racecourse Type"])?["ColorCode"]
                  ?.toString() ??
              "#000000"))
          .withValues(alpha: 0.5);
    }

    Color windColor = Apputils().hexToColor(
        getWindColor(result['quality'])?["colorcode"].toString() ?? "#000000");

    Color getGroundColor(String groundType) {
      if (groundType == "S") {
        return Color(0xffededed);
      } else if (groundType == "G") {
        return Color(0xffa9d08e);
      } else if (groundType == "P") {
        return Color(0xffe6b8af);
      }
      return Color(0xff454545).withValues(alpha: 0.75);
    }

    String getGroundName(String gName) {
      if (gName == "S") {
        return "Synthetic";
      } else if (gName == "G") {
        return "Turf";
      } else if (gName == "P") {
        return "Poly";
      }
      return "";
    }

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: getGroundColor(selectedRacecourseData['Type'] ?? " "),
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
                      color: AppColors.silverdataColor,
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
                    // decoration: BoxDecoration(
                    //   shape: BoxShape.circle,
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.black.withOpacity(0.5),
                    //       spreadRadius: 4,
                    //       blurRadius: 7,
                    //       offset: Offset(3, 3),
                    //     ),
                    //   ],
                    // ),

                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        ClipOval(
                          child: Image.asset(
                            AppImages.upArrowMapIconImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          getGroundName(selectedRacecourseData['Type'] ?? " "),
                          style: AppFonts.body2_1,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        )
                      ],
                    ),
                  ),
                ),
                if (!hideWindColumn)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.silverdataColor,
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
                                style: AppFonts.bodyArrow,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Divider(color: Colors.white, thickness: 1.0),
                            Container(
                              decoration: BoxDecoration(
                                color: result['quality'] == '-'
                                    ? windColor.withValues(alpha: 0)
                                    : windColor.withValues(alpha: 0.8),
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
