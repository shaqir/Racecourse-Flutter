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
    if(userId != null && userId.isNotEmpty) {
      configuration!.appUserID = userId;
    }
    await Purchases.configure(configuration!);
  }

  Future<CustomerInfo> getCustomerInfo() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching customer info: $e');
      }
      rethrow;
    }
  }
}
