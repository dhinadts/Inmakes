import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food.dart';
import '../models/order.dart';
import '../models/table_info.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseService {
  final db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Stream<List<Food>> streamFoodItems() {
    return db.collection('foods').snapshots().map((snap) =>
      snap.docs.map((d) => Food.fromMap(d.id, d.data() as Map<String, dynamic>)).toList());
  }

  Future<String> uploadImage(File file, String path) async {
    final ref = _storage.ref().child(path);
    final task = await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> addFood(Food f) async {
    await db.collection('foods').add(f.toMap());
  }

  Stream<List<OrderModel>> streamOrders() {
    return db.collection('orders').orderBy('createdAt', descending: true).snapshots().map((s) => s.docs.map((d) => OrderModel.fromMap(d.id, d.data() as Map<String, dynamic>)).toList());
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await db.collection('orders').doc(orderId).update({'status': status});
  }

  Stream<List<TableInfo>> streamTables() {
    return db.collection('tables').snapshots().map((s) => s.docs.map((d) => TableInfo.fromMap(d.id, d.data() as Map<String, dynamic>)).toList());
  }

  Future<void> allocateTable(String tableId, String orderId) async {
    await db.collection('tables').doc(tableId).update({'available': false, 'allocatedToOrderId': orderId});
  }

  Future<void> releaseTable(String tableId) async {
    await db.collection('tables').doc(tableId).update({'available': true, 'allocatedToOrderId': null});
  }
}
