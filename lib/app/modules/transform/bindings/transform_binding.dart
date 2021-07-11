import 'package:get/get.dart';

import '../controllers/transform_controller.dart';

class TransformBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransformController>(
      () => TransformController(),
    );
  }
}
