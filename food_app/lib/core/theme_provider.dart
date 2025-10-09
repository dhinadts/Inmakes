import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// final themeProvider = NotifierProvider<ThemeController, ThemeMode>(() => ThemeController());
final themeProvider = NotifierProvider<ThemeController, ThemeMode>(
  ThemeController.new,
);

class ThemeController extends Notifier<ThemeMode> {
  ThemeController([this._initial]);

  final ThemeMode? _initial;

  @override
  ThemeMode build() => _initial ?? ThemeMode.system;

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
  }
}
