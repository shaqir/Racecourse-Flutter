import 'dart:async';

import 'package:racecourse_tracks/data/repositories/user_subscription/user_subscription_repository.dart';
import 'package:racecourse_tracks/data/services/revenue_cat_service.dart';
import 'package:racecourse_tracks/domain/models/user_subscription.dart';

class SubscriptionRepositoryRevenueCat implements SubscriptionRepository {
  final _subscriptionController = StreamController<UserSubscription>.broadcast();
  final RevenueCatService _revenueCatService;
  SubscriptionRepositoryRevenueCat(this._revenueCatService);
  
  @override
  Future<UserSubscription> getSubscription() async {
    try {
      final customerInfo = await _revenueCatService.getCustomerInfo();
      final activeEntitlements = customerInfo.entitlements.active.keys.toList();
      final subscription = UserSubscription(activeEntitlements: activeEntitlements);
      
      return subscription;
    } catch (e) {
      // Handle error appropriately, maybe log it or rethrow
      throw Exception('Failed to fetch subscription: $e');
    }
  }
  
  @override
  Stream<UserSubscription> getSubscriptionStream() => _subscriptionController.stream;
  
  @override
  Future<void> init(String? userId) async {
    try {
      await _revenueCatService.initPlatformState(userId);
      final subscription = await getSubscription();
      _subscriptionController.add(subscription);
    } catch (e) {
      // Handle initialization error, maybe log it or rethrow
      throw Exception('Failed to initialize subscription repository: $e');
    }
  }
  
}