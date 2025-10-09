import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';
import '../controllers/theme_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<CommonThemeController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile Settings'),
            onTap: () {
              // Navigate to profile settings
            },
          ),

          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {
              // Navigate to help and support page
            },
          ),

          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language Settings'),
            onTap: () {
              // Navigate to language settings
            },
          ),
          Obx(
            () => SwitchListTile(
              title: const Text('Dark Mode'),
              value: themeController.themeMode.value == ThemeMode.dark,
              onChanged: (val) => themeController.toggleTheme(val),
              secondary: const Icon(Icons.brightness_6),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Account Settings'),
            onTap: () {
              // Navigate to account settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Reset Password'),
            onTap: () {
              Get.toNamed('/reset-password');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Handle logout functionality
              // Get.offNamed(pages.login);
              FirebaseAuth.instance
                  .signOut()
                  .then((_) {
                    Get.offAllNamed('/login');
                  })
                  .catchError((error) {
                    Get.snackbar('Error', 'Failed to logout: $error');
                  });
            },
          ),
        ],
      ),
    );
  }
}
