import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'food_menu_screen.dart';
import 'cart_screen.dart';
import 'bookings_screen.dart';
import '../../settings/settings_screen.dart';

import 'table_selection_screen.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food App'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartScreen()),
              );
            },
            icon: Icon(Icons.shopping_cart),
          ),

          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📍 Location Row
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Greater Kailash, New Delhi',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Change',
                      style: TextStyle(color: Colors.deepOrangeAccent),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 🔍 Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Restaurants',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🔳 Dashboard Grid
            GridView.count(
              shrinkWrap: true, // ✅ allows Grid inside scroll view
              physics:
                  const NeverScrollableScrollPhysics(), // ✅ prevents nested scrolling
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _card(
                  context,
                  'Choose Table',
                  Icons.table_bar,
                  const TableSelectionScreen(),
                ),
                _card(
                  context,
                  'Food order',
                  Icons.fastfood,
                  const FoodMenuScreen(),
                ),

                _card(
                  context,
                  'Bookings',
                  Icons.event_seat,
                  const BookingsScreen(),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 🎯 Collections Section
            // 🎯 Collections Section
            Text(
              'GET INSPIRED BY COLLECTIONS',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 180, // fixed height for horizontal list
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _collectionCard(
                    'Gym Lover',
                    '@E123',
                    'https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/FOOD_CATALOG/IMAGES/CMS/2024/8/25/d0e53205-1d47-4e2a-ae5a-45f4a58f2d8e_461f5662-1c59-4895-aab2-83a16934cd42.jpeg',
                  ),
                  const SizedBox(width: 10),
                  _collectionCard(
                    'Live Music',
                    '@E123',
                    'https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/FOOD_CATALOG/IMAGES/CMS/2024/8/25/d0e53205-1d47-4e2a-ae5a-45f4a58f2d8e_461f5662-1c59-4895-aab2-83a16934cd42.jpeg',
                  ),
                  const SizedBox(width: 10),
                  _collectionCard(
                    'Family Dining',
                    '@E123',
                    'https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/FOOD_CATALOG/IMAGES/CMS/2024/8/25/d0e53205-1d47-4e2a-ae5a-45f4a58f2d8e_461f5662-1c59-4895-aab2-83a16934cd42.jpeg',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🍰 Bakery Section
            Text(
              'CAKE, ICE CREAM AND BAKERY',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _foodCard(
                    'Bread',
                    'https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/FOOD_CATALOG/IMAGES/CMS/2024/8/25/d0e53205-1d47-4e2a-ae5a-45f4a58f2d8e_461f5662-1c59-4895-aab2-83a16934cd42.jpeg',
                  ),
                  const SizedBox(width: 10),
                  _foodCard(
                    'Dessert with Strawberries',
                    'https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/FOOD_CATALOG/IMAGES/CMS/2024/8/25/d0e53205-1d47-4e2a-ae5a-45f4a58f2d8e_461f5662-1c59-4895-aab2-83a16934cd42.jpeg',
                  ),
                  const SizedBox(width: 10),
                  _foodCard(
                    'Chocolate Cake',
                    'https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/FOOD_CATALOG/IMAGES/CMS/2024/8/25/d0e53205-1d47-4e2a-ae5a-45f4a58f2d8e_461f5662-1c59-4895-aab2-83a16934cd42.jpeg',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📌 Collection card widget
  Widget _collectionCard(String title, String price, String imageUrl) {
    return InkWell(
      onTap: () {
        var obj = [
          {"title": title, "price": price, "imageUrl": imageUrl},
        ];
        Get.toNamed("/food-description", arguments: obj);
      },
      child: Container(
        width: 140, // fixed card width for horizontal scroll
        margin: const EdgeInsets.only(right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _card(context, 'Choose Table', Icons.table_bar, const TableSelectionScreen()),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                height: 100,
                width: 140,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Starts from $price'),
          ],
        ),
      ),
    );
  }

  // 📌 Food card widget
  Widget _foodCard(String name, String imageUrl) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _card(context, 'Choose Table', Icons.table_bar, const TableSelectionScreen()),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              height: 100,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  // 📌 Dashboard feature card
  Widget _card(BuildContext ctx, String title, IconData icon, Widget page) {
    return Card(
      color: title == 'Cart / Checkout' ? Colors.transparent : Colors.grey,
      child: InkWell(
        onTap: () =>
            Navigator.push(ctx, MaterialPageRoute(builder: (_) => page)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // _card(context, 'Choose Table', Icons.table_bar, const TableSelectionScreen()),
              Icon(icon, size: title == 'Cart / Checkout' ? 20 : 42),
              const SizedBox(height: 8),
              title == 'Cart / Checkout'
                  ? SizedBox.shrink()
                  : Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
