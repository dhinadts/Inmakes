import 'package:get/get.dart';

class FoodDescriptionController extends GetxController {
  late final RxString title = ''.obs;
  late final RxString price = ''.obs;
  late final RxString imageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      title.value = args['title']?.toString() ?? '';
      price.value = args['price']?.toString() ?? '';
      imageUrl.value = args['imageUrl']?.toString() ?? '';
    } else {
      Get.snackbar('Error', 'Invalid food data passed');
    }
  }
}
