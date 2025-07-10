import 'dart:async';

import 'package:racecourse_tracks/data/repositories/user_subscription/user_subscription_repository.dart';
import 'package:racecourse_tracks/data/services/authentication_service.dart';
import 'package:racecourse_tracks/data/services/revenue_cat_sdk_service.dart';
import 'package:racecourse_tracks/domain/models/user_subscription.dart';

class UserSubscriptionRepositoryRevenueCat
    implements UserSubscriptionRepository {

  bool _isInitialized = false;
  @override
  bool get isInitialized => _isInitialized;
  final _subscriptionController =
      StreamController<UserSubscription>.broadcast();
  final RevenueCatSdkService _revenueCatService;
  final AuthenticationService _authenticationService;
  UserSubscriptionRepositoryRevenueCat(
      this._revenueCatService, this._authenticationService);

  @override
  Future<UserSubscription> getSubscription() async {
    try {
      final customerInfo = await _revenueCatService.getCustomerInfo();

      final subscription = UserSubscription.fromCustomerInfo(customerInfo);

      return subscription;
    } catch (e) {
      // Handle error appropriately, maybe log it or rethrow
      throw Exception('Failed to fetch subscription: $e');
    }
  }

  @override
  Stream<UserSubscription> getSubscriptionStream() =>
      _subscriptionController.stream;

  @override
  Future<void> init() async {
    try {
      final userId = _authenticationService.currentUser?.uid;
      if (userId != null) {
        await _revenueCatService.initPlatformState(userId);
      }
      final subscription = await getSubscription();
      _subscriptionController.add(subscription);
      _revenueCatService.observeCustomerInfo((customerInfo) {
        final updatedSubscription =
            UserSubscription.fromCustomerInfo(customerInfo);
        _subscriptionController.add(updatedSubscription);
      });
      _authenticationService.observeUserChanges().listen((user) async {
        if (user != null) {
          if(await _revenueCatService.isConfigured) {
            _revenueCatService.login(user.uid);
          } else {
            _revenueCatService.initPlatformState(user.uid);
          }
          
        }
      });
      _isInitialized = true;
    } catch (e) {
      // Handle initialization error, maybe log it or rethrow
      throw Exception('Failed to initialize subscription repository: $e');
    }
  }

  @override
  Future<void> restorePurchases() async {
    try {
      final customerInfo = await _revenueCatService.restorePurchases();
      final restoredSubscription =
          UserSubscription.fromCustomerInfo(customerInfo);
      _subscriptionController.add(restoredSubscription);
    } catch (e) {
      // Handle error appropriately, maybe log it or rethrow
      throw Exception('Failed to restore purchases: $e');
    }
  }
}
