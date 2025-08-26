import 'package:get/get.dart';

import '../controllers/food_description_controller.dart';

class FoodDescriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodDescriptionController>(
      () => FoodDescriptionController(),
    );
  }
}
