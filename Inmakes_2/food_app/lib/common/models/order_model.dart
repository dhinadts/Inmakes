import 'package:cloud_firestore/cloud_firestore.dart';

class Order_model {
  final String id;
  final String userId;
  final List<String> foodItemIds;
  final double totalAmount;
  final String status;
  final DateTime timestamp;

  Order_model({
    required this.id,
    required this.userId,
    required this.foodItemIds,
    required this.totalAmount,
    required this.status,
    required this.timestamp,
  });

  factory Order_model.fromMap(Map<String, dynamic> map, String docId) {
    return Order_model(
      id: docId,
      userId: map['userId'],
      foodItemIds: List<String>.from(map['foodItemIds'] ?? []),
      totalAmount: map['totalAmount'].toDouble(),
      status: map['status'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'foodItemIds': foodItemIds,
      'totalAmount': totalAmount,
      'status': status,
      'timestamp': timestamp,
    };
  }
}
