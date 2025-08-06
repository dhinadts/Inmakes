import 'package:flutter/foundation.dart';
import 'package:food_app/app/modules/admob_helper/controllers/admob_helper_controller.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class DashboardController extends GetxController {

  AdmobHelper admobHelper = AdmobHelper();
  late BannerAd bannerAd;
  final RxBool isAdLoaded = false.obs;
  var args = Get.arguments;
  RxString userName = ''.obs;
  RxString userId = ''.obs;
  @override
  void onInit() {
    super.onInit();
    bannerAd = BannerAd(
      adUnitId: AdmobHelper.getBannerAdUnitId(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => isAdLoaded.value = true,
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Ad failed to load: $error');
        },
      ),
    )..load();
    if (args != null) {
      userName.value = args[0]['userName'] ?? '';
      userId.value = args[0]['userId'] ?? '';
      debugPrint('Arguments received: $args');
    } else {
      userName.value = '';
      userId.value = '';
      debugPrint('No arguments received');
    }
  }

  
  @override
  void onClose() {
    super.onClose();
    bannerAd.dispose();
  }
}
