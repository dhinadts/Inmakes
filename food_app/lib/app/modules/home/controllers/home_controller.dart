import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  final count = 0.obs;
  final role = ''.obs; // 👈 Observable role

  @override
  void onInit() {
    super.onInit();
    fetchUserRole();
  }

  void fetchUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      role.value = doc.data()?['role'] ?? 'User';
    }
  }

  void increment() => count.value++;
}
