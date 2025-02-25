import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/utility/apputils.dart';

class HomeStraight extends StatefulWidget {
  final String selectedRacecourse;
  final List<Map<String, dynamic>> users;
  final String selectedRacecourseType;

  const HomeStraight(
      {Key? key,
      required this.users,
      required this.selectedRacecourse,
      required this.selectedRacecourseType})
      : super(key: key);

  @override
  _HomeStraightState createState() => _HomeStraightState();
}

class _HomeStraightState extends State<HomeStraight> {
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

    String homeData = (user.isNotEmpty &&
            user['Home'] != null &&
            user['Home'].toString().trim().isNotEmpty)
        ? user['Home'].toString()
        : '-';

    String straight = user.containsKey('Straight') && user['Straight'] != null
        ? user['Straight'].toString()
        : '';

    String size = user.containsKey('Size') && user['Size'] != null
        ? user['Size'].toString()
        : '';

    Color lengthColor = Colors.transparent;
    if (!user.isEmpty) {
      lengthColor = Apputils()
          .hexToColor((Apputils()
                  .getLengthColor(user["Racecourse Type"], size)?["ColorCode"]
                  ?.toString() ??
              "#000000"))
          .withOpacity(0.5);
    }

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 90),
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.tablecontentBgColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 0.25, color: Colors.brown),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(2),
            child: Text(
              'Home Straight Length',
              style: AppFonts.body2_1,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 10.0), // Adjust the margin as needed
            child: Divider(
              color: Colors.deepPurple,
              thickness: 1.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildText(
                    homeData.isNotEmpty ? homeData : "-", AppFonts.body3),
                _buildDivider(),
                _buildText('$straight m', AppFonts.body3),
                _buildDivider(),
                SizedBox(width: 3),
                _buildSizeContainer(size, lengthColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildText(String text, TextStyle style) {
    return Expanded(
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
        maxLines: 3,
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 24, // Adjusted height for better visibility
      width: 1,
      color: Colors.deepPurple,
    );
  }

  Widget _buildSizeContainer(size, lengthColor) {
    return Container(
      decoration: BoxDecoration(
        color: lengthColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Center(
        child: Text(
          size,
          style: AppFonts.body3,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
