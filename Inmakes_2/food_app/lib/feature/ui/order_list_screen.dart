import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/common/models/order_model.dart';
import 'package:food_app/feature/auth/providers/core_provider.dart';

class OrderListScreen extends ConsumerWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseService = ref.watch(firebaseServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: FutureBuilder<List<Order_model>>(
        future: firebaseService.fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text('Order #\${order.id}'),
                  subtitle: Text(
                    'User: \${order.userId}\nTotal: ₹\${order.total.toStringAsFixed(2)}\nStatus: \${order.status}',
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'Delete') {
                        await firebaseService.deleteOrder(order.id);
                      } else {
                        await firebaseService.updateOrderStatus(
                          order.id,
                          value,
                        );
                      }
                      ref.invalidate(firebaseServiceProvider);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Pending',
                        child: Text('Mark Pending'),
                      ),
                      const PopupMenuItem(
                        value: 'Preparing',
                        child: Text('Mark Preparing'),
                      ),
                      const PopupMenuItem(
                        value: 'Delivered',
                        child: Text('Mark Delivered'),
                      ),
                      const PopupMenuItem(
                        value: 'Delete',
                        child: Text('Delete Order'),
                      ),
                    ],
                    child: const Icon(Icons.more_vert),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
