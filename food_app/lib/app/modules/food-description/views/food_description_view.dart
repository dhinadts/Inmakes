import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/food_description_controller.dart';

class FoodDescriptionView extends GetView<FoodDescriptionController> {
  const FoodDescriptionView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => FoodDescriptionController());
    return Scaffold(
      appBar: AppBar(title: Obx(() => Text(controller.title.value))),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Image.network(controller.imageUrl.value),
            ), // Replace with actual image URL
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  controller.title.value,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              children: List.generate(
                4,
                (index) => Icon(Icons.circle, color: Colors.green),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: Colors.blue,
                    child: Text('Offer', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 8),
                  Text('Save 14% on each night'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ChoiceChip(label: Text('Veg Only'), selected: false),
                  SizedBox(width: 8),
                  ChoiceChip(label: Text('Non-Veg Only'), selected: true),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.delivery_dining),
                  SizedBox(width: 8),
                  Text('Delivery by YumFood. with online tracking'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Est. food delivery time'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'WHAT PEOPLE LOVE HERE',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Image.network(
                        'https://example.com/item1.jpg',
                      ), // Replace with actual image URL
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('View Menu'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Image.network(
                        'https://example.com/item2.jpg',
                      ), // Replace with actual image URL
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('View Menu'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '\$1,790',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {},
                child: Text('View Bill Details'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: () {}, child: Text('Order Now')),
            ),
          ],
        ),
      ),
    );
  }
}
