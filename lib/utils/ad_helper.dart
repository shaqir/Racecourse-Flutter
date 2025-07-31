import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8634282195801788/6539747754';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8634282195801788/7320114402';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}