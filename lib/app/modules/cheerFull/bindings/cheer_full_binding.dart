import 'package:get/get.dart';

import '../controllers/cheer_full_controller.dart';

class CheerFullBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheerFullController>(
      () => CheerFullController(),
    );
  }
}
