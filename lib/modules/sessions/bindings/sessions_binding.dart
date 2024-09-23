import 'package:get/get.dart';

import '../controllers/sessions_controller.dart';

class SessionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SessionsController>(
      () => SessionsController(),
    );
  }
}
