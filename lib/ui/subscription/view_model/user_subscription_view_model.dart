import 'package:flutter/foundation.dart';
import 'package:racecourse_tracks/data/repositories/user_subscription/user_subscription_repository.dart';
import 'package:racecourse_tracks/domain/models/user_subscription.dart';
import 'package:racecourse_tracks/utils/request_state.dart';

class UserSubscriptionViewModel extends ChangeNotifier {
  UserSubscriptionViewModel({
    required UserSubscriptionRepository userSubscriptionRepository,
  }) : _userSubscriptionRepository = userSubscriptionRepository {
    userSubscriptionRepository
        .getSubscriptionStream()
        .listen((subscription) {
      _userSubscription = subscription;
      notifyListeners();
    });
    _loadUserSubscription();
  }

  final UserSubscriptionRepository _userSubscriptionRepository;
  UserSubscription? _userSubscription;
  UserSubscription? get userSubscription => _userSubscription;
  RequestState _loadingSubscriptionRequestState = RequestState.idle;
  RequestState get loadingSubscriptionRequestState =>
      _loadingSubscriptionRequestState;
  
  void _loadUserSubscription() async {
    _loadingSubscriptionRequestState = RequestState.pending;
    notifyListeners();
    try {
      _userSubscription = await _userSubscriptionRepository.getSubscription();
      _loadingSubscriptionRequestState = RequestState.completed;
      notifyListeners();
    } catch (e) {
      _loadingSubscriptionRequestState = RequestState.failed;
      notifyListeners();
      // Handle error appropriately, maybe log it or show a message
      if (kDebugMode) {
        print('Error loading user subscription: $e');
      }
    }
  }
}