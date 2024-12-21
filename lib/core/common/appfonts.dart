import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';

class AppFonts {
  //Font Family
  static const String myCutsomeSourceSansFont = 'SourceSansVariable';

  // Font Sizes

  static const double captionFontSize12 = 12.0;
  static const double captionFontSize14 = 14.0;
  static const double captionFontSize16 = 16.0;
  static const double captionFontSize17 = 17.0;
  static const double captionFontSize18 = 18.0;
  static const double captionFontSize20 = 20.0;

  static const double bodyFontSize12 = 12.0;
  static const double bodyFontSize13 = 13.0; 
  static const double bodyFontSize14 = 14.0;
  static const double bodyFontSize15 = 15.0;
  static const double bodyFontSize16 = 16.0;
  static const double bodyFontSize17 = 17.0;
  static const double bodyFontSize18 = 18.0;
  static const double bodyFontSize19 = 19.0;
  static const double bodyFontSize20 = 20.0;
  static const double bodyFontSize22 = 22.0;
  static const double bodyFontSize23 = 23.0;
  static const double bodyFontSize24 = 24.0;
  static const double bodyFontSize26 = 26.0;

  static const double titleFontSize14 = 14.0;
  static const double titleFontSize16 = 16.0;
  static const double titleFontSize18 = 18.0;
  static const double titleFontSize20 = 20.0;
  static const double titleFontSize22 = 22.0;
  static const double titleFontSize24 = 24.0;
  static const double titleFontSize40 = 40.0;

  static const double titleMenuItemTitle = 13;
  static const double titleMenuIcon = 22;
  static const double titleMenuHeight1 = 65;
  static const double titleMenuHeight2 = 55;

  //Font Weights
  static const FontWeight light = FontWeight.w200;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extrabold = FontWeight.w800;

  //Selection Screen Menu item size
  static const double selectionMenuItemHeight = 80;

  // Title Text Styles
  static const TextStyle title = TextStyle(
    fontFamily: myCutsomeSourceSansFont,
    fontSize: titleFontSize24,
    fontWeight: bold,
    color: Colors.white,
  );
  static const TextStyle titleRaceCourse = TextStyle(
    fontFamily: myCutsomeSourceSansFont,
    fontSize: titleFontSize18,
    fontWeight: FontWeight.w700,
    color: AppColors.selectedDarkBrownColor,
  );

  static const TextStyle title1 = TextStyle(
    fontFamily: myCutsomeSourceSansFont,
    fontSize: titleFontSize20,
    fontWeight: bold,
    color: Colors.white,
  );

  static const TextStyle title2 = TextStyle(
    fontFamily: myCutsomeSourceSansFont,
    fontWeight: bold,
    fontSize: titleFontSize14,
    color: Colors.black,
  );

  // Body Text Styles
  static const TextStyle body = TextStyle(
    fontFamily: myCutsomeSourceSansFont,
    fontSize: bodyFontSize14,
    fontWeight: medium,
    color: Colors.black,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: myCutsomeSourceSansFont,
    fontSize: bodyFontSize14,
    fontWeight: bold,
    color: Colors.white,
  );
  static const TextStyle body2 = TextStyle(
    fontFamily: myCutsomeSourceSansFont,
    fontSize: bodyFontSize16,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  static const TextStyle body2_1 = TextStyle(
    fontFamily: myCutsomeSourceSansFont,
    fontSize: bodyFontSize13,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const TextStyle body3 = const TextStyle(
    fontFamily: myCutsomeSourceSansFont,
    color: Colors.black,
    fontSize: bodyFontSize15,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle body4 = const TextStyle(
    fontFamily: myCutsomeSourceSansFont,
    color: Colors.black,
    fontSize: bodyFontSize23,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle body5 = TextStyle(
    fontFamily: myCutsomeSourceSansFont,
    fontSize: bodyFontSize15,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static const TextStyle body6 = TextStyle(
    fontFamily: myCutsomeSourceSansFont,
    fontSize: bodyFontSize16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: myCutsomeSourceSansFont,
    fontSize: captionFontSize12,
    fontWeight: light,
    color: Colors.white,
  );
  static const TextStyle caption1 = TextStyle(
    fontFamily: myCutsomeSourceSansFont,
    fontSize: captionFontSize17,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  static const TextStyle caption2 = TextStyle(
    fontFamily: myCutsomeSourceSansFont,
    fontSize: captionFontSize17,
    fontWeight: medium,
    color: Colors.black,
  );
  // Bottom Navigation Menu Item
  static const TextStyle bottomMenuItemStyle = TextStyle(
    fontFamily: myCutsomeSourceSansFont,
    fontSize: titleMenuItemTitle,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  // Splash Screen Style
  static const TextStyle splashNameStyle = TextStyle(
    fontFamily: myCutsomeSourceSansFont,
    fontSize: titleFontSize40,
    color: Colors.white, // White text color
    fontWeight: bold,
  );

  // Manage Font Scaling Responsively
  // Use and combine font in themes
}
