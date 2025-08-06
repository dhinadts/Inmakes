import 'package:flutter/material.dart';
import 'package:food_app/app/modules/settings/controllers/theme_controller.dart';
import 'package:food_app/firebase_options.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(FirebaseAuth.instance);
  // Initialize Firebase Auth
  // final auth = FirebaseAuth.instance;
  // auth.useAuthEmulator('localhost', 9099); // Use emulator for testing
  // Initialize and load theme preference
  final themeController = Get.put(CommonThemeController());
  await themeController.loadTheme();
  // WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<CommonThemeController>();

    return Obx(
      () => GetMaterialApp(
        title: "Food App",
        initialRoute: Routes.SPLASH_SCREEN, // Start with splash
        getPages: AppPages.routes,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeController.themeMode.value,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
