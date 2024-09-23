
import 'package:get/get.dart';

import '../../../core/models/package_details_response.dart';
import '../../../core/services/api_provider.dart';


class InvoiceController extends GetxController {
  final error = ''.obs;
  final loading = true.obs;

  PackageDetailsResponse packageDetailsResponse = PackageDetailsResponse();

  Future getPackageDetails({
    required int packageId,
  }) async {
    await ApiProvider().paymentPackageDetails(packageId: packageId)
        .then((value) {
      if (value.success == true) {
        packageDetailsResponse = value;
        loading.value = false;
        update();
      } else {
        print(value);
      }
    });
  }

  @override
  void onInit() {
    if (Get.arguments != null) packageDetailsResponse = Get.arguments;
   // Get.lazyPut<MyPackagesController>(() => MyPackagesController());
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
