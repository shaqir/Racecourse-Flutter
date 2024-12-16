import 'dart:io';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
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
  _MyHomePageContainerState createState() => _MyHomePageContainerState();
}

class _MyHomePageContainerState extends State<HomePageContainer> {
  int bottomSelectedIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  //Set<Map<String, dynamic>> _selectedItems = {};

  final PageController pageController = PageController(
    initialPage: 2,
    keepPage: true,
  );

  void initState(){
    super.initState(); 
  }
  // Expose this method to allow navigation from child widgets
  void navigateToDashboard(Set<Map<String, dynamic>> selectedItems) {
    print('navigateToDashboard...');
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
      curve: Curves.ease,
    );
  }

  Widget buildPageView(ItemListProvider provider, bool isSwipable) {
    print('buildPageView....');
    print('isSwipable....,$isSwipable'); 
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index, provider);
      },
      physics: isSwipable
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      children: <Widget>[
        const CompareDashboardPage(),
        DashboardPage(provider: provider),
        SelectionPage(
           provider: provider, onNavigateToDashboard: navigateToDashboard,// Pass callback
        ),
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
 
    print('index,$index');
    print('bottomSelectedIndex,$bottomSelectedIndex');
    if(index == 0 || index == 2 || index == 3){
      bottomSelectedIndex = 1;
    }
    else{
      bottomSelectedIndex = 2;
    }
    setState(() {
      bottomSelectedIndex = index;
    });
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
    );
  }
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
      
    final _itemListProvider =
        Provider.of<ItemListProvider>(context, listen: true);
    print("_isSwipeEnabled inside build: ${_itemListProvider.isSwipeEnabled}");    

    return Scaffold(
      body: buildPageView(_itemListProvider, _itemListProvider.isSwipeEnabled),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: bottomSelectedIndex,
        iconPadding: 12,
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
        height: Platform.isIOS ?  AppFonts.titleMenuHeight1 : AppFonts.titleMenuHeight2,
        buttonBackgroundColor: AppColors.checkboxlist2Color,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 250),
        onTap: bottomTapped,
        letIndexChange: (index) => true,
      ),
    );
  }
}
