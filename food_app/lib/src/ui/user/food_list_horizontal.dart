import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodListHorizontal extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodsAsync = ref.watch(foodsStreamProvider);
    return foodsAsync.when(
      data: (foods) {
        // Group by category
        final byCategory = <String, List<dynamic>>{};
        for (var f in foods) {
          byCategory.putIfAbsent(f.category, () => []).add(f);
        }
        return ListView(
          children: byCategory.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    entry.key,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: entry.value.length,
                    itemBuilder: (context, idx) {
                      final item = entry.value[idx];
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: Container(
                          width: 220,
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: item.imageUrl != ''
                                    ? Image.network(
                                        item.imageUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      )
                                    : Placeholder(),
                              ),
                              SizedBox(height: 6),
                              Text(
                                item.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('₹${item.price.toStringAsFixed(2)}'),
                              ElevatedButton(
                                onPressed: () {
                                  // add order flow (simplified)
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text('Order ${item.name}?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            // create order document with this single item (demo)
                                            final svc = ref.read(
                                              firebaseServiceProvider,
                                            );
                                            final db =
                                                FirebaseFirestore.instance;

                                            await db.collection('orders').add({
                                              'userId': 'demoUser',
                                              'items': [
                                                {
                                                  'foodId': item.id,
                                                  'qty': 1,
                                                  'price': item.price,
                                                },
                                              ],
                                              'tableId': '',
                                              'status': 'Pending',
                                              'createdAt':
                                                  FieldValue.serverTimestamp(),
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text('Confirm'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Text('Order'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}
