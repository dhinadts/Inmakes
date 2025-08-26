import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = NotifierProvider<ThemeController, ThemeMode>(() => ThemeController());

class ThemeController extends Notifier<ThemeMode> {
  ThemeController([ThemeMode? initial]) {
    if (initial != null) state = initial;
  }

  @override
  ThemeMode build() => ThemeMode.system;

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
  }
}
