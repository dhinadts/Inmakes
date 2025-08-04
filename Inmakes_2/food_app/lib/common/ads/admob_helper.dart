import 'dart:io';

class AdmobHelper {
  static String getAdUnitId() {
    // Replace with your actual Ad Unit ID
    return 'ca-app-pub-3940256099942544/6300978111';
  }

  static String getBannerAdUnitId() {
    // Replace with your actual Banner Ad Unit ID
    return 'ca-app-pub-3940256099942544/6300978111';
  }

  static String getInterstitialAdUnitId() {
    // Replace with your actual Interstitial Ad Unit ID
    return 'ca-app-pub-3940256099942544/1033173712';
  }

  static String getRewardedAdUnitId() {
    // Replace with your actual Rewarded Ad Unit ID
    return 'ca-app-pub-3940256099942544/5224354917';
  }

  static String getNativeAdUnitId() {
    // Replace with your actual Native Ad Unit ID
    return 'ca-app-pub-3940256099942544/2247696110';
  }

  static String getAppOpenAdUnitId() {
    // Replace with your actual App Open Ad Unit ID
    return 'ca-app-pub-3940256099942544/3419835294';
  }

  static String getAdUnitIdForPlatform() {
    if (Platform.isAndroid) {
      return getAdUnitId();
    } else if (Platform.isIOS) {
      return getAdUnitId();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  static String getBannerAdUnitIdForPlatform() {
    if (Platform.isAndroid) {
      return getBannerAdUnitId();
    } else if (Platform.isIOS) {
      return getBannerAdUnitId();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String getInterstitialAdUnitIdForPlatform() {
    if (Platform.isAndroid) {
      return getInterstitialAdUnitId();
    } else if (Platform.isIOS) {
      return getInterstitialAdUnitId();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  static String getRewardedAdUnitIdForPlatform() {
    if (Platform.isAndroid) {
      return getRewardedAdUnitId();
    } else if (Platform.isIOS) {
      return getRewardedAdUnitId();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  static String getNativeAdUnitIdForPlatform() {
    if (Platform.isAndroid) {
      return getNativeAdUnitId();
    } else if (Platform.isIOS) {
      return getNativeAdUnitId();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String getAppOpenAdUnitIdForPlatform() {
    if (Platform.isAndroid) {
      return getAppOpenAdUnitId();
    } else if (Platform.isIOS) {
      return getAppOpenAdUnitId();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String getInertialAdUnitIdForPlatform() {
    if (Platform.isAndroid) {
      return getAdUnitId();
    } else if (Platform.isIOS) {
      return getAdUnitId();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  static String getInertialInterstitialAdUnitIdForPlatform() {
    if (Platform.isAndroid) {
      return getInterstitialAdUnitId();
    } else if (Platform.isIOS) {
      return getInterstitialAdUnitId();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  static String getInertialRewardedAdUnitIdForPlatform() {
    if (Platform.isAndroid) {
      return getRewardedAdUnitId();
    } else if (Platform.isIOS) {
      return getRewardedAdUnitId();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  static String getInertialNativeAdUnitIdForPlatform() {
    if (Platform.isAndroid) {
      return getNativeAdUnitId();
    } else if (Platform.isIOS) {
      return getNativeAdUnitId();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String getInertialAppOpenAdUnitIdForPlatform() {
    if (Platform.isAndroid) {
      return getAppOpenAdUnitId();
    } else if (Platform.isIOS) {
      return getAppOpenAdUnitId();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  static String getInertialAdUnitId() {
    return getInertialAdUnitIdForPlatform();
  }
  static String getInertialBannerAdUnitId() {
    return getInertialBannerAdUnitIdForPlatform();
  }

  static String getInertialInterstitialAdUnitId() {
    return getInertialInterstitialAdUnitIdForPlatform();
  }

  static String getInertialRewardedAdUnitId() {
    return getInertialRewardedAdUnitIdForPlatform();
  }
  static String getInertialNativeAdUnitId() {
    return getInertialNativeAdUnitIdForPlatform();
  }
  static String getInertialAppOpenAdUnitId() {
    return getInertialAppOpenAdUnitIdForPlatform();
  }
  

  static String getInertialBannerAdUnitIdForPlatform() {
    return getInertialBannerAdUnitIdForPlatform();
  }

}