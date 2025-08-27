import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/firebase_service.dart';
import '../../models/food_item.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) => FirebaseService());
final cartProvider = StateProvider<List<FoodItem>>((ref) => []);

class FoodMenuScreen extends ConsumerWidget {
  const FoodMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(firebaseServiceProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: FutureBuilder<List<FoodItem>>(
        future: service.fetchFoodItems(),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final items = snap.data ?? [];
          if (items.isEmpty) return const Center(child: Text('No food items'));
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final it = items[i];
              return ListTile(
                leading: it.imageUrl.isEmpty ? const Icon(Icons.image) : Image.network(it.imageUrl, width: 56, height: 56, fit: BoxFit.cover),
                title: Text(it.title),
                subtitle: Text('₹${it.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    final cart = [...ref.read(cartProvider)];
                    cart.add(it);
                    ref.read(cartProvider.notifier).state = cart;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
