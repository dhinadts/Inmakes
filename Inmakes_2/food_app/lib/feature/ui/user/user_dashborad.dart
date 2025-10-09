// lib/screens/user_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/common/models/booking_model.dart';
import 'package:food_app/common/models/food_item_model.dart';
import 'package:food_app/common/models/order_model.dart';
import 'package:food_app/feature/auth/providers/core_provider.dart';

class UserDashboardScreen extends ConsumerWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseService = ref.watch(firebaseServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome User'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Available Food Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            FutureBuilder<List<FoodItem>>(
              future: firebaseService.fetchFoodItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No food items available.');
                }

                final foodItems = snapshot.data!;
                return SizedBox(
                  height: 160,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: foodItems.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final item = foodItems[index];
                      return Card(
                        elevation: 3,
                        child: Container(
                          width: 140,
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(item.imageUrl, height: 60, fit: BoxFit.cover),
                              const SizedBox(height: 6),
                              Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('₹${item.price.toStringAsFixed(2)}'),
                              Text(item.isAvailable ? 'Available' : 'Out of Stock',
                                  style: TextStyle(color: item.isAvailable ? Colors.green : Colors.red)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            const Text('Your Recent Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            FutureBuilder<List<Order_model>>(
              future: firebaseService.fetchOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No recent orders.');
                }

                final orders = snapshot.data!;
                return Column(
                  children: orders.map((order) => ListTile(
                    title: Text('Order #${order.id}'),
                    subtitle: Text('Status: ${order.status}\nTotal: ₹${order.totalAmount.toStringAsFixed(2)}'),
                  )).toList(),
                );
              },
            ),

            const SizedBox(height: 20),
            const Text('Your Table Bookings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            FutureBuilder<List<Booking>>(
              future: firebaseService.fetchBookings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No bookings found.');
                }

                final bookings = snapshot.data!;
                return Column(
                  children: bookings.map((booking) => ListTile(
                    title: Text('Table #${booking.tableNumber}'),
                    subtitle: Text('Guests: ${booking.guestCount}\nStatus: ${booking.status}'),
                  )).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
