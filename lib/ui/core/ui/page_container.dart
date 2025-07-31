import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/ui/compare/view_model/compare_dashboard_view_model.dart';
import 'package:racecourse_tracks/ui/core/theme/appcolors.dart';
import 'package:racecourse_tracks/config/appconstants.dart';
import 'package:racecourse_tracks/ui/core/theme/appfonts.dart';
import 'package:racecourse_tracks/ui/compare/widgets/compare_dashboard_screen.dart';
import 'package:racecourse_tracks/ui/core/ui/view_model/page_container_view_model.dart';
import 'package:racecourse_tracks/ui/dashboard/view_model/free_dashboard_view_model.dart';
import 'package:racecourse_tracks/ui/dashboard/view_model/main_dashboard_view_model.dart';
import 'package:racecourse_tracks/ui/dashboard/widgets/main_dashboard_screen.dart';
import 'package:racecourse_tracks/ui/dashboard/widgets/free_dashboard_screen.dart';
import 'package:racecourse_tracks/ui/profile/view_model/profile_view_model.dart';
import 'package:racecourse_tracks/ui/profile/widgets/profile_screen.dart';
import 'package:racecourse_tracks/ui/selection/view_model/selection_view_model.dart';
import 'package:racecourse_tracks/ui/selection/widgets/selection_screen.dart';
import 'package:racecourse_tracks/ui/scenarios/view_model/scenarios_view_model.dart';
import 'package:racecourse_tracks/ui/scenarios/widgets/scenarios_screen.dart';

class PageContainer extends StatefulWidget {
  const PageContainer({super.key});

  @override
  State<PageContainer> createState() => _MyHomePageContainerState();
}

class _MyHomePageContainerState extends State<PageContainer> {
  late final SelectionViewModel selectionViewModel =
      SelectionViewModel(context.read());
  late final PageContainerViewModel pageContainerViewModel =
      PageContainerViewModel(context.read());
  late final ScenariosViewModel scenariosViewModel =
      ScenariosViewModel(context.read(), context.read());
  late final FreeDashboardViewModel freeDashboardViewModel =
      FreeDashboardViewModel(
          racecourseRepository: context.read(),
          userSubscriptionRepository: context.read(),
          windDataRepository: context.read(),
          directionRepository: context.read(),
          lengthDataRepository: context.read(),
          courseTypeRepository: context.read());
  late final CompareDashboardViewModel compareDashboardViewModel =
      CompareDashboardViewModel(
    context.read(),
    context.read(),
    context.read(),
    context.read(),
    context.read(),
    context.read(),
    context.read(),
  );
  late final MainDashboardViewModel mainDashboardViewModel =
      MainDashboardViewModel(
          windDataRepository: context.read(),
          directionRepository: context.read(),
          lengthRepository: context.read(),
          racecourseRepository: context.read(),
          courseTypeRepository: context.read(),
          firstTurnDataRepository: context.read(),
          widthDataRepository: context.read());
  

  //Set<Map<String, dynamic>> _selectedItems = {};

  // Expose this method to allow navigation from child widgets
  void navigateToDashboard(Set<Map<String, dynamic>> selectedItems) {
    if (kDebugMode) {
      print('navigateToDashboard...');
    }
    setState(() {
      pageContainerViewModel.selectedPageIndex =
          1; // Ensure the selected index matches DashboardPage
    });
    pageContainerViewModel.pageController.animateToPage(
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
      controller: pageContainerViewModel.pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        // Add Scenarios screen as the first page
        if (pageContainerViewModel.userSubscription?.activeEntitlements
                .contains('selection') ==
            true)
          ScenariosScreen(viewModel: scenariosViewModel),
        if (pageContainerViewModel.userSubscription?.activeEntitlements
                .contains('selection') ==
            true)
          SelectionScreen(
            viewModel: selectionViewModel,
            onNavigateToDashboard: navigateToDashboard, // Pass callback
          ),
        if (pageContainerViewModel.userSubscription?.activeEntitlements
                .contains('mainDashboard') ==
            true)
          MainDashboardScreen(
            viewModel: mainDashboardViewModel,
          )
        else
          FreeDashboardScreen(
            viewModel: freeDashboardViewModel,
          ),
        if (pageContainerViewModel.userSubscription?.activeEntitlements
                .contains('compare') ==
            true)
          CompareDashboardScreen(
            viewModel: compareDashboardViewModel,
          ),
        ProfileScreen(
          viewModel: ProfileViewModel(
              userRepository: context.read(),
              subscriptionRepository: context.read()),
        ),
        if (pageContainerViewModel.userSubscription?.activeEntitlements
                .contains('mainDashboard') ==
            true)
          FreeDashboardScreen(
            viewModel: freeDashboardViewModel,
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
        pageContainerViewModel.selectedPageIndex = menuItemIndex;
      });
    }

