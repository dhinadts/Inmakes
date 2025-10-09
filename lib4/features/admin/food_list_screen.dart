import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/firebase_service.dart';
import '../../models/food_item.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) => FirebaseService());

class FoodListScreen extends ConsumerWidget {
  const FoodListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(firebaseServiceProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Food Items')),
      body: FutureBuilder<List<FoodItem>>(
        future: service.fetchFoodItems(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snap.data ?? [];
          if (items.isEmpty) return const Center(child: Text('No food items'));
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final it = items[i];
              return ListTile(
                leading: it.imageUrl.isEmpty ? const Icon(Icons.image) : Image.network(it.imageUrl, width: 56, height: 56, fit: BoxFit.cover),
                title: Text(it.title),
                subtitle: Text('₹${it.price.toStringAsFixed(2)} • ${it.category}/${it.subCategory}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAdd(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openAdd(BuildContext context, WidgetRef ref) {
    final title = TextEditingController();
    final desc = TextEditingController();
    final price = TextEditingController();
    final category = TextEditingController();
    final subCategory = TextEditingController();
    final imageUrl = TextEditingController();
    final rating = TextEditingController(text: '4.5');
    final discount = TextEditingController(text: '0%');
    final formKey = GlobalKey<FormState>();

    showDialog(context: context, builder: (_) {
      return AlertDialog(
        title: const Text('Add Food Item'),
        content: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _tf('Title', title),
                  _tf('Description', desc, maxLines: 3),
                  _tf('Price', price, keyboard: TextInputType.number),
                  _tf('Category', category),
                  _tf('Sub Category', subCategory),
                  _tf('Image URL', imageUrl),
                  _tf('Rating', rating),
                  _tf('Discount', discount),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final item = FoodItem(
                id: '',
                title: title.text.trim(),
                description: desc.text.trim(),
                price: double.tryParse(price.text.trim()) ?? 0,
                category: category.text.trim(),
                subCategory: subCategory.text.trim(),
                imageUrl: imageUrl.text.trim(),
                rating: rating.text.trim(),
                discount: discount.text.trim(),
                isAvailable: true,
              );
              await ref.read(firebaseServiceProvider).addOrUpdateFood(item);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          )
        ],
      );
    });
  }

  Widget _tf(String label, TextEditingController c, {int maxLines = 1, TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        keyboardType: keyboard,
        validator: (v)=> (v==null||v.isEmpty) ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
