import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthWrapper extends StatelessWidget {
   AuthWrapper({super.key});

  String role = "";
  Future<String> fetchUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      role = doc.data()?['role'] ?? '';
      return doc.data()?['role'] ?? 'User';
    }
    return '';
  }

  void handleNavigation(User user) async {
    final role = await fetchUserRole();
    if (role == 'Admin') {
      Get.toNamed('/dashboard', arguments: {'role': 'Admin'});
    } else {
      Get.toNamed('/dashboard', arguments: {'role': 'User'});
    }
  }

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
            Get.toNamed('/dashboard', arguments: {'role': role});
            return Center(child: CircularProgressIndicator()); // or 'User'
          } else {
            Get.toNamed('/login');

            return Center(child: CircularProgressIndicator()); // or 'User'
          }
        }

        // While checking auth status
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
/* class AuthWrapper extends StatelessWidget {
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