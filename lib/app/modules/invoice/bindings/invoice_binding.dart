import 'package:get/get.dart' as invoice_binding;

import '../controllers/invoice_controller.dart';

class InvoiceBinding extends invoice_binding.Bindings {
  @override
  void dependencies() {
    invoice_binding.Get.lazyPut<InvoiceController>(
      () => InvoiceController(),
    );
  }
}
