// lib/app/modules/splash/controllers/splash_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_pages.dart';

class SplashScreenController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;
  final images = [
    'assets/images/splash/food_ic_walk1.svg',
    'assets/images/splash/food_ic_walk2.svg',
    'assets/images/splash/food_ic_walk3.svg',
  ];

  Future<void> nextPage(String action) async {
    if (action == 'next' && currentPage.value < images.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (action == 'prev' && currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (action == 'done') {
      SharedPreferences? pref = await SharedPreferences.getInstance();

      pref.setBool('isFirstTime', false);
      Get.offNamed('/home');
    }

    /* if (currentPage.value < images.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } */
  }

  void prevPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    Get.offNamed('/home');
  }

  Future<bool> goToLogin() async {
    SharedPreferences? pref = await SharedPreferences.getInstance();
    if (pref.getBool('isFirstTime') == null || pref.getBool('isFirstTime')!) {
      await pref.setBool('isFirstTime', false);
      Get.offNamed(Routes.HOME);
      return false;
    } else {
      await pref.setBool('isFirstTime', false);

      Get.offNamed(Routes.LOGIN);
      return true;
    }
    // Get.offNamed(Routes.LOGIN);
  }

  @override
  void onInit() async {
    super.onInit();
    SharedPreferences? pref = await SharedPreferences.getInstance();
    if (pref.getBool('isFirstTime') == null || pref.getBool('isFirstTime')!) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed(Routes.SPLASH_SCREEN);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamedUntil(Routes.HOME, (route) => false);
      });
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
