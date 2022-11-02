import 'package:get/get.dart';

import '../controllers/subscribe_controller.dart';

class SubscribeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscribeController>(
      () => SubscribeController(),
    );
  }
}
