import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app/common/models/booking_model.dart';
import 'package:food_app/common/models/food_item_model.dart';
import 'package:food_app/common/models/order_model.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign up with email and password
  Future<UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sign in with email and password
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Listen to auth state changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  /// Check if email is verified
  bool isEmailVerified() {
    final user = _auth.currentUser;
    return user?.emailVerified ?? false;
  }

  // Add this inside your FirebaseService class
  Future<List<FoodItem>> fetchFoodItems() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('food_items')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return FoodItem(
        id: doc.id,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        price: (data['price'] ?? 0).toDouble(),
        isAvailable: data['isAvailable'] ?? true,
      );
    }).toList();
  }

  Future<List<Order_model>> fetchOrders() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Order_model(
        id: doc.id,
        userId: data['userId'] ?? '',
        foodItemIds: List<String>.from(
          data['items'] ?? [],
        ), // ids of food items
        totalAmount: (data['total'] ?? 0).toDouble(),
        status: data['status'] ?? 'pending',
        timestamp: (data['timestamp'] as Timestamp).toDate(),
      );
    }).toList();
  }

  Future<List<Booking>> fetchBookings() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Booking(
        id: doc.id,
        userId: data['userId'] ?? '',
        tableNumber: data['tableNumber'] ?? '',
        guestCount: data['guestCount'] ?? 0,
        bookingTime: (data['bookingTime'] as Timestamp).toDate(),
        timestamp: (data['timestamp'] as Timestamp).toDate(),
        status: data['status'] ?? 'pending', // default status
      );
    }).toList();
  }

  // Update booking (e.g., assign table, mark completed, etc.)
  Future<void> updateBookingStatus(
    String bookingId,
    Map<String, dynamic> updates,
  ) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .update(updates);
  }

  // Delete a booking
  Future<void> deleteBooking(String bookingId) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .delete();
  }

  // Add a new booking
  Future<void> addBooking(Booking booking) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .add(booking.toMap());
  }

  // Update an order
  Future<void> updateOrder(String orderId, Map<String, dynamic> updates) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .update(updates);
  }

  // Delete an order
  Future<void> deleteOrder(String orderId) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
  }

  // Add a new order
  Future<void> addOrder(Order_model order) async {
    await FirebaseFirestore.instance.collection('orders').add(order.toMap());
  }

  Future<void> addFoodItem(FoodItem foodItem) async {
    await FirebaseFirestore.instance
        .collection('food_items')
        .add(foodItem.toMap());
  }

  Future<void> updateFoodItem(String id, FoodItem foodItem) async {
    await FirebaseFirestore.instance
        .collection('food_items')
        .doc(id)
        .update(foodItem.toMap());
  }

  Future<void> deleteFoodItem(String id) async {
    await FirebaseFirestore.instance.collection('food_items').doc(id).delete();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {'status': status, 'updatedAt': FieldValue.serverTimestamp()},
      );
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }
}
