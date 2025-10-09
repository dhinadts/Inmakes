import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';

class ManageOrdersScreen extends ConsumerWidget {
  final statuses = ['Pending','Preparing','Ready','Completed'];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersStreamProvider);
    final svc = ref.read(firebaseServiceProvider);
    return ordersAsync.when(
      data: (orders) {
        return ListView.builder(itemCount: orders.length, itemBuilder: (c, i) {
          final o = orders[i];
          return Card(
            child: ListTile(
              title: Text('Order ${o.id}'),
              subtitle: Text('Status: ${o.status}\nTable: ${o.tableId}'),
              isThreeLine: true,
              trailing: DropdownButton<String>(value: o.status, items: statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (v) async {
                if (v == null) return;
                await svc.updateOrderStatus(o.id, v);
              }),
            ),
          );
        });
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}
