import 'package:app/app/models/my_packages_response.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class MyPackagesController extends GetxController
    with SingleGetTickerProviderMixin {
  final error = ''.obs;
  final loading = true.obs;
  final userPhone = ''.obs;
  final userEmail = ''.obs;
  final userName = ''.obs;
  final userLastName = ''.obs;
  final invoice = ''.obs;
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

  Future<String> getFromCash() async {
    invoice.value = await SharedHelper().readString(CachingKey.INVOICE);
    userPhone.value = await SharedHelper().readString(CachingKey.PHONE);
    userEmail.value = await SharedHelper().readString(CachingKey.EMAIL);
    userName.value = await SharedHelper().readString(CachingKey.USER_NAME);
    userLastName.value =
        await SharedHelper().readString(CachingKey.USER_LAST_NAME);
    if (userPhone.value.isEmpty &&
        userEmail.value.isEmpty &&
        userName.value.isEmpty) {
      //  Fluttertoast.showToast(msg: "Kindly enter your all data!");
      return await "noPhone";
    } else if (userLastName.value.isEmpty) {
      //  Fluttertoast.showToast(msg: "Kindly enter your all data!");
      return await "noLastName";
    } else {
      print("Shared = true");
      return await "haveAllData";
    }
  }

  @override
  void onInit() {
    if (Get.arguments != null) {
      myPackagesResponse = Get.arguments;
    };
    getMyPackagesList();
    //  getFromCash();
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
