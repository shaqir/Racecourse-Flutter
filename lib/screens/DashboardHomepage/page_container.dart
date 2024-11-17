import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/appcolors.dart';
import 'package:racecourse_tracks/core/appconstants.dart';
import 'package:racecourse_tracks/core/appsizes.dart';
import 'package:racecourse_tracks/screens/SelectionPage/selection_page.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/compare_dashboard_page.dart';
import 'package:racecourse_tracks/screens/DashboardHomepage/dashboard_page.dart';

class PageContainer extends StatefulWidget {
  const PageContainer({super.key});

  @override
  _MyPageContainerState createState() => _MyPageContainerState();
}

class _MyPageContainerState extends State<PageContainer> {
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
      children: <Widget>[
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
                color: Colors.white),
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
        color: Colors.deepPurple,
        height: AppSizes.titleMenuHeight2,
        buttonBackgroundColor: Colors.deepPurple,
        backgroundColor: AppColors.primaryLightBgColor,
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

class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Home', Icons.home, Colors.teal),
  Destination('Business', Icons.business, Colors.cyan),
  Destination('School', Icons.school, Colors.orange),
  Destination('Flight', Icons.flight, Colors.blue)
];
