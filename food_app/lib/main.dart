import 'package:flutter/material.dart';
import 'package:food_app/app/modules/common_theme/controllers/common_theme_controller.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize and load theme preference
  final themeController = Get.put(CommonThemeController());
  await themeController.loadTheme();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<CommonThemeController>();

    return Obx(() => GetMaterialApp(
          title: "Food App",
          initialRoute: Routes.SPLASH_SCREEN, // Start with splash
          getPages: AppPages.routes,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeController.themeMode,
          debugShowCheckedModeBanner: false,
        ));
  }
}
