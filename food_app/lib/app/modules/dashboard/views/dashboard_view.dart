import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final role = Get.arguments['role'] ?? 'User';

    return Scaffold(
      appBar: AppBar(title: Text("Dashboard - $role")),
      body: Center(
        child: Text(
          role == 'Admin' ? '👑 Admin Dashboard' : '🙋 User Dashboard',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
