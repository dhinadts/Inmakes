import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/food_item.dart';
import '../../models/order.dart' as my_order;
import '../../services/firebase_service.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final double total;
  final List<FoodItem> items;
  const PaymentScreen({super.key, required this.total, required this.items});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _processing = false;
  String _method = 'Card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Payment Method'),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _method,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'Card', child: Text('Card')),
                DropdownMenuItem(value: 'UPI', child: Text('UPI')),
                DropdownMenuItem(value: 'Wallet', child: Text('Wallet')),
              ],
              onChanged: (v)=> setState(()=> _method = v ?? 'Card'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _processing ? null : _pay,
                child: _processing ? const SizedBox(height:18,width:18,child: CircularProgressIndicator(strokeWidth:2)) : Text('Pay ₹${widget.total.toStringAsFixed(2)}'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _pay() async {
    setState(()=> _processing = true);
    await Future.delayed(const Duration(seconds: 2)); // simulate payment
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not logged in')));
      setState(()=> _processing = false);
      return;
    }
    final items = widget.items.map((f) => my_order.OrderItem(foodId: f.id, title: f.title, imageUrl: f.imageUrl, price: f.price, qty: 1)).toList();
    final order = my_order.Order(id: '', userId: user.uid, items: items, total: widget.total, status: 'pending', createdAt: DateTime.now());
    final service = FirebaseService();
    await service.createOrder(order);
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> const PaymentSuccessScreen()), (route)=> route.isFirst);
  }
}
