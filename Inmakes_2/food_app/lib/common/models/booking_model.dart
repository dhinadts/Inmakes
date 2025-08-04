import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String userId;
  final String tableNumber;
  final DateTime bookingTime;
  final String status;
  final int guestCount;
  final DateTime timestamp;
  Booking({
    required this.id,
    required this.userId,
    required this.tableNumber,
    required this.bookingTime,
    required this.status,
    required this.guestCount,
    required this.timestamp,
  });

  factory Booking.fromMap(Map<String, dynamic> map, String docId) {
    return Booking(
      id: docId,
      userId: map['userId'],
      tableNumber: map['tableNumber'],
      bookingTime: (map['bookingTime'] as Timestamp).toDate(),
      status: map['status'],
      guestCount: map['guestCount'] ?? 0,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'tableNumber': tableNumber,
      'bookingTime': bookingTime,
      'status': status,
      'guestCount': guestCount,
      'timestamp': timestamp,
    };
  }
}
