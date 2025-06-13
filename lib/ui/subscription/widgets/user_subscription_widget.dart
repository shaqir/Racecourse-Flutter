import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/ui/subscription/view_model/user_subscription_view_model.dart';
import 'package:racecourse_tracks/utils/request_state.dart';

class UserSubscriptionWidget extends StatelessWidget {
  const UserSubscriptionWidget({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserSubscriptionViewModel>(context);
    if(viewModel.loadingSubscriptionRequestState == RequestState.pending) {
      return Center(child: CircularProgressIndicator());
    }
    if(viewModel.loadingSubscriptionRequestState == RequestState.failed) {
      return Center(child: Text('Failed to load subscription', style: TextStyle(color: Colors.red)));
    }
    return Center(child: Text(viewModel.userSubscription!.subscriptionName, style: TextStyle(color: ColorScheme.of(context).onPrimary),));
  }
}