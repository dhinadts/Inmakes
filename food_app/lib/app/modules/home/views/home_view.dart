import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:food_app/app/modules/dashboard/views/dashboard_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Obx(() {
        if (controller.role.value == '') {
          return const Center(child: CircularProgressIndicator());
        }

        // Navigate to DashboardView with role argument
        Future.microtask(() {
          Get.off(() => const DashboardView(), arguments: {
            'role': controller.role.value,
          });
        });

        return const SizedBox(); // Empty widget while redirecting
      }),
    );
  }
}
