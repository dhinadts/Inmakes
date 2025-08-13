import 'package:flutter/foundation.dart';
import 'package:food_app/app/modules/admob_helper/controllers/admob_helper_controller.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController extends GetxController {
  AdmobHelper admobHelper = AdmobHelper();
  late BannerAd bannerAd;
  final RxBool isAdLoaded = false.obs;
  var args = Get.arguments;
  RxString userName = ''.obs;
  RxString userId = ''.obs;
  RxString role = ''.obs;
  @override
  void onInit() async {
    super.onInit();
    role.value = Get.arguments![0]['role'] ?? "";
    if (role.value != null || role.value.isEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      role.value = prefs.getString("role") ?? "User";
    } else {
      role.value = "User";
    }
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
