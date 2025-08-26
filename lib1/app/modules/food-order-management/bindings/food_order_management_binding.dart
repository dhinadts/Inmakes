import 'package:get/get.dart';

import '../controllers/food_order_management_controller.dart';

class FoodOrderManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodOrderController>(
      () => FoodOrderController(),
    );
  }
}
