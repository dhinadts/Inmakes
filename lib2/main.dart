import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'core/theme_provider.dart';
import 'auth/login_screen.dart';
import 'features/admin/admin_dashboard.dart';
import 'features/user/user_dashboard.dart';
import 'auth/user_provider.dart';
import 'settings/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MobileAds.instance.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Load persisted theme
  final prefs = await SharedPreferences.getInstance();
  final initialTheme =
      ThemeMode.values[prefs.getInt('themeMode') ?? ThemeMode.system.index];

  runApp(
    ProviderScope(
      /* overrides: [
        // ✅ Correct way to override provider with an initial value
        themeProvider.overrideWith(() => ThemeController(initialTheme)),
      ], */
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food App',
      themeMode: themeMode,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      routes: {'/settings': (_) => const SettingsScreen()},
      home: authState.when(
        data: (user) {
          if (user == null) return const LoginScreen();
          // role-based routing
          final role = ref.watch(userRoleProvider).value ?? 'user';
          if (role == 'admin') return const AdminDashboard();
          return const UserDashboard();
        },
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(body: Center(child: Text('Auth error: $e'))),
      ),
    );
  }
}
