import 'package:get/get.dart';

import '../controllers/orientation_register_controller.dart';

class OrientationRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrientationRegisterController>(
      () => OrientationRegisterController(),
    );
  }
}
