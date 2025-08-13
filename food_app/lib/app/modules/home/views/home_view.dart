import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            debugPrint("${user}user details");

            if (user != null) {
              // Defer role fetch + navigation after current frame
              WidgetsBinding.instance.addPostFrameCallback((_) {
                controller.handleNavigation(user);
              });
              return const Center(child: CircularProgressIndicator());
            }
            if (user == null || user.email == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.offNamed('/login');
              });
              return const SizedBox(); // placeholder
            }
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
/* 
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            if (user != null) {
              // Defer navigation to after build phase
              Future.microtask(() => controller.handleNavigation(user));
              return const Center(child: CircularProgressIndicator());
            } else {
              Future.microtask(
                () => Get.offNamedUntil('/login', (route) => false),
              );
              return const SizedBox(); // lightweight placeholder
            }
          }

          // Optional: implement your own splash screen here
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
 */