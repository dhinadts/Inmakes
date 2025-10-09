import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/common/models/booking_model.dart';
import 'package:food_app/feature/auth/providers/core_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingListScreen extends ConsumerWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseService = ref.watch(firebaseServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Table Bookings')),
      body: FutureBuilder<List<Booking>>(
        future: firebaseService.fetchBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookings found'));
          }

          final bookings = snapshot.data!;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text('Booking #${booking.id}'),
                  subtitle: Text(
                    'User: ${booking.userId}\nTable: ${booking.tableNumber}\nGuests: ${booking.guestCount}',
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'Delete') {
                        await firebaseService.deleteBooking(booking.id);
                      } else {
                        await firebaseService.updateBookingStatus(booking.id, {
                          'status': value,
                        });
                      }
                      ref.invalidate(firebaseServiceProvider);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Confirmed',
                        child: Text('Mark Confirmed'),
                      ),
                      const PopupMenuItem(
                        value: 'Completed',
                        child: Text('Mark Completed'),
                      ),
                      const PopupMenuItem(
                        value: 'Cancelled',
                        child: Text('Mark Cancelled'),
                      ),
                      const PopupMenuItem(
                        value: 'Delete',
                        child: Text('Delete Booking'),
                      ),
                    ],
                    child: const Icon(Icons.more_vert),
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
