import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';

class TableAllocationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tablesAsync = ref.watch(tablesStreamProvider);
    final ordersAsync = ref.watch(ordersStreamProvider);
    final svc = ref.read(firebaseServiceProvider);

    return Row(
      children: [
        Expanded(child: tablesAsync.when(data: (tables) => ListView.builder(itemCount: tables.length, itemBuilder: (c, i) {
          final t = tables[i];
          return Card(child: ListTile(title: Text(t.name), subtitle: Text(t.available ? 'Available' : 'Occupied'), trailing: t.available ? null : Text('Order ${t.allocatedToOrderId}')));
        }), loading: () => Center(child: CircularProgressIndicator()), error: (e, s) => Text('Error'))),
        VerticalDivider(width: 1),
        Expanded(child: ordersAsync.when(data: (orders) => ListView.builder(itemCount: orders.length, itemBuilder: (c, i) {
          final o = orders[i];
          return Card(child: ListTile(title: Text('Order ${o.id}'), subtitle: Text('Status: ${o.status}'), trailing: ElevatedButton(onPressed: () async {
            // simple allocation: find first available table
            final tablesSnapshot = await svc.db.collection('tables').where('available', isEqualTo: true).limit(1).get();
            if (tablesSnapshot.docs.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No tables available'))); return; }
            final tableDoc = tablesSnapshot.docs.first;
            await svc.allocateTable(tableDoc.id, o.id);
            await svc.db.collection('orders').doc(o.id).update({'tableId': tableDoc.id});
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Allocated ${tableDoc.data()['name']} to Order ${o.id}')));
          }, child: Text('Allocate'))));
        }), loading: () => Center(child: CircularProgressIndicator()), error: (e, s) => Text('Error'))),
      ],
    );
  }
}
