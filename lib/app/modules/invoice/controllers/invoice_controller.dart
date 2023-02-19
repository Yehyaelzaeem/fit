import 'package:app/app/models/package_details_response.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:get/get.dart';

import '../../myPackages/controllers/my_packages_controller.dart';

class InvoiceController extends GetxController {
  final error = ''.obs;
  final loading = true.obs;

  PackageDetailsResponse packageDetailsResponse = PackageDetailsResponse();

  Future getPackageDetails({
    required int packageId,
  }) async {
    await ApiProvider()
        .paymentPackageDetails(packageId: packageId)
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
    Get.put(MyPackagesController());

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
