// lib/app/modules/splash/views/splash_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../home/views/home_view.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashScreenController());

    return Scaffold(
      body: FutureBuilder(
        future: controller.goToLogin(), // Simulate loading
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                children: [Text("Loading..."), CircularProgressIndicator()],
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.data == false || snapshot.data == null) {
            return HomeView();
          }
          // Removed check for snapshot.data since goToLogin() returns void
          else {
            return Stack(
              children: [
                PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.images.length,
                  onPageChanged: (index) =>
                      controller.currentPage.value = index,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.white,
                      child: Center(
                        child: SvgPicture.asset(
                          controller.images[index],
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    backgroundColor: Colors.teal,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "...Loading image failed",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),

                // Navigation Buttons
                Positioned(
                  bottom: 100,
                  left: 20,
                  right: 20,
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: controller.prevPage,
                          child: const Text("Previous"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final action =
                                controller.currentPage.value ==
                                    controller.images.length - 1
                                ? 'done'
                                : 'next';
                            controller.nextPage(action);
                          },
                          child: Text(
                            controller.currentPage.value ==
                                    controller.images.length - 1
                                ? "Done"
                                : "Next",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Skip Button
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: TextButton(
                      onPressed: controller.skip,
                      child: const Text(
                        "Skip",
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
