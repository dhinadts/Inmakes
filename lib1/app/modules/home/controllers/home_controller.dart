import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  RxString role = ''.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initUser(); // safely run after build
    });
  }

  Future<void> _initUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User not signed in — handle accordingly
      Get.offNamed('/login');
      return;
    }

    await handleNavigation(user);
  }

  Future<String> fetchUserRole(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final fetchedRole = doc.data()?['role'] ?? 'User';
    role.value = fetchedRole;
    return fetchedRole;
  }

  Future<void> handleNavigation(User user) async {
    final fetchedRole = await fetchUserRole(user.uid);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("role", fetchedRole);

    print("role.value ==== $fetchedRole");

    Get.offNamed(
      '/dashboard',
      arguments: [{"userName": user.displayName ?? '', "role": fetchedRole}],
    );
  }
}
