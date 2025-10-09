import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TableSelection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tablesAsync = ref.watch(tablesStreamProvider);
    return tablesAsync.when(
      data: (tables) {
        return GridView.builder(
          padding: EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            childAspectRatio: 1.4,
          ),
          itemCount: tables.length,
          itemBuilder: (context, idx) {
            final t = tables[idx];
            return Card(
              child: InkWell(
                onTap: t.available
                    ? () async {
                        // Simple allocation flow: create a pending order with tableId assigned
                        final svc = ref.read(firebaseServiceProvider);
                        final db = FirebaseFirestore.instance;

                        final orderRef = await db.collection('orders').add({
                          'userId': 'demoUser',
                          'items': [],
                          'tableId': t.id,
                          'status': 'Pending',
                          'createdAt': FieldValue.serverTimestamp(),
                        });
                        await svc.allocateTable(t.id, orderRef.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Table ${t.name} booked')),
                        );
                      }
                    : null,
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        t.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('${t.seats} seats'),
                      SizedBox(height: 8),
                      Chip(label: Text(t.available ? 'Available' : 'Occupied')),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}
