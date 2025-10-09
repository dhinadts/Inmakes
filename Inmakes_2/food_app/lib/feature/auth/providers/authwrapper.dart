import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/feature/ui/login_screen.dart';
import 'package:food_app/feature/ui/admin_dashboard.dart';
import 'package:food_app/main.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  Future<Map<String, dynamic>?> _getUserRoleAndId(User user) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        final role = data?['role'] ?? 'User'; // default to 'User' if role not found
        return {'role': role, 'userId': user.uid};
      }
    } catch (e) {
      print('Error fetching role: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        } else {
          return FutureBuilder<Map<String, dynamic>?>(
            future: _getUserRoleAndId(user),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              } else if (snapshot.hasError || !snapshot.hasData) {
                return Center(child: Text('Failed to load user data'));
              } else {
                final role = snapshot.data!['role'];
                final userId = snapshot.data!['userId'];
                return AdminDashboardScreen(role: role, userId: userId);
              }
            },
          );
        }
      },
      loading: () => const SplashScreen(),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
