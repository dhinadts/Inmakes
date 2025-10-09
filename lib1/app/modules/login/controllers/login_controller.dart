// lib/app/modules/login/controllers/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../register/views/register_view.dart';

class LoginController extends GetxController {
   TextEditingController emailController = TextEditingController();
   TextEditingController passwordController = TextEditingController();
  final isLoading = false.obs;

  bool get isEmailValid {
    final pattern = RegExp(r'^[a-z0-9.]+@gmail\.com$');
    return pattern.hasMatch(emailController.text.trim());
  }

  void login() async {
    if (!isEmailValid) {
      Get.snackbar(
        'Error',
        'Invalid email format',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final auth = FirebaseAuth.instance;
      final userCred = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = userCred.user!.uid;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final role = doc.data()?['role'] ?? 'User';
      final userId = doc.data()?['uid'] ?? uid;

      Get.offNamed('/home', arguments: {'role': role, 'userId': userId});
    } catch (e) {
      Get.snackbar(
        'Login Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.to(() => const RegisterView());
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
