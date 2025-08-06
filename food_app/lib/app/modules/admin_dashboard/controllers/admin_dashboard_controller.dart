import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboardController extends GetxController {
  var foodName = ''.obs;
  final foodController = TextEditingController();
  final isLoading = false.obs;
  final tableNumber = TextEditingController();
  void submitOrder() {
    if (foodController.text.trim().isNotEmpty) {
      foodName.value = foodController.text.trim();
      Get.back(); // Close the dialog
      Get.snackbar('Order Placed', 'You ordered: ${foodName.value}');
    } else {
      Get.snackbar('Error', 'Please enter a food item');
    }
  }

  void submitTableNumber() {
    if (tableNumber.text.trim().isNotEmpty) {
      Get.back(); // Close the dialog
      Get.snackbar(
        'Table Number',
        'You booked table: ${tableNumber.text.trim()}',
      );
    } else {
      Get.snackbar('Error', 'Please enter a table number');
    }
  }

  Rx<String> userId = ''.obs;
}
