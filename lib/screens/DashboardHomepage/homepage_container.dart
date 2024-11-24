import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appconstants.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/utility/Itemlistprovider.dart';
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

  final PageController pageController = PageController(
    initialPage: 2,
    keepPage: true,
  );

  // Expose this method to allow navigation from child widgets
  void navigateToDashboard() {
    setState(() {
      bottomSelectedIndex =
          1; // Ensure the selected index matches DashboardPage
    });
    pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  Widget buildPageView(ItemListProvider provider) {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index, provider);
      },
      physics: provider.selectedItems.isEmpty
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      children: <Widget>[
        const CompareDashboardPage(),
        DashboardPage(selectedItems: provider.selectedItems),
        SelectionPage(onNavigateToDashboard: navigateToDashboard),
      ],
    );
  }

  void pageChanged(int index, ItemListProvider provider) {
    print("PAGE INDEX : ${provider.selectedItems.length}");
    if (provider.selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select at least one item.",
            style: AppFonts.caption2,
          ),
        ),
      );
    }
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _itemListProvider =
        Provider.of<ItemListProvider>(context, listen: false);
    return Scaffold(
      body: buildPageView(_itemListProvider),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: bottomSelectedIndex,
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
        color: Colors.deepPurple,
        height: AppFonts.titleMenuHeight2,
        buttonBackgroundColor: Colors.deepPurple,
        backgroundColor: AppColors.primaryBgColor1,
        animationCurve: Curves.easeInOutCirc,
        animationDuration: const Duration(milliseconds: 500),
        onTap: bottomTapped,
        letIndexChange: (index) => true,
      ),
    );
  }
}
