import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Read profile properties from FirebaseAuth & Firestore in your app
    return Center(child: Text('Profile (reads registered properties from Firebase)'));
  }
}
