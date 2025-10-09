import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FoodOrderController extends GetxController {
  final orders = <Map<String, dynamic>>[].obs;

  Future<void> placeOrder(
    List<Map<String, dynamic>> items,
    double total,
  ) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final orderData = {
      'userId': userId,
      'items': items,
      'totalAmount': total,
      'status': 'Pending',
      'createdAt': Timestamp.now(),
    };

    await FirebaseFirestore.instance.collection('orders').add(orderData);
    Get.snackbar('Order Placed', 'Your order has been submitted!');
  }

  Future<void> fetchOrders() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .get();

    orders.value = snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': status,
    });
    Get.snackbar('Status Updated', 'Order marked as $status');
    await fetchOrders();
  }
}
