import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final userRoleProvider = FutureProvider<String>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return 'User';
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();
  return (doc.data()?['role'] as String?) ?? 'User';
});
