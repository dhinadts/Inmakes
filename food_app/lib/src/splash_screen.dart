import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import 'ui/user/user_dashboard.dart';
import 'ui/admin/admin_dashboard.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () async {
      // After splash, navigate to a simple role-based home (for demo)
      // In real app: check auth & role from Firestore
      final isAdmin = false; // toggle while testing
      if (isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UserDashboard()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlutterLogo(size: 96),
            SizedBox(height: 16),
            Text('Welcome', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
