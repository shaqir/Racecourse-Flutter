import 'dart:async';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:racecourse_tracks/data/repositories/user_subscription/user_subscription_repository.dart';
import 'package:racecourse_tracks/domain/models/user_subscription.dart';

class PageContainerViewModel extends ChangeNotifier {
  PageContainerViewModel(this._subscriptionRepository) {
    _streamSubscription = _subscriptionRepository
        .getSubscriptionStream()
        .listen((UserSubscription subscription) {
      _userSubscription = subscription;
      _loading = false;
      pageController.animateToPage(
          _userSubscription?.activeEntitlements.contains('selection') == true
              ? 1
              : 0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      selectedPageIndex =
          _userSubscription?.activeEntitlements.contains('selection') == true
              ? 1
              : 0;

      _bottomNavigationKey = GlobalKey();
      notifyListeners();
    });
    _load();
  }

  final UserSubscriptionRepository _subscriptionRepository;
  StreamSubscription<UserSubscription>? _streamSubscription;
  UserSubscription? _userSubscription;
  UserSubscription? get userSubscription => _userSubscription;
  late PageController pageController;
  bool _loading = true;
  bool get loading => _loading;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  GlobalKey<CurvedNavigationBarState> get bottomNavigationKey =>
      _bottomNavigationKey;
  late int selectedPageIndex;

  Future<void> _load() async {
    try {
      if (!_subscriptionRepository.isInitialized) {
        await _subscriptionRepository.init();
      }
      _userSubscription = await _subscriptionRepository.getSubscription();
      _loading = false;
    } catch (e) {
      _loading = false;
      // Handle error appropriately, e.g., log it or show a message
    } finally {
      pageController = PageController(
        initialPage:
            _userSubscription?.activeEntitlements.contains('selection') == true
                ? 1
                : 0, // Default to 0 if no active entitlement
        keepPage: true,
      );
      _bottomNavigationKey = GlobalKey();
      selectedPageIndex =
          _userSubscription?.activeEntitlements.contains('selection') == true
              ? 1
              : 0;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
