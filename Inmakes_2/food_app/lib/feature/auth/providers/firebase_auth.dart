// features/auth/providers.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final currentUserProvider =
    FutureProvider<DocumentSnapshot<Map<String, dynamic>>>((ref) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw FirebaseAuthException(code: 'not-logged-in');
      return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    });
