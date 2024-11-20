import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/appcolors.dart';
import 'package:racecourse_tracks/core/appimages.dart';
import 'package:racecourse_tracks/core/getwindquality.dart';

class FinishingPort extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> winddata;
  final List<Map<String, dynamic>> direction;
  const FinishingPort({
    Key? key,
    required this.users,
    required this.winddata,
    required this.direction,
  }) : super(key: key);

  @override
  _FinishingPort createState() => _FinishingPort();
}

class _FinishingPort extends State<FinishingPort> {
  @override
  Widget build(BuildContext context) {
    final user = widget.users[150];
    var result = GetWindQuality().getWindQualityFromSpeed(
        user['Wind Speed'].toString(), widget.winddata);
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
              style: const TextStyle(
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
                                  fontWeight: FontWeight.w800),
                            ),
                            const Divider(
                              thickness: 1.0,
                              color: Colors.white,
                              indent: 4.0,
                              endIndent: 4.0,
                            ),
                            Text(
                              '${result['quality']}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400),
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
                                  fontWeight: FontWeight.w400),
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
                                  fontWeight: FontWeight.w800),
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
                                  fontWeight: FontWeight.w400),
                            ),
                            const Divider(
                              thickness: 1.0,
                              color: Colors.white,
                              indent: 4.0,
                              endIndent: 4.0,
                            ),
                            Text(
                              '${user['WindRel_HomeArrow']}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400),
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
    );
  }
}
