import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  RxString role = ''.obs; // 👈 safer with nullable observable

  @override
  void onInit() async {
    super.onInit();
    // Initialize any necessary data here
    await handleNavigation(Get.find<FirebaseAuth>().currentUser!);
  }

  Future<void> fetchUserRole(String uid) async {
    // Get.lazyPut(() => FirebaseAuth());
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    role.value = doc.data()?['role'] ?? '';
  }

  Future<void> handleNavigation(User user) async {
    await fetchUserRole(user.uid); // fetch latest role

    final userRole = role.value;
    Get.offNamed(
      '/dashboard',
      arguments: [
        {"userName": user.displayName ?? '', 'role': userRole},
      ],
    );
  }
}
