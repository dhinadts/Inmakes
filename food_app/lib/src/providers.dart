import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/food.dart';
import 'models/order.dart';
import 'models/table_info.dart';
import 'services/firebase_service.dart';

final themeProvider = StateProvider((ref) => ThemeMode.system);
final firebaseServiceProvider = Provider((ref) => FirebaseService());

final foodsStreamProvider = StreamProvider.autoDispose<List<Food>>((ref) {
  final svc = ref.watch(firebaseServiceProvider);
  return svc.streamFoodItems();
});

final ordersStreamProvider = StreamProvider.autoDispose<List<OrderModel>>((ref) {
  final svc = ref.watch(firebaseServiceProvider);
  return svc.streamOrders();
});

final tablesStreamProvider = StreamProvider.autoDispose<List<TableInfo>>((ref) {
  final svc = ref.watch(firebaseServiceProvider);
  return svc.streamTables();
});
