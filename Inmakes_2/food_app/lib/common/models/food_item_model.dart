// lib/models/food_item.dart
class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool isAvailable;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
  });

  factory FoodItem.fromMap(Map<String, dynamic> map, String docId) {
    return FoodItem(
      id: docId,
      name: map['name'],
      description: map['description'],
      price: map['price'].toDouble(),
      imageUrl: map['imageUrl'],
      isAvailable: map['isAvailable'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
    };
  }
}

// import 'package:flutter/material.dart';