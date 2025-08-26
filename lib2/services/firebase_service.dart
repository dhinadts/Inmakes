import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/food_item.dart';
import '../models/order.dart' as my_order;
import '../models/booking.dart';

class FirebaseService {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  // ----- Food Items -----
  Future<List<FoodItem>> fetchFoodItems() async {
    final q = await _db.collection('food_items').orderBy('title').get();
    return q.docs.map((d) => FoodItem.fromMap(d.id, d.data())).toList();
    }

  Future<void> addOrUpdateFood(FoodItem item, {String? id}) async {
    final data = item.toMap();
    if (id == null) {
      await _db.collection('food_items').add(data);
    } else {
      await _db.collection('food_items').doc(id).set(data, SetOptions(merge: true));
    }
  }

  Future<String> uploadImage(File file, {String path = 'uploads'}) async {
    final name = '${path}/${_uuid.v4()}.jpg';
    final ref = _storage.ref().child(name);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  // ----- Orders -----
  Future<List<my_order.Order>> fetchOrders() async {
    final q = await _db.collection('orders').orderBy('createdAt', descending: true).get();
    return q.docs.map((d) => my_order.Order.fromDoc(d.id, d.data())).toList();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _db.collection('orders').doc(orderId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteOrder(String id) async {
    await _db.collection('orders').doc(id).delete();
  }

  Future<String> createOrder(my_order.Order order) async {
    final doc = await _db.collection('orders').add(order.toMap());
    return doc.id;
  }

  // ----- Bookings -----
  Future<List<Booking>> fetchBookings() async {
    final q = await _db.collection('bookings').orderBy('dateTime', descending: true).get();
    return q.docs.map((d) => Booking.fromDoc(d.id, d.data())).toList();
  }

  Future<void> updateBookingStatus(String id, Map<String, dynamic> updates) async {
    await _db.collection('bookings').doc(id).update(updates);
  }

  Future<void> deleteBooking(String id) async {
    await _db.collection('bookings').doc(id).delete();
  }
}
