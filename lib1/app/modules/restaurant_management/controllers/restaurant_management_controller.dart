import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantManagementController extends GetxController {
  RxList<Map<String, dynamic>> restaurants = <Map<String, dynamic>>[].obs;
  final restaurantNameController = TextEditingController();
  final restaurantLocationController = TextEditingController();
  final restaurantImageController = TextEditingController();
  final isLoading = false.obs;
  final selectedRestaurant = ''.obs;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Stream<List<Map<String, dynamic>>> get restaurantStream {
    return _db
        .collection('restaurantDetails')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            data['restaurantId'] = doc.id;
            return data;
          }).toList(),
        );
  }

  Future<List<Map<String, dynamic>>> fetchRestaurants() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('restaurantDetails')
          .orderBy('createdAt', descending: true)
          .get();

      restaurants.value = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['restaurantId'] = doc.id;
        return data;
      }).toList();
      return restaurants;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch restaurants: $e');
      return [];
    }
  }

  Future<void> addRestaurant() async {
    final name = restaurantNameController.text.trim();
    final location = restaurantLocationController.text.trim();
    final imageUrl = restaurantImageController.text.trim();

    if (name.isEmpty || location.isEmpty || imageUrl.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    try {
      DocumentReference docRef = await _db.collection('restaurantDetails').add({
        'name': name,
        'location': location,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
      // Get the auto-generated restaurantId
      String restaurantId = docRef.id;

      // Optional: Update the document to include its own ID
      await docRef.update({'restaurantId': restaurantId});

      Get.snackbar('Success', 'Restaurant added successfully');
      restaurantNameController.clear();
      restaurantLocationController.clear();
      restaurantImageController.clear();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add restaurant: $e');
    }
  }

  void updateRestaurant(String? restaurantId) {
    if (restaurantId == null || restaurantId.isEmpty) {
      Get.snackbar('Error', 'No restaurant selected for update');
      return;
    }

    final name = restaurantNameController.text.trim();
    final location = restaurantLocationController.text.trim();
    final imageUrl = restaurantImageController.text.trim();

    if (name.isEmpty || location.isEmpty || imageUrl.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    _db
        .collection('restaurantDetails')
        .doc(restaurantId)
        .update({
          'name': name,
          'location': location,
          'imageUrl': imageUrl,
          'updatedAt': FieldValue.serverTimestamp(),
        })
        .then((_) {
          Get.snackbar('Success', 'Restaurant updated successfully');
          restaurantNameController.clear();
          restaurantLocationController.clear();
          restaurantImageController.clear();
        })
        .catchError((e) {
          Get.snackbar('Error', 'Failed to update restaurant: $e');
        });
  }

  @override
  void onClose() {
    restaurantNameController.dispose();
    restaurantLocationController.dispose();
    restaurantImageController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    // Fetch initial restaurant data
    fetchRestaurants()
        .then((data) {
          restaurants.value = data.toList();
        })
        .catchError((e) {
          Get.snackbar('Error', 'Failed to fetch restaurants: $e');
        });
  }
}
