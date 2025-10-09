import 'package:cloud_firestore/cloud_firestore.dart';

class TableModel {
  final String id;
  final int capacity;
  String? status; // "available" | "booked"
  String? bookedBy;
  final Timestamp? bookedAt;

  TableModel({
    required this.id,
    required this.capacity,
    this.status = "available",
    this.bookedBy,
    this.bookedAt,
  });

  factory TableModel.fromMap(Map<String, dynamic> data, String docId) {
    return TableModel(
      id: docId,
      capacity: data['capacity'] ?? 2,
      status: data['status'] ?? "available",
      bookedBy: data['bookedBy'],
      bookedAt: data['bookedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "capacity": capacity,
      "status": status,
      "bookedBy": bookedBy,
      "bookedAt": bookedAt,
    };
  }
}

class TableInfo {
  final int number;
  final int capacity;
  bool isOccupied;
  bool isReserved;

  TableInfo({
    required this.number,
    required this.capacity,
    this.isOccupied = false,
    this.isReserved = false,
  });
}
