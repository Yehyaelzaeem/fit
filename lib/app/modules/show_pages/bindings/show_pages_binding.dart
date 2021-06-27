import 'package:get/get.dart';

import '../controllers/show_pages_controller.dart';

class ShowPagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShowPagesController>(
      () => ShowPagesController(),
    );
  }
}
