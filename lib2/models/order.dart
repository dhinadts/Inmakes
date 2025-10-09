import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String foodId;
  final String title;
  final String imageUrl;
  final double price;
  final int qty;

  OrderItem({required this.foodId, required this.title, required this.imageUrl, required this.price, required this.qty});

  factory OrderItem.fromMap(Map<String, dynamic> m) => OrderItem(
    foodId: m['foodId'] ?? '',
    title: m['title'] ?? '',
    imageUrl: m['imageUrl'] ?? '',
    price: (m['price'] ?? 0).toDouble(),
    qty: m['qty'] ?? 1,
  );

  Map<String, dynamic> toMap() => {
    'foodId': foodId,
    'title': title,
    'imageUrl': imageUrl,
    'price': price,
    'qty': qty,
  };
}

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double total;
  final String status;
  final DateTime createdAt;

  Order({required this.id, required this.userId, required this.items, required this.total, required this.status, required this.createdAt});

  factory Order.fromDoc(String id, Map<String, dynamic> map) => Order(
    id: id,
    userId: map['userId'] ?? '',
    items: (map['items'] as List? ?? []).map((e) => OrderItem.fromMap(e)).toList(),
    total: (map['total'] ?? 0).toDouble(),
    status: map['status'] ?? 'pending',
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'items': items.map((e) => e.toMap()).toList(),
    'total': total,
    'status': status,
    'createdAt': createdAt,
  };
}
