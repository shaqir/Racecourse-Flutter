import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  Future<void> initPlatformState(String? userId) async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration? configuration;
    if (Platform.isAndroid) {
      configuration =
          PurchasesConfiguration('goog_PevjRLZbPmzIzqonIuJepYxRTFD');
    } else if (Platform.isIOS) {
      configuration =
          PurchasesConfiguration('appl_LWkZCDzPNvftRfOdkTRtuEpIMcJ');
    }
    if (userId != null && userId.isNotEmpty) {
      configuration!.appUserID = userId;
    }
    configuration!.entitlementVerificationMode =
        EntitlementVerificationMode.disabled;
    await Purchases.configure(configuration);
  }

  Future<CustomerInfo> getCustomerInfo() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      switch (customerInfo.entitlements.verification) {
        // No verification was done.
        //
        // This can happen for multiple reasons:
        //  1. Verification is not enabled in Configuration
        //  2. Verification can't be performed prior to Android 4.4
        case VerificationResult.notRequested:

        // Entitlements were verified with our server.
        case VerificationResult.verified:

        // Entitlements were verified on device.
        case VerificationResult.verifiedOnDevice:
          // Grant access
          break;

        // Entitlement verification failed, possibly due to a MiTM attack.
        case VerificationResult.failed:
          // Failed verification
          if (kDebugMode) {
            print('Entitlement verification failed. Please check your configuration.');
          }
          Purchases.invalidateCustomerInfoCache();
          throw Exception('Entitlement verification failed. Please check your configuration.');
      }
      return customerInfo;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching customer info: $e');
      }
      rethrow;
    }
  }

  void observeCustomerInfo(void Function(CustomerInfo customerInfo) onUpdate) {
    Purchases.addCustomerInfoUpdateListener(onUpdate);
  }

  Future<CustomerInfo> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      return customerInfo;
    } catch (e) {
      if (kDebugMode) {
        print('Error restoring purchases: $e');
      }
      rethrow;
    }
  }
}
