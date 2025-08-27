import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/firebase_service.dart';
import '../../models/booking.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) => FirebaseService());

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(firebaseServiceProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Table Bookings')),
      body: FutureBuilder<List<Booking>>(
        future: service.fetchBookings(),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final list = snap.data ?? [];
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final b = list[i];
              return ListTile(
                title: Text('Table ${b.tableNo} • ${b.status}'),
                subtitle: Text('Guests: ${b.guests} • ${b.dateTime}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _newBooking(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _newBooking(BuildContext context, WidgetRef ref) {
    final table = TextEditingController();
    final guests = TextEditingController(text: '2');
    DateTime date = DateTime.now().add(const Duration(hours: 2));
    final key = GlobalKey<FormState>();
    showDialog(context: context, builder: (_) {
      return AlertDialog(
        title: const Text('New Booking'),
        content: SizedBox(
          width: 420,
          child: Form(
            key: key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(controller: table, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Table No', border: OutlineInputBorder()), validator: (v)=> (v==null||v.isEmpty)?'Required':null),
                const SizedBox(height: 8),
                TextFormField(controller: guests, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Guests', border: OutlineInputBorder()), validator: (v)=> (v==null||v.isEmpty)?'Required':null),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: Text('Time: $date')),
                  TextButton(onPressed: () async {
                    final picked = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 30)), initialDate: DateTime.now());
                    if (picked != null) {
                      final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                      if (t != null) {
                        date = DateTime(picked.year, picked.month, picked.day, t.hour, t.minute);
                      }
                    }
                  }, child: const Text('Pick')),
                ]),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () async {
            if (!key.currentState!.validate()) return;
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) return;
            await FirebaseFirestore.instance.collection('bookings').add({
              'userId': user.uid,
              'tableNo': int.tryParse(table.text) ?? 0,
              'guests': int.tryParse(guests.text) ?? 1,
              'status': 'pending',
              'dateTime': Timestamp.fromDate(date),
            });
            if (context.mounted) Navigator.pop(context);
          }, child: const Text('Save')),
        ],
      );
    });
  }
}
