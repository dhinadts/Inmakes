import 'package:get/get.dart';

import '../controllers/admob_helper_controller.dart';

class AdmobHelperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdmobHelperController>(
      () => AdmobHelperController(),
    );
  }
}
