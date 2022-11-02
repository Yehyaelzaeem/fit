import 'package:app/app/utils/helper/echo.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  final error = ''.obs;
  final loading = false.obs;
  @override
  void onInit() {
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
  }}
