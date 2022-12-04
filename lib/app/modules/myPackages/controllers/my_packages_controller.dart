import 'package:app/app/models/my_packages_response.dart';
import 'package:app/app/modules/invoice/controllers/invoice_controller.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class MyPackagesController extends GetxController
    with SingleGetTickerProviderMixin{

  final error = ''.obs;
  final loading = true.obs;
  MyPackagesResponse myPackagesResponse = MyPackagesResponse();
  void getMyPackagesList() async {
    await ApiProvider().myPackagesResponse().then((value) {
      if (value.success == true) {
        myPackagesResponse = value;
        loading.value = false;
        update();
      } else {
        Fluttertoast.showToast(msg: "Server Error");
      }
    });
  }

  @override
  void onInit() {
    if (Get.arguments != null)
      myPackagesResponse = Get.arguments;
    getMyPackagesList();
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
