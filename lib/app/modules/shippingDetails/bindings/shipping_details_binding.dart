import 'package:get/get.dart';

import '../controllers/shipping_details_controller.dart';

class ShippingDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShippingDetailsController>(
      () => ShippingDetailsController(),
    );
  }
}
