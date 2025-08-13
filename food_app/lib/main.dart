import 'package:flutter/material.dart';
import 'package:food_app/app/modules/settings/controllers/theme_controller.dart';
import 'package:food_app/firebase_options.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool state = true;

  @override
  void initState() {
    super.initState();
    prefs();
  }

  void prefs() async {
    SharedPreferences? pref = await SharedPreferences.getInstance();
    if (pref.getBool('isFirstTime') == null || pref.getBool('isFirstTime')!) {
      setState(() => state = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<CommonThemeController>();

    return Obx(
      () => GetMaterialApp(
        title: "Food App",
        initialRoute: state
            ? Routes.SPLASH_SCREEN
            : Routes.HOME, // Start with splash
        getPages: AppPages.routes,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeController.themeMode.value,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
/* 
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the user is logged in
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user != null) {
            // Optional: check user role from Firestore if needed
            return const AdminDashboardScreen(role: 'Admin'); // or 'User'
          } else {
            return const LoginScreen();
          }
        }

        // While checking auth status
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
 */