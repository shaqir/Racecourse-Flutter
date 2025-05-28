import 'package:racecourse_tracks/domain/models/user_subscription.dart';

abstract class SubscriptionRepository {
  Future<void> init(String? userId);
  Future<UserSubscription> getSubscription();
  Stream<UserSubscription> getSubscriptionStream();
}