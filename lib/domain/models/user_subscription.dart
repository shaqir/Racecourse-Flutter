import 'package:purchases_flutter/object_wrappers.dart';

class UserSubscription {
  final String subscriptionName;
  final List<String> activeEntitlements;

  UserSubscription({required this.subscriptionName, required this.activeEntitlements});

  // Factory constructor to create a UserSubscription from a CustomerInfo object
  factory UserSubscription.fromCustomerInfo(CustomerInfo customerInfo) {
    final activeEntitlements = customerInfo.entitlements.active.keys.toList();
    final subscriptionName = customerInfo.entitlements.active.isEmpty
        ? 'Free'
        : customerInfo.entitlements.active.values.first.periodType ==
                PeriodType.trial
            ? 'Trial'
            : 'Pro';

    return UserSubscription(
      subscriptionName: subscriptionName,
      activeEntitlements: activeEntitlements,
    );
  }
}
