import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/firebase_service.dart';
import '../../models/order.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) => FirebaseService());

class OrderListScreen extends ConsumerWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(firebaseServiceProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: FutureBuilder<List<Order>>(
        future: service.fetchOrders(),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final orders = snap.data ?? [];
          if (orders.isEmpty) return const Center(child: Text('No orders'));
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (_, i) {
              final o = orders[i];
              return Card(
                child: ListTile(
                  title: Text('Order ${o.id} • ₹${o.total.toStringAsFixed(2)}'),
                  subtitle: Text('${o.items.length} items • ${o.status}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (val) {
                      if (val == 'Delete') {
                        service.deleteOrder(o.id);
                      } else {
                        service.updateOrderStatus(o.id, val);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'pending', child: Text('Pending')),
                      PopupMenuItem(value: 'confirmed', child: Text('Confirmed')),
                      PopupMenuItem(value: 'delivered', child: Text('Delivered')),
                      PopupMenuItem(value: 'cancelled', child: Text('Cancelled')),
                      PopupMenuItem(value: 'Delete', child: Text('Delete')),
                    ],
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
