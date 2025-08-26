import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String userId;
  final int tableNo;
  final int guests;
  final String status;
  final DateTime dateTime;

  Booking({required this.id, required this.userId, required this.tableNo, required this.guests, required this.status, required this.dateTime});

  factory Booking.fromDoc(String id, Map<String, dynamic> map) => Booking(
    id: id,
    userId: map['userId'] ?? '',
    tableNo: (map['tableNo'] ?? 0),
    guests: (map['guests'] ?? 1),
    status: map['status'] ?? 'pending',
    dateTime: (map['dateTime'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'tableNo': tableNo,
    'guests': guests,
    'status': status,
    'dateTime': dateTime,
  };
}
