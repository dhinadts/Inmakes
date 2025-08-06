import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderFoodController extends GetxController {
  var foodName = ''.obs;
  final foodController = TextEditingController();

  void submitOrder() {
    if (foodController.text.trim().isNotEmpty) {
      foodName.value = foodController.text.trim();
      Get.back(); // Close the dialog
      Get.snackbar('Order Placed', 'You ordered: ${foodName.value}');
    } else {
      Get.snackbar('Error', 'Please enter a food item');
    }
  }

  @override
  void onClose() {
    foodController.dispose();
    super.onClose();
  }
}
