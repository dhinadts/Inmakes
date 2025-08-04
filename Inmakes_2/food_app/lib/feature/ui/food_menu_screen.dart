import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/common/models/food_item_model.dart';
import 'package:food_app/feature/auth/providers/core_provider.dart';

class FoodMenuScreen extends ConsumerWidget {
  const FoodMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseService = ref.watch(firebaseServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Food Menu')),
      body: FutureBuilder<List<FoodItem>>(
        future: firebaseService.fetchFoodItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No food items found'));
          }

          final foodItems = snapshot.data!;
          return ListView.builder(
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final item = foodItems[index];
              return ListTile(
                leading: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                title: Text(item.name),
                subtitle: Text('${item.description}\n₹${item.price.toStringAsFixed(2)}'),
                isThreeLine: true,
                trailing: Icon(
                  item.isAvailable ? Icons.check_circle : Icons.cancel,
                  color: item.isAvailable ? Colors.green : Colors.red,
                ),
                onTap: () {
                  // Navigate to edit screen (to be implemented)
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add food item screen (to be implemented)
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
