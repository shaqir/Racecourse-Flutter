import 'dart:io';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appconstants.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/screens/SelectionPage/itemlistprovider.dart';
import 'package:racecourse_tracks/screens/SelectionPage/selection_page.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/compare_dashboard_page.dart';
import 'package:racecourse_tracks/screens/DashboardHomepage/dashboard_page.dart';

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

  @override
  void initState() {
    super.initState();
    setState(() {
      bottomSelectedIndex =
          1; // Ensure the selected index matches DashboardPage
    });
  }

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

  Widget buildPageView(ItemListProvider provider, bool isSwipable) {
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
        DashboardPage(),
        CompareDashboardPage(provider: provider),
      ],
    );
  }

  void pageChanged(int index, ItemListProvider provider) {
    if (kDebugMode) {
      print("On PAGE INDEX : $index");
    }
    if (provider.savedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select at least one item.",
            style: AppFonts.caption2,
          ),
        ),
      );
    }
    setState(() {
      if (index == 0) {
        bottomSelectedIndex = 1;
      } else if (index == 1) {
        bottomSelectedIndex = 0;
      } else {
        bottomSelectedIndex = 0;
      }
    });
    if (kDebugMode) {
      print("On PAGE INDEX bottomSelectedIndex : $bottomSelectedIndex");
    }
  }

  void bottomTapped(int index) {
    if (index == 0) {
      pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (index == 1) {
      pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      return;
    }
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
        Provider.of<ItemListProvider>(context, listen: true);
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
                Icons.home_outlined,
                size: AppFonts.titleMenuIcon,
                color: Colors.white,
              ),
              label: Appconstants.dashboardMenuItem1,
              labelStyle: AppFonts.bottomMenuItemStyle,
            ),
            CurvedNavigationBarItem(
              child: Icon(
                Icons.search,
                size: AppFonts.titleMenuIcon,
                color: Colors.white,
              ),
              label: Appconstants.dashboardMenuItem2,
              labelStyle: AppFonts.bottomMenuItemStyle,
            ),
            CurvedNavigationBarItem(
              child: Icon(
                Icons.settings,
                size: AppFonts.titleMenuIcon,
                color: Colors.white,
              ),
              label: Appconstants.dashboardMenuItem3,
              labelStyle: AppFonts.bottomMenuItemStyle,
            ),
            CurvedNavigationBarItem(
              child: Icon(
                Icons.person,
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
