import 'package:racecourse_tracks/domain/models/user_subscription.dart';

abstract class UserSubscriptionRepository {
  bool get isInitialized;

  Future<void> init();
  Future<UserSubscription> getSubscription();
  Stream<UserSubscription> getSubscriptionStream();
  Future<void> restorePurchases();
}