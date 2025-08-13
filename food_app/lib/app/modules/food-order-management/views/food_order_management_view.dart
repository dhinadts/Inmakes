import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/food_order_management_controller.dart';

class FoodOrderListView extends StatelessWidget {
  const FoodOrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FoodOrderController());
    controller.fetchOrders();

    return Scaffold(
      appBar: AppBar(title: const Text("Orders")),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return ListTile(
              title: Text("Order: ₹${order['totalAmount']}"),
              subtitle: Text("Status: ${order['status']}"),
              onTap: () {
                // Navigate to detail view
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add Restaurant'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        // controller: controller.restaurantNameController,
                        decoration: const InputDecoration(
                          labelText: 'Restaurant Name',
                        ),
                      ),
                      TextField(
                        // controller: controller.restaurantLocationController,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                        ),
                      ),
                      TextField(
                        // controller: controller.restaurantImageController,
                        decoration: const InputDecoration(
                          labelText: 'Image URL',
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      // await controller.addRestaurant();
                      // Navigator.of(context).pop();
                      Get.back();
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
