import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/appcolors.dart';
import 'package:racecourse_tracks/core/appimages.dart';
import 'package:racecourse_tracks/core/getwindquality.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/dataprovider.dart';

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

    if (!widget.isFromHome) {
      String? val = DataProvider.of(context).selectedRacecourse;
      String? val1 = DataProvider.of(context).selectedRacecourseType;

      selectedRacecourse = val ?? '';
      selectedRacecourseType = val1 ?? '';
    }

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
              'Finishing Post', // 'Finishing Post',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'SourceSansVariable',
              ),
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
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'SourceSansVariable',
                              ),
                            ),
                            const Divider(
                              thickness: 1.0,
                              color: Colors.white,
                              indent: 4.0,
                              endIndent: 4.0,
                            ),
                            Text(
                              '${result['quality']}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'SourceSansVariable',
                              ),
                            ),
                            const Divider(
                              thickness: 1.0,
                              color: Colors.white,
                              indent: 4.0,
                              endIndent: 4.0,
                            ),
                            Text(
                              '${user['Straight']} m', // Dynamic content
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'SourceSansVariable',
                              ),
                            ),
                            const Divider(
                              thickness: 1.0,
                              color: Colors.white,
                              indent: 4.0,
                              endIndent: 4.0,
                            ),
                            Text(
                              '${user['Size']}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'SourceSansVariable',
                              ),
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
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'SourceSansVariable',
                              ),
                            ),
                            const Divider(
                              thickness: 1.0,
                              color: Colors.white,
                              indent: 4.0,
                              endIndent: 4.0,
                            ),
                            Text(
                              '${result['quality']}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'SourceSansVariable',
                              ),
                            ),
                            const Divider(
                              thickness: 1.0,
                              color: Colors.white,
                              indent: 4.0,
                              endIndent: 4.0,
                            ),
                            Text(
                              WindRelHomeArrow,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'SourceSansVariable',
                              ),
                            ),
                            const Divider(
                              thickness: 1.0,
                              color: Colors.white,
                              indent: 4.0,
                              endIndent: 4.0,
                            ),
                            Text(
                              '${user['Wind Speed']}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'SourceSansVariable',
                              ),
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
