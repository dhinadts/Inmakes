import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonThemeController extends GetxController {
  //TODO: Implement CommonThemeController

  final _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('themeMode') ?? 'system';

    switch (mode) {
      case 'light':
        _themeMode.value = ThemeMode.light;
        break;
      case 'dark':
        _themeMode.value = ThemeMode.dark;
        break;
      default:
        _themeMode.value = ThemeMode.system;
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode.value = mode;
    final prefs = await SharedPreferences.getInstance();

    switch (mode) {
      case ThemeMode.light:
        await prefs.setString('themeMode', 'light');
        break;
      case ThemeMode.dark:
        await prefs.setString('themeMode', 'dark');
        break;
      case ThemeMode.system:
        await prefs.setString('themeMode', 'system');
        break;
    }

    Get.changeThemeMode(mode);
  }
}
