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
import 'package:racecourse_tracks/ui/core/ui/view_model/page_container_view_model.dart';
import 'package:racecourse_tracks/ui/dashboard/view_model/free_dashboard_view_model.dart';
import 'package:racecourse_tracks/ui/dashboard/widgets/main_dashboard_screen.dart';
import 'package:racecourse_tracks/ui/dashboard/widgets/free_dashboard_screen.dart';
import 'package:racecourse_tracks/ui/profile/view_model/profile_view_model.dart';
import 'package:racecourse_tracks/ui/profile/widgets/profile_screen.dart';
import 'package:racecourse_tracks/ui/selection/widgets/selection_screen.dart';

class PageContainer extends StatefulWidget {
  const PageContainer({super.key});

  @override
  State<PageContainer> createState() => _MyHomePageContainerState();
}

class _MyHomePageContainerState extends State<PageContainer> {
  late final PageContainerViewModel viewModel =
      context.read<PageContainerViewModel>();
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

  Widget buildPageView() {
    if (kDebugMode) {
      print('buildPageView....');
    }

    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        if (viewModel.userSubscription?.activeEntitlements
                .contains('selection') ==
            true)
          SelectionScreen(
            onNavigateToDashboard: navigateToDashboard, // Pass callback
          ),
        if (viewModel.userSubscription?.activeEntitlements
                .contains('mainDashboard') ==
            true)
          MainDashboardScreen(),
        FreeDashboardScreen(
          viewModel: FreeDashboardViewModel(racecourseRepository: context.read(), userSubscriptionRepository: context.read()),
        ),
        if (viewModel.userSubscription?.activeEntitlements
                .contains('compare') ==
            true)
          CompareDashboardScreen(),
        ProfileScreen(
          viewModel: ProfileViewModel(
              userRepository: context.read(),
              subscriptionRepository: context.read()),
        ),
      ],
    );
  }

  void pageChanged(int index) {
    if (kDebugMode) {
      print("On PAGE INDEX : $index");
    }
    final menuItemIndex = menuItems.indexOf(pages[index]);
    if (menuItemIndex != -1) {
      setState(() {
        bottomSelectedIndex = menuItemIndex;
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
      bottomSelectedIndex = pages.indexOf(menuItems[index]);
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
    return ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          if (viewModel.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            body: buildPageView(),
            bottomNavigationBar: SafeArea(
              child: CurvedNavigationBar(
                key: _bottomNavigationKey,
                index: bottomSelectedIndex,
                iconPadding: 8,
                items: [
                  if (viewModel.userSubscription?.activeEntitlements
                          .contains('selection') ==
                      true)
                    CurvedNavigationBarItem(
                      child: Icon(
                        Icons.search,
                        size: AppFonts.titleMenuIcon,
                        color: Colors.white,
                      ),
                      label: Appconstants.selection,
                      labelStyle: AppFonts.bottomMenuItemStyle,
                    ),
                  if (viewModel.userSubscription?.activeEntitlements
                          .contains('mainDashboard') ==
                      true)
                    CurvedNavigationBarItem(
                      child: Icon(
                        Icons.dashboard,
                        size: AppFonts.titleMenuIcon,
                        color: Colors.white,
                      ),
                      label: Appconstants.main,
                      labelStyle: AppFonts.bottomMenuItemStyle,
                    )
                  else
                    CurvedNavigationBarItem(
                      child: Icon(
                        Icons.dashboard,
                        size: AppFonts.titleMenuIcon,
                        color: Colors.white,
                      ),
                      label: Appconstants.freeDashboshboard,
                      labelStyle: AppFonts.bottomMenuItemStyle,
                    ),
                  if (viewModel.userSubscription?.activeEntitlements
                          .contains('compare') ==
                      true)
                    CurvedNavigationBarItem(
                      child: Icon(
                        Icons.compare,
                        size: AppFonts.titleMenuIcon,
                        color: Colors.white,
                      ),
                      label: Appconstants.compare,
                      labelStyle: AppFonts.bottomMenuItemStyle,
                    ),
                  CurvedNavigationBarItem(
                    child: Icon(
                      Icons.account_circle,
                      size: AppFonts.titleMenuIcon,
                      color: Colors.white,
                    ),
                    label: Appconstants.profile,
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
        });
  }

  List<String> get pages => [
        if (viewModel.userSubscription?.activeEntitlements
                .contains('selection') ==
            true)
          Appconstants.selection,
        if (viewModel.userSubscription?.activeEntitlements
                .contains('mainDashboard') ==
            true)
          Appconstants.main,
        Appconstants.freeDashboshboard,
        if (viewModel.userSubscription?.activeEntitlements
                .contains('compare') ==
            true)
          Appconstants.compare,
        Appconstants.profile,
      ];

  List<String> get menuItems => [
        if (viewModel.userSubscription?.activeEntitlements
                .contains('selection') ==
            true)
          Appconstants.selection,
        if (viewModel.userSubscription?.activeEntitlements
                .contains('mainDashboard') ==
            true)
          Appconstants.main
        else
          Appconstants.freeDashboshboard,
        if (viewModel.userSubscription?.activeEntitlements
                .contains('compare') ==
            true)
          Appconstants.compare,
        Appconstants.profile,
      ];
}
