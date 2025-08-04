import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/common_theme_controller.dart';

class CommonThemeView extends GetView<CommonThemeController> {
  const CommonThemeView({super.key});
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<CommonThemeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Theme',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Obx(() => Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('Light Mode'),
                  value: ThemeMode.light,
                  groupValue: themeController.themeMode,
                  onChanged: (value) => themeController.setTheme(value!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark Mode'),
                  value: ThemeMode.dark,
                  groupValue: themeController.themeMode,
                  onChanged: (value) => themeController.setTheme(value!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('System Default'),
                  value: ThemeMode.system,
                  groupValue: themeController.themeMode,
                  onChanged: (value) => themeController.setTheme(value!),
                ),
              ],
            )),
      ],
    );
  }
}