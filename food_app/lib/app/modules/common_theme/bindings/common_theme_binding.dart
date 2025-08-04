import 'package:get/get.dart';

import '../controllers/common_theme_controller.dart';

class CommonThemeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommonThemeController>(
      () => CommonThemeController(),
    );
  }
}
