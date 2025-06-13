import 'dart:async';

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
      pageController = PageController(
        initialPage: 0,
        keepPage: true,
      );
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

  Future<void> _load() async {
    try {
      _userSubscription = await _subscriptionRepository.getSubscription();
      _loading = false;
    } catch (e) {
      _loading = false;
      // Handle error appropriately, e.g., log it or show a message
    } finally {
      pageController = PageController(
        initialPage: 0,
        keepPage: true,
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
