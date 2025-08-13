import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AdminDashboardController());
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Row
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Greater Kailash, New Delhi',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Change',
                      style: TextStyle(color: Colors.deepOrangeAccent),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Restaurants',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1.5,
                    child: InkWell(
                      onTap: () {
                        Get.dialog(
                          AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            title: const Text('Enter Food Order'),
                            content: TextField(
                              controller: controller.foodController,
                              decoration: const InputDecoration(
                                hintText: 'e.g. Chicken Biryani',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: controller.submitOrder,
                                child: const Text('Order'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue,
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.food_bank),
                            Text(
                              'Food Order',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Find nearby restaurants',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1.5,
                    child: InkWell(
                      onTap: () {
                        Get.dialog(
                          AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            title: const Text('Enter Table Number'),
                            content: TextField(
                              controller: controller.tableNumber,
                              decoration: const InputDecoration(
                                hintText: 'e.g. 5',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: controller.submitTableNumber,
                                child: const Text('Order'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        // color: Colors.blue,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.red,
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.table_restaurant),
                            Text(
                              'Book a Table',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'may take up to 3 mins',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Collections Section
            Text(
              'GET INSPIRED BY COLLECTIONS',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _collectionCard(
                    'Gym Lover',
                    '@E123',
                    'https://example.com/gym.jpg',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _collectionCard(
                    'Live Music',
                    '@E123',
                    'https://example.com/music.jpg',
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Bakery Section
            Text(
              'CAKE, ICE CREAM AND BAKERY',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _foodCard('Bread', 'https://example.com/bread.jpg'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _foodCard(
                    'Dessert with Strawberries',
                    'https://example.com/dessert.jpg',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _collectionCard(String title, String price, String imageUrl) {
    return Column(
      children: [
        Image.network(imageUrl, height: 100, fit: BoxFit.cover),
        SizedBox(height: 5),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Starts from $price'),
      ],
    );
  }

  Widget _foodCard(String name, String imageUrl) {
    return Column(
      children: [
        Image.network(imageUrl, height: 100, fit: BoxFit.cover),
        SizedBox(height: 5),
        Text(name),
      ],
    );
  }
}
