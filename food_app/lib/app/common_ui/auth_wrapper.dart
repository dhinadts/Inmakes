import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<String> fetchUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      return doc.data()?['role'] ?? 'User';
    }
    return 'User';
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
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user != null) {
            handleNavigation(user);
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            Get.toNamed('/login');
            return const SizedBox(); // placeholder while navigating
          }
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
