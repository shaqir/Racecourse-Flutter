import 'dart:io';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/ui/core/theme/appcolors.dart';
import 'package:racecourse_tracks/config/appconstants.dart';
import 'package:racecourse_tracks/ui/core/theme/appfonts.dart';
import 'package:racecourse_tracks/ui/compare/widgets/compare_dashboard_screen.dart';
import 'package:racecourse_tracks/ui/dashboard/widgets/main_dashboard_screen.dart';
import 'package:racecourse_tracks/ui/dashboard/widgets/free_dashboard_screen.dart';
import 'package:racecourse_tracks/ui/profile/widgets/profile_screen.dart';
import 'package:racecourse_tracks/data/repositories/racecourse_repository.dart';
import 'package:racecourse_tracks/screens/SelectionPage/selection_page.dart';

class HomePageContainer extends StatefulWidget {
  const HomePageContainer({super.key});

  @override
  State<HomePageContainer> createState() => _MyHomePageContainerState();
}

class _MyHomePageContainerState extends State<HomePageContainer> {
  int bottomSelectedIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  //Set<Map<String, dynamic>> _selectedItems = {};

  final PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  // Expose this method to allow navigation from child widgets
  void navigateToDashboard(Set<Map<String, dynamic>> selectedItems) {
    if (kDebugMode) {
      print('navigateToDashboard...');
    }
    setState(() {
      if (selectedItems.isNotEmpty) {
        // _selectedItems = selectedItems;
      }
      bottomSelectedIndex =
          1; // Ensure the selected index matches DashboardPage
    });
    pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Widget buildPageView(RacecourseRepository provider, bool isSwipable) {
    if (kDebugMode) {
      print('buildPageView....');
      print('isSwipable....,$isSwipable');
    }

    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index, provider);
      },
      physics: isSwipable
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      children: <Widget>[
        SelectionPage(
          onNavigateToDashboard: navigateToDashboard, // Pass callback
        ),
        MainDashboardScreen(),
        CompareDashboardScreen(),
        ProfilePage(),
        FreeDashboardScreen(),
      ],
    );
  }

  void pageChanged(int index, RacecourseRepository provider) {
    if (kDebugMode) {
      print("On PAGE INDEX : $index");
    }
    
    if (index <= 3) {
      setState(() {
        bottomSelectedIndex = index;
      });
    }

    if (kDebugMode) {
      print("On PAGE INDEX bottomSelectedIndex : $bottomSelectedIndex");
    }
  }

  void bottomTapped(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    setState(() {
      bottomSelectedIndex = index;
    });
    if (kDebugMode) {
      print(' index & bottomSelectedIndex,$index $bottomSelectedIndex');
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemListProvider =
        Provider.of<RacecourseRepository>(context, listen: true);
    if (kDebugMode) {
      print("_isSwipeEnabled inside build: ${itemListProvider.isSwipeEnabled}");
    }

    return Scaffold(
      body: buildPageView(itemListProvider, itemListProvider.isSwipeEnabled),
      bottomNavigationBar: SafeArea(
        child: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: bottomSelectedIndex,
          iconPadding: 8,
          items: const [
            CurvedNavigationBarItem(
              child: Icon(
                Icons.search,
                size: AppFonts.titleMenuIcon,
                color: Colors.white,
              ),
              label: Appconstants.dashboardMenuItem1,
              labelStyle: AppFonts.bottomMenuItemStyle,
            ),
            CurvedNavigationBarItem(
              child: Icon(
                Icons.dashboard,
                size: AppFonts.titleMenuIcon,
                color: Colors.white,
              ),
              label: Appconstants.dashboardMenuItem2,
              labelStyle: AppFonts.bottomMenuItemStyle,
            ),
            CurvedNavigationBarItem(
              child: Icon(
                Icons.compare,
                size: AppFonts.titleMenuIcon,
                color: Colors.white,
              ),
              label: Appconstants.dashboardMenuItem3,
              labelStyle: AppFonts.bottomMenuItemStyle,
            ),
            CurvedNavigationBarItem(
              child: Icon(
                Icons.account_circle,
                size: AppFonts.titleMenuIcon,
                color: Colors.white,
              ),
              label: Appconstants.dashboardMenuItem4,
              labelStyle: AppFonts.bottomMenuItemStyle,
            ),
          ],
          color: AppColors.checkboxlist2Color,
          height: Platform.isIOS
              ? AppFonts.titleMenuHeight1
              : AppFonts.titleMenuHeight2,
          buttonBackgroundColor: AppColors.checkboxlist2Color,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 250),
          onTap: bottomTapped,
          letIndexChange: (index) => true,
        ),
      ),
    );
  }
}
