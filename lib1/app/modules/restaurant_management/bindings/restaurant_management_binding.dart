import 'package:get/get.dart';

import '../controllers/restaurant_management_controller.dart';

class RestaurantManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestaurantManagementController>(
      () => RestaurantManagementController(),
    );
  }
}
