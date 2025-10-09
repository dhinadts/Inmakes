import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<Map<String, dynamic>> items; // {foodId, qty, price}
  final String tableId;
  final String status; // Pending, Preparing, Ready, Completed
  final DateTime createdAt;

  OrderModel({required this.id, required this.userId, required this.items, required this.tableId, required this.status, required this.createdAt});

  factory OrderModel.fromMap(String id, Map<String, dynamic> m) {
    return OrderModel(
      id: id,
      userId: m['userId'] ?? '',
      items: List<Map<String, dynamic>>.from(m['items'] ?? []),
      tableId: m['tableId'] ?? '',
      status: m['status'] ?? 'Pending',
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'items': items,
    'tableId': tableId,
    'status': status,
    'createdAt': createdAt,
  };
}
