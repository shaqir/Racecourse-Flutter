import 'package:flutter/material.dart';

class UserSubscriptionWidget extends StatelessWidget {
  const UserSubscriptionWidget({
    super.key, required this.userSubscription,
  });
  final String userSubscription;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(userSubscription));
  }
}