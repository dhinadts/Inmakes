import 'package:flutter/material.dart';
import 'package:food_app/settings/settings_screen.dart';
import 'food_list_screen.dart';
import 'order_list_screen.dart';
import 'booking_list_screen.dart';

import 'table_management_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TableManagementScreen()),
            ),
            icon: const Icon(Icons.table_bar),
            tooltip: 'Manage Tables',
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
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          _card(context, 'Food Menu', Icons.fastfood, const FoodListScreen()),
          _card(context, 'Orders', Icons.receipt_long, const OrderListScreen()),
          _card(
            context,
            'Bookings',
            Icons.event_seat,
            const BookingListScreen(),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext ctx, String title, IconData icon, Widget page) {
    return Card(
      child: InkWell(
        onTap: () =>
            Navigator.push(ctx, MaterialPageRoute(builder: (_) => page)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 42),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
