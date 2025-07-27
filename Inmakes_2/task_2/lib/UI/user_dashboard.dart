import 'package:flutter/material.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Dashboard")),
      body: Container(
        color: Color.fromRGBO(0, 255, 0, 1),
        child: const Center(child: Text("Welcome User")),
      ),
    );
  }
}

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: Container(
        color: Color.fromRGBO(255, 0, 0, 1),
        child: const Center(child: Text("Welcome Admin")),
      ),
    );
  }
}
