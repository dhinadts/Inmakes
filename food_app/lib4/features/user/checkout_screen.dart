import 'package:flutter/material.dart';
import '../../models/food_item.dart';
import 'payment_screen.dart';

class CheckoutScreen extends StatelessWidget {
  final double total;
  final List<FoodItem> items;

  const CheckoutScreen({super.key, required this.total, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Review Items', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...items.map((e)=> ListTile(
            title: Text(e.title),
            subtitle: Text('₹${e.price.toStringAsFixed(2)}'),
          )),
          const Divider(),
          ListTile(
            title: const Text('Total'),
            trailing: Text('₹${total.toStringAsFixed(2)}'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=> PaymentScreen(total: total, items: items)));
            },
            child: const Text('Pay Now'),
          )
        ],
      ),
    );
  }
}
