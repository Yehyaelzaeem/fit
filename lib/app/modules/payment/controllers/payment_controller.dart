import 'package:app/app/models/payment_package_response.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:get/get.dart';

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
      SharedHelper().logout();
      Get.offAllNamed(Routes.LOGIN);
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
