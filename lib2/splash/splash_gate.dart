import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_screen.dart';
import '../features/admin/admin_dashboard.dart';
import '../features/user/user_dashboard.dart';
import 'first_run_splash.dart';
import 'returning_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/user_provider.dart';

class SplashGate extends ConsumerStatefulWidget {
  const SplashGate({super.key});

  @override
  ConsumerState<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends ConsumerState<SplashGate> {
  Future<Widget> _decideStart() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('seenSplash') ?? false;
    if (!seen) {
      await prefs.setBool('seenSplash', true);
      return const FirstRunSplash();
    } else {
      return const ReturningSplash();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _decideStart(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data!;
      },
    );
  }
}

// Helper to go to app home after splash
void navigateToHome(BuildContext context, WidgetRef ref) {
  final authState = ref.read(authStateProvider);
  authState.when(
    data: (user) {
      if (user == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        final role = ref.read(userRoleProvider).value ?? 'User';
        if (role == 'Admin') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AdminDashboard()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const UserDashboard()),
          );
        }
      }
    },
    loading: () {},
    error: (e, _) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    },
  );
}
