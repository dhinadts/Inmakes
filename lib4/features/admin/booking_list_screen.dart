import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/firebase_service.dart';
import '../../models/booking.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) => FirebaseService());

class BookingListScreen extends ConsumerWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(firebaseServiceProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Bookings')),
      body: FutureBuilder<List<Booking>>(
        future: service.fetchBookings(),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final bookings = snap.data ?? [];
          if (bookings.isEmpty) return const Center(child: Text('No bookings'));
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (_, i) {
              final b = bookings[i];
              return Card(
                child: ListTile(
                  title: Text('Table ${b.tableNo} • ${b.status}'),
                  subtitle: Text('Guests: ${b.guests} • ${b.dateTime}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (val) {
                      if (val == 'Delete') {
                        service.deleteBooking(b.id);
                      } else {
                        service.updateBookingStatus(b.id, {'status': val});
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'pending', child: Text('Pending')),
                      PopupMenuItem(value: 'confirmed', child: Text('Confirmed')),
                      PopupMenuItem(value: 'completed', child: Text('Completed')),
                      PopupMenuItem(value: 'cancelled', child: Text('Cancelled')),
                      PopupMenuItem(value: 'Delete', child: Text('Delete')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
