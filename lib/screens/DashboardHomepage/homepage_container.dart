import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appconstants.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/screens/SelectionPage/selection_page.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/compare_dashboard_page.dart';
import 'package:racecourse_tracks/screens/DashboardHomepage/dashboard_page.dart';

class HomePageContainer extends StatefulWidget {
  const HomePageContainer({super.key});

  @override
  _MyHomePageContainerState createState() => _MyHomePageContainerState();
}

class _MyHomePageContainerState extends State<HomePageContainer> {
  int bottomSelectedIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: const <Widget>[
        CompareDashboardPage(),
        DashboardPage(),
        SelectionPage(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void pageChanged(int index) {
    setState(
      () {
        pageController.animateToPage(index,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      },
    );
  }

  void bottomTapped(int index) {
    setState(
      () {
        bottomSelectedIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
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
            labelStyle: AppFonts.bottomMenuItemStyle,
            label: Appconstants.dashboardMenuItem4,
          ),
        ],
        color: Colors.deepPurple,
        height: AppFonts.titleMenuHeight2,
        buttonBackgroundColor: Colors.deepPurple,
        backgroundColor: AppColors.primaryBgColor1,
        animationCurve: Curves.easeInOutCirc,
        animationDuration: const Duration(milliseconds: 200),
        onTap: (index) {
          setState(() {
            bottomSelectedIndex = index;
            if (kDebugMode) {
              print(bottomSelectedIndex);
            }
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
} 