    if (kDebugMode) {
      print("On PAGE INDEX bottomSelectedIndex : ${pageContainerViewModel.selectedPageIndex}");
    }
  }

  void bottomTapped(int index) {
    pageContainerViewModel.pageController.animateToPage(
      pages.indexOf(menuItems[index]),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    setState(() {
      pageContainerViewModel.selectedPageIndex = index;
    });
    if (kDebugMode) {
      print(' index & bottomSelectedIndex,$index ${pageContainerViewModel.selectedPageIndex}');
    }
  }

  @override
  void dispose() {
    pageContainerViewModel.pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: pageContainerViewModel,
        builder: (context, child) {
          if (pageContainerViewModel.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            body: buildPageView(),
            bottomNavigationBar: SafeArea(
              child: CurvedNavigationBar(
                key: pageContainerViewModel.bottomNavigationKey,
                index: pageContainerViewModel.selectedPageIndex < menuItems.length
                    ? pageContainerViewModel.selectedPageIndex
                    : 0,
                iconPadding: 8,
                items: [
                  // Add Scenarios navigation item first
                  if (pageContainerViewModel
                          .userSubscription?.activeEntitlements
                          .contains('selection') ==
                      true)
                    CurvedNavigationBarItem(
                      child: Icon(
                        Icons.lightbulb_outline,
                        size: AppFonts.titleMenuIcon,
                        color: Colors.white,
                      ),
                      label: Appconstants.scenarios,
                      labelStyle: AppFonts.bottomMenuItemStyle,
                    ),
                  if (pageContainerViewModel
                          .userSubscription?.activeEntitlements
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
                  if (pageContainerViewModel
                          .userSubscription?.activeEntitlements
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
                  if (pageContainerViewModel
                          .userSubscription?.activeEntitlements
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
        if (pageContainerViewModel.userSubscription?.activeEntitlements
                .contains('selection') ==
            true)
          Appconstants.scenarios,
        if (pageContainerViewModel.userSubscription?.activeEntitlements
                .contains('selection') ==
            true)
          Appconstants.selection,
        if (pageContainerViewModel.userSubscription?.activeEntitlements
                .contains('mainDashboard') ==
            true)
          Appconstants.main
        else
          Appconstants.freeDashboshboard,
        if (pageContainerViewModel.userSubscription?.activeEntitlements
                .contains('compare') ==
            true)
          Appconstants.compare,
        Appconstants.profile,
        if (pageContainerViewModel.userSubscription?.activeEntitlements
                .contains('mainDashboard') ==
            true)
          Appconstants.freeDashboshboard
      ];

  List<String> get menuItems => [
        if (pageContainerViewModel.userSubscription?.activeEntitlements
                .contains('selection') ==
            true)
          Appconstants.scenarios, // Add scenarios to menu items
        if (pageContainerViewModel.userSubscription?.activeEntitlements
                .contains('selection') ==
            true)
          Appconstants.selection,
        if (pageContainerViewModel.userSubscription?.activeEntitlements
                .contains('mainDashboard') ==
            true)
          Appconstants.main
        else
          Appconstants.freeDashboshboard,
        if (pageContainerViewModel.userSubscription?.activeEntitlements
                .contains('compare') ==
            true)
          Appconstants.compare,
        Appconstants.profile,
      ];
}
