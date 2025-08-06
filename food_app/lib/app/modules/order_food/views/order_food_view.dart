import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/order_food_controller.dart';

class OrderFoodView extends GetView<OrderFoodController> {
  const OrderFoodView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OrderFoodView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OrderFoodView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
