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
  final String? groundColor;
  final String? groundName;
  final bool showWeatherIcon;
  final bool showWidth;

  const FinishingPort({
    super.key,
    required this.winddata,
    required this.direction,
    required this.lengthData,
    this.isFromHome = false,
    required this.hideWindColumn,
    required this.selectedRacecourseData,
    required this.showUpgradeButton,
    required this.groundColor,
    required this.groundName,
    this.onUpgradePressed,
    this.upgradeRequestState,
    this.showWeatherIcon = true,
    this.showWidth = true,
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

    final length = lengthData.isNotEmpty
        ? lengthData.firstWhere(
            (data) =>
                data['RacecourseType'] ==
                    selectedRacecourseData['Racecourse Type'] &&
                selectedRacecourseData['Straight'] >= data['Min'] &&
                selectedRacecourseData['Straight'] <= data['Max'],
            orElse: () => {'Length Type': 'Unknown', 'ColorCode': '#000000'})
        : {'Length Type': 'Unknown', 'ColorCode': '#000000'};

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
          .hexToColor((length["ColorCode"]?.toString() ?? "#000000"))
          .withValues(alpha: 0.5);
    }

    Color windColor = Apputils().hexToColor(
        getWindColor(result['quality'])?["colorcode"].toString() ?? "#000000");

    

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(int.tryParse(
                '0xFF${groundColor ?? 'FFFFFF'}'.replaceFirst('#', '')) ??
            0xFFEEEEEE),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 1,
                  child: showWeatherIcon && selectedRacecourseData['weatherIcon'] != null
                      ? Image.network(
                          'https://openweathermap.org/img/wn/${selectedRacecourseData['weatherIcon']}@2x.png',
                          height: 70,
                        )
                      : Container(),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    AppMenuButtonTitles.finishingpost,
                    textAlign: TextAlign.center,
                    style: AppFonts.caption1.copyWith(
                        color: const Color.fromARGB(255, 212, 57, 46)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    groundName ?? '',
                    style: AppFonts.body2_1,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                )
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          SizedBox(
                            height: 40,
                            child: Text(
                              'Home Straight\nLength',
                              style: TextStyle(
                                fontFamily: AppFonts.myCutsomeSourceSansFont,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                            ),
                          ),
                          Divider(color: Colors.white, thickness: 1.0),
                          Consumer<SettingsRepository>(
                              builder: (context, settingsProvider, child) {
                            return SizedBox(
                              height: 40,
                              child: Center(
                                child: Text(
                                  settingsProvider.formatDistance(
                                      double.tryParse(straight) ?? 0),
                                  style: AppFonts.body3,
                                  textAlign: TextAlign.center,
                                ),
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
                                  length['Length Type'] ?? 'Unknown',
                                  style: AppFonts.body3,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ),
                          Divider(color: Colors.white, thickness: 1.0),
                          SizedBox(
                            height: 40,
                            child: Center(
                              child: Text(
                                homeData.isNotEmpty ? homeData : " ",
                                style: AppFonts.body3,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 168,
                            child: Center(
                              child: ClipOval(
                                child: Image.asset(
                                  AppImages.upArrowMapIconImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          if(selectedRacecourseData['Width'] != null && selectedRacecourseData['Width'] != 0 && showWidth)
                          SizedBox(
                            height: 40,
                            child: Center(
                              child: Consumer<SettingsRepository>(builder:
                                          (context, settingsProvider, child) {
                                        return Text(
                                          settingsProvider.formatDistance(
                                            selectedRacecourseData['Width']
                                                    ?.toDouble() ??
                                                0.0,
                                          ),
                                          style: AppFonts.body3,
                                          textAlign: TextAlign.center,
                                        );
                                      }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (showUpgradeButton)
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 70,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.deepPurple, // Text color
                            side: const BorderSide(color: Colors.deepPurple, width: 2), // Border color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: onUpgradePressed,
                          child: upgradeRequestState == RequestState.pending
                              ? const CircularProgressIndicator(color: Colors.deepPurple)
                              : const Text(
                                  'Upgrade Now',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                        ),
                      ],
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
                            SizedBox(
                              height: 40,
                              child: Text(
                                'Wind Relative\n To Straight',
                                style: TextStyle(
                                  fontFamily: AppFonts.myCutsomeSourceSansFont,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                              ),
                            ),
                            Divider(color: Colors.white, thickness: 1.0),
                            SizedBox(
                              height: 40,
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
                            SizedBox(
                              height: 40,
                              child: Center(
                                child: Text(
                                  windSpeed.isNotEmpty ? windSpeed : " ",
                                  style: AppFonts.body3,
                                  textAlign: TextAlign.center,
                                ),
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
