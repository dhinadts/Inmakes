import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Screens
import 'package:food_app/feature/auth/providers/authwrapper.dart';
import 'package:food_app/feature/ui/booking_list_screen.dart';
import 'package:food_app/feature/ui/food_menu_screen.dart';
import 'package:food_app/feature/ui/login_screen.dart';
import 'package:food_app/feature/ui/order_list_screen.dart';
import 'package:food_app/feature/ui/register_screen.dart';
import 'package:food_app/feature/ui/user_list.dart';

// Firebase options
import 'firebase_options.dart';

// Providers
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth': (context) => const AuthWrapper(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/food-menu': (context) => const FoodMenuScreen(),
        '/orders': (context) => const OrderListScreen(),
        '/bookings': (context) => const BookingListScreen(),
        '/users': (context) => const UserListScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/auth');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Food App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
