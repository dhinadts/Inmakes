import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/food_order_management_controller.dart';

class FoodOrderManagementView extends GetView<FoodOrderManagementController> {
  const FoodOrderManagementView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FoodOrderManagementView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'FoodOrderManagementView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
