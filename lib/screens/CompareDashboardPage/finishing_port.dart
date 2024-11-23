import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/common/appimages.dart';
import 'package:racecourse_tracks/core/common/appmenubuttontitles.dart';
import 'package:racecourse_tracks/core/utility/getwindquality.dart';
import 'package:racecourse_tracks/core/utility/dataprovider.dart';

// ignore: must_be_immutable
class FinishingPort extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> winddata;
  final List<Map<String, dynamic>> direction;
  bool isFromHome = false;

  FinishingPort({
    Key? key,
    required this.users,
    required this.winddata,
    required this.direction,
    required this.isFromHome,
  }) : super(key: key);

  @override
  _FinishingPort createState() => _FinishingPort();
}

class _FinishingPort extends State<FinishingPort> {
  @override
  Widget build(BuildContext context) {
    String selectedRacecourse = '';
    String selectedRacecourseType = '';

    // if (!widget.isFromHome) {
    String? val = DataProvider.of(context).selectedRacecourse;
    String? val1 = DataProvider.of(context).selectedRacecourseType;

    selectedRacecourse = val ?? '';
    selectedRacecourseType = val1 ?? '';
    // }

    final user = widget.users.firstWhere(
      (u) =>
          u['Racecourse'] == selectedRacecourse &&
          u['Racecourse Type'] == selectedRacecourseType,
      orElse: () => {},
    );
    var result = GetWindQuality().getWindQualityFromSpeed(
        user['Wind Speed'].toString(), widget.winddata);

    String WindRelHomeArrow = user.containsKey('WindRel_HomeArrow') &&
            user['WindRel_HomeArrow'] != null
        ? user['WindRel_HomeArrow'].toString()
        : '';
    return Container(
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
              AppMenuButtonTitles.finishingpost,
              style: AppFonts.caption1,
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
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Length',
                              style: AppFonts.body2,
                            ),
                            const Divider(
                              thickness: 1.0,
                              color: Colors.white,
                              indent: 4.0,
                              endIndent: 4.0,
                            ),
                            Text(
                              '-',
                              style: AppFonts.body3,
                            ),
                            const Divider(
                              thickness: 1.0,
                              color: Colors.white,
                              indent: 4.0,
                              endIndent: 4.0,
                            ),
                            Text(
                              '${user['Straight']} m', // Dynamic content
                              style: AppFonts.body3,
                            ),
                            const Divider(
                              thickness: 1.0,
                              color: Colors.white,
                              indent: 4.0,
                              endIndent: 4.0,
                            ),
                            Text(
                              '${user['Size']}',
                              style: AppFonts.body3,
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
                        child: const Image(
                          image: AssetImage(AppImages.upArrowMapIconImage),
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
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Wind',
                              style: AppFonts.body2,
                            ),
                            const Divider(
                              thickness: 1.0,
                              color: Colors.white,
                              indent: 4.0,
                              endIndent: 4.0,
                            ),
                            Text(
                              '${result['quality']}',
                              style: AppFonts.body3,
                            ),
                            const Divider(
                              thickness: 1.0,
                              color: Colors.white,
                              indent: 4.0,
                              endIndent: 4.0,
                            ),
                            Text(
                              WindRelHomeArrow,
                              style: AppFonts.body3,
                            ),
                            const Divider(
                              thickness: 1.0,
                              color: Colors.white,
                              indent: 4.0,
                              endIndent: 4.0,
                            ),
                            Text(
                              '${user['Wind Speed']}',
                              style: AppFonts.body3,
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
    );
  }
}
