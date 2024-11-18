import 'dart:io';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/appcolors.dart';
import 'package:racecourse_tracks/core/appconstants.dart';
import 'package:racecourse_tracks/core/appsizes.dart'; 

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  late int _page;

  @override
  void initState() {
    super.initState();
    _page = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        items: const [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.home_outlined,
              size: AppSizes.titleMenuIcon,
              color: Colors.white,
            ),
            label: Appconstants.dashboardMenuItem1,
            labelStyle: TextStyle(
                fontSize: AppSizes.titleMenuText,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.search,
              size: AppSizes.titleMenuIcon,
              color: Colors.white,
            ),
            label: Appconstants.dashboardMenuItem2,
            labelStyle: TextStyle(
                fontSize: AppSizes.titleMenuText,
                fontWeight: FontWeight.bold,
                color: Colors.blue),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.settings,
              size: AppSizes.titleMenuIcon,
              color: Colors.white,
            ),
            label: Appconstants.dashboardMenuItem3,
            labelStyle: TextStyle(
                fontSize: AppSizes.titleMenuText,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.person,
              size: AppSizes.titleMenuIcon,
              color: Colors.white,
            ),
            labelStyle: TextStyle(
                fontSize: AppSizes.titleMenuText,
                fontWeight: FontWeight.bold,
                color: Colors.white),
            label: Appconstants.dashboardMenuItem4,
          ),
        ],
        color: AppColors.primaryDarkBlueColor,
        height: (Platform.isAndroid ? AppSizes.titleMenuHeight1 : AppSizes.titleMenuHeight1),
        buttonBackgroundColor: Colors.amber,
        backgroundColor: AppColors.primaryBgColor1,
        animationCurve: Curves.easeInOutCirc,
        animationDuration: const Duration(milliseconds: 150),
        onTap: (index) {
          setState(() {
            _page = index;
            if (kDebugMode) {
              print(_page);
            }
          });
        },
        letIndexChange: (index) => true,
      ),
      body: Container(
        color: Colors.transparent,
      ),
    );
  }
}


