import 'package:flutter/material.dart';
import 'package:food_app/app/modules/admin_dashboard/views/admin_dashboard_view.dart';
import 'package:food_app/app/modules/user_dashboard/views/user_dashboard_view.dart';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DashboardController());
    // final role = Get.arguments![0]['role'] ?? '';

    return controller.role.value == ""
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Obx(
                () => Text(
                  controller.userName.value.isNotEmpty
                      ? controller.userName.value
                      : 'Dashboard',
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    // Handle shopping cart
                  },
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.deepOrangeAccent),
                    child: Obx(
                      () => Text(
                        controller.userName.value.isNotEmpty
                            ? controller.userName.value
                            : 'Welcome User',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Profile'),
                    onTap: () {
                      // Handle profile navigation
                      Get.toNamed('/profile');
                    },
                  ),
                  ListTile(
                    title: Text('Settings'),
                    onTap: () {
                      // Handle settings navigation
                      Get.toNamed('/settings');
                    },
                  ),
                ],
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /* Center(
            child: Text(
              role == 'Admin' ?   '👑 Admin Dashboard' : '🙋 User Dashboard',
              style: const TextStyle(fontSize: 24),
            ),
          ), */
                Expanded(
                  child: controller.role.value == 'Admin'
                      ? UserDashboardView() // Admin View
                      : AdminDashboardView(), // user View
                ),
              ],
            ),
            bottomNavigationBar: Obx(
              () => controller.isAdLoaded.value
                  ? SizedBox(
                      height: controller.bannerAd.size.height.toDouble(),
                      width: controller.bannerAd.size.width.toDouble(),
                      child: AdWidget(ad: controller.bannerAd),
                    )
                  : const SizedBox.shrink(),
            ),
          );
  }
}
