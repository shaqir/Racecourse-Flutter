import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/ui/core/theme/appcolors.dart';
import 'package:racecourse_tracks/ui/core/theme/appfonts.dart';
import 'package:racecourse_tracks/ui/core/theme/appimages.dart';
import 'package:racecourse_tracks/config/appmenubuttontitles.dart';
import 'package:racecourse_tracks/utils/apputils.dart';
import 'package:racecourse_tracks/utils/getwindquality.dart';
import 'package:racecourse_tracks/data/repositories/settings_repository.dart';
import 'package:racecourse_tracks/ui/core/ui/wind_arrow.dart';
import 'package:racecourse_tracks/utils/request_state.dart';

class FinishingPort extends StatelessWidget {
  final List<Map<String, dynamic>> winddata;
  final List<Map<String, dynamic>> direction;
  final List<Map<String, dynamic>> lengthData;
  final bool? isFromHome;
  final bool hideWindColumn;
  final Map<String, dynamic> selectedRacecourseData;
  final bool showUpgradeButton;
  final void Function()? onUpgradePressed;
  final RequestState? upgradeRequestState;

  const FinishingPort({
    super.key,
    required this.winddata,
    required this.direction,
    required this.lengthData,
    this.isFromHome = false,
    required this.hideWindColumn,
    required this.selectedRacecourseData,
    required this.showUpgradeButton,
    this.onUpgradePressed,
    this.upgradeRequestState,
  });

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

    var result = GetWindQuality().getWindQualityFromSpeed(windSpeed, winddata);

    final homeDegree = selectedRacecourseData['HomeDeg'] ?? 0.0;
    final straightDegree = homeDegree + 180.0;
    final windDirection =
        selectedRacecourseData['Wind Direction (Degrees)'] ?? 0.0;
    final windRelativeToStraight = windDirection - straightDegree;
    final rotatedWindIcon =
        WindArrow(angle: windRelativeToStraight, color: Colors.black);

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
      for (var data in lengthData) {
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
      } else if (groundType == "Sa") {
        // light browny yellow
        return Color(0xfff2d6b9);
      } else if (groundType == "D") {
        //  lighter brown
        return Color(0xffd9c6b2);
      } else if (groundType == "A") {
        // the same colour as Poly Track types
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
      } else if (gName == "D") {
        return "Dirt";
      } else if (gName == "A") {
        return "Awt";
      } else if (gName == "Sa") {
        return "Sand";
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
            Text(
              AppMenuButtonTitles.finishingpost,
              style: AppFonts.caption1
                  .copyWith(color: const Color.fromARGB(255, 212, 57, 46)),
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
                          Consumer<SettingsRepository>(
                              builder: (context, settingsProvider, child) {
                            return FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                settingsProvider.formatDistance(
                                    double.tryParse(straight) ?? 0),
                                style: AppFonts.body3,
                                textAlign: TextAlign.center,
                              ),
                            );
                          }),
                          Divider(color: Colors.white, thickness: 1.0),
                          Container(
                            decoration: BoxDecoration(
                              color: lengthColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            height: 40,
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  size,
                                  style: AppFonts.body3,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
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
                if (showUpgradeButton)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onUpgradePressed,
                      child: upgradeRequestState == RequestState.pending
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Upgrade Now',
                              textAlign: TextAlign.center,
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
                                child: rotatedWindIcon),
                            Divider(color: Colors.white, thickness: 1.0),
                            Container(
                              decoration: BoxDecoration(
                                color: result['quality'] == '-'
                                    ? windColor.withValues(alpha: 0)
                                    : windColor.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 40,
                              padding: const EdgeInsets.all(8),
                              child: FittedBox(
                                  child: Text(
                                result['quality'],
                                textAlign: TextAlign.center,
                                style: AppFonts.body3,
                                maxLines: 2,
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
