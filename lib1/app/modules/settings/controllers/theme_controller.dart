import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonThemeController extends GetxController {
  var themeMode = ThemeMode.light.obs;

  void toggleTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(themeMode.value);
  }

  Future<void> loadTheme() async {
    // Load saved theme from SharedPreferences or other source if needed
    // themeMode.value = retrievedTheme;
    Get.changeThemeMode(themeMode.value);
  }
}
