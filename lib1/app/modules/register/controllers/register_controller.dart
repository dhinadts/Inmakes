import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  // Role selection: 'User' or 'Admin'
  final selectedRole = 'User'.obs;

  bool get isEmailValid {
    final pattern = RegExp(r'^[a-z0-9.]+@gmail\.com$');
    return pattern.hasMatch(emailController.text.trim());
  }

  void register() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim().toLowerCase(),
            password: passwordController.text.trim(),
          );

      final uid = userCredential.user?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'email': emailController.text.trim().toLowerCase(),
          'role': selectedRole.value, // 👈 Store selected role
          'createdAt': Timestamp.now(),
        });
      }

      Get.snackbar(
        'Success',
        'Registered as ${selectedRole.value}',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Sign-up Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.onClose();
  }
}
