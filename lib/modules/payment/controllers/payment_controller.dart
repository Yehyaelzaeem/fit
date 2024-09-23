
import 'package:get/get.dart';

import '../../../config/navigation/navigation_services.dart';
import '../../../config/navigation/routes.dart';
import '../../../core/models/payment_package_response.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/utils/shared_helper.dart';

class PaymentController extends GetxController {
  final error = ''.obs;
  final loading = false.obs;
  final userPhone = ''.obs;
  final userEmail = ''.obs;
  final userName = ''.obs;
  final userLastName = ''.obs;

  getFromCash() async {
    userPhone.value = await SharedHelper().readString(CachingKey.PHONE);
    userEmail.value = await SharedHelper().readString(CachingKey.EMAIL);
    userName.value = await SharedHelper().readString(CachingKey.USER_NAME);
    userLastName.value =
        await SharedHelper().readString(CachingKey.USER_LAST_NAME);
    if (userPhone.value.isEmpty && userLastName.value.isEmpty) {
      // SharedHelper().logout();
      NavigationService.pushReplacementAll(NavigationService.navigationKey.currentState!.context,Routes.loginScreen);
    }
  }

  PackagePaymentResponse packagePaymentResponse = PackagePaymentResponse();

  void packagePayment({
    required int packageId,
  }) async {
    await getFromCash();
/*    await ApiProvider().packagePayment(
      email: userEmail.value,
      name: userName.value,
      lastName: userLastName.value,
      packageId: packageId,
      phone: userPhone.value,
    )
        .then((value) {
      if (value.success == true) {
        packagePaymentResponse = value;
        loading.value = false;
        update();
      } else {
        Fluttertoast.showToast(msg: "Server Error");
      }
    });*/
  }

  @override
  void onInit() {
    getFromCash();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  getNetworkData() async {
    error.value = '';
    loading.value = true;
    try {} catch (e) {
      Echo('error response $e');
      error.value = '$e';
    }
    loading.value = false;
  }
}
