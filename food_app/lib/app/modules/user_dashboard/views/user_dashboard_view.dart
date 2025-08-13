import 'package:flutter/material.dart';
import 'package:food_app/app/routes/app_pages.dart';

import 'package:get/get.dart';

import '../controllers/user_dashboard_controller.dart';

class UserDashboardView extends GetView<UserDashboardController> {
  const UserDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'Welcome to Admin Dashboard',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            backgroundColor: Colors.white,
            isScrollControlled: true,
            builder: (context) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Wrap(
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(
                          Icons.restaurant_menu,
                          color: Colors.teal,
                        ),
                        title: const Text(
                          'Restaurant Management',
                          style: TextStyle(color: Colors.teal),
                        ),
                        onTap: () {
                          Get.toNamed(Routes.RESTAURANT_MANAGEMENT);
                        },
                      ),
                      // const Divider(),
                      ListTile(
                        leading: const Icon(
                          Icons.food_bank,
                          color: Colors.deepOrange,
                        ),
                        title: const Text(
                          'Food Order Management',
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                        onTap: () {
                          Get.toNamed('/food-order-management');
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
