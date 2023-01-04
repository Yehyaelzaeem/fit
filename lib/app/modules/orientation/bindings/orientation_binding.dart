import 'package:get/get.dart';

import '../controllers/orientation_controller.dart';

class OrientationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrientationController>(
      () => OrientationController(),
    );
  }
}
