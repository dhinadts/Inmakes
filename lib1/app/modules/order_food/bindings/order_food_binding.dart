import 'package:get/get.dart';

import '../controllers/order_food_controller.dart';

class OrderFoodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderFoodController>(
      () => OrderFoodController(),
    );
  }
}
