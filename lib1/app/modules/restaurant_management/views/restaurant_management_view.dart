import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/restaurant_management_controller.dart';

class RestaurantManagementView extends GetView<RestaurantManagementController> {
  const RestaurantManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Management'),
        centerTitle: true,
      ),
      body: Container(
        height: Get.height * 0.9,
        padding: const EdgeInsets.all(4),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: controller.restaurantStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No Restaurants Available',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            final restaurants = snapshot.data!;
            return GridView.builder(
              itemCount: restaurants.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        restaurant['imageUrl'] != null &&
                                restaurant['imageUrl'].toString().isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  restaurant['imageUrl'],
                                  height: 75,
                                  width: 75,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) =>
                                      const Icon(Icons.broken_image, size: 50),
                                ),
                              )
                            : const Icon(
                                Icons.restaurant,
                                size: 50,
                                color: Colors.teal,
                              ),
                        // const SizedBox(height: 8),
                        Text(
                          restaurant['name'] ?? 'Restaurant Name',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // const SizedBox(height: 4),
                        Text(
                          restaurant['location'] ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                controller.selectedRestaurant.value =
                                    restaurant['restaurantId'];
                                controller.restaurantNameController.text =
                                    restaurant['name'] ?? '';
                                controller.restaurantLocationController.text =
                                    restaurant['location'] ?? '';
                                controller.restaurantImageController.text =
                                    restaurant['imageUrl'] ?? '';
                                // Show edit dialog or bottom sheet
                              },
                              icon: const Icon(Icons.edit, color: Colors.teal),
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              onPressed: () {
                                // Confirm before deleting
                                // controller.deleteRestaurant(restaurant['restaurantId']);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Delete',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
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
                        controller: controller.restaurantNameController,
                        decoration: const InputDecoration(
                          labelText: 'Restaurant Name',
                        ),
                      ),
                      TextField(
                        controller: controller.restaurantLocationController,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                        ),
                      ),
                      TextField(
                        controller: controller.restaurantImageController,
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
                      await controller.addRestaurant();
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
