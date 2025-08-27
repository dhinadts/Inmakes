import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'food_menu_screen.dart';
import 'checkout_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final total = cart.fold<double>(0, (sum, it) => sum + it.price);
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cart.isEmpty ? const Center(child: Text('Cart is empty')) : ListView(
        children: [
          ...cart.map((e) => ListTile(
            leading: e.imageUrl.isEmpty ? const Icon(Icons.image) : Image.network(e.imageUrl, width: 56, height: 56, fit: BoxFit.cover),
            title: Text(e.title),
            subtitle: Text('₹${e.price.toStringAsFixed(2)}'),
          )),
          const Divider(),
          ListTile(
            title: const Text('Total'),
            trailing: Text('₹${total.toStringAsFixed(2)}'),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FilledButton(
          onPressed: cart.isEmpty ? null : () {
            Navigator.push(context, MaterialPageRoute(builder: (_)=> CheckoutScreen(total: total, items: cart)));
          },
          child: const Text('Proceed to Checkout'),
        ),
      ),
    );
  }
}
