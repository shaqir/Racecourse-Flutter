import 'package:racecourse_tracks/domain/models/user_subscription.dart';

abstract class UserSubscriptionRepository {
  Future<void> init(String? userId);
  Future<UserSubscription> getSubscription();
  Stream<UserSubscription> getSubscriptionStream();
  Future<void> restorePurchases();
}