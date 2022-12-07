import 'package:app/app/models/payment_package_response.dart';
import 'package:app/app/models/services_response.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SubscribeController extends GetxController
    with SingleGetTickerProviderMixin {
  final error = ''.obs;
  final loading = false.obs;
  final isPaymentClicked = false.obs;
  final serviceIndex = 0.obs;
  final currentPageIndex = 0.obs;

  PageController pc = new PageController(viewportFraction: 0.75);
  bool smaller = false;
  final isLoading = true.obs;
  final userPhone = ''.obs;
  final userEmail = ''.obs;
  final userName = ''.obs;

 Future<bool> getFromCash() async {
    userPhone.value = await SharedHelper().readString(CachingKey.PHONE);
    userEmail.value = await SharedHelper().readString(CachingKey.EMAIL);
    userName.value = await SharedHelper().readString(CachingKey.USER_NAME);
    if (userPhone.value.isEmpty &&
        userName.value.isEmpty &&
        userEmail.value.isEmpty) {
      print("Shared = false");
      return false;
    }else {
      print("Shared = true");
      return true;
    };
  }

  PackagePaymentResponse packagePaymentResponse = PackagePaymentResponse();

  Future packagePayment({
    required int packageId,
    String? email,
    String? name,
    String? phone,
  }) async {
    paymentClicked();
    await getFromCash();
    await ApiProvider()
        .packagePayment(
      email: email ?? userEmail.value,
      name: name ?? userName.value,
      packageId: packageId,
      phone: phone ?? userPhone.value,
    )
        .then((value) {
      if (value.success == true) {
        packagePaymentResponse = value;
        loading.value = false;
        paymentClicked();
        print(isPaymentClicked.value);
        update();
      } else {
        Fluttertoast.showToast(msg: "Server Error");
      }
    });
  }

  ServicesResponse servicesResponse = ServicesResponse();

  void getAllServicesData() async {
    await ApiProvider().getServices().then((value) {
      if (value.success == true) {
        servicesResponse = value;
        isLoading.value = false;
        update();
      } else {
        print("error");
      }
    });
  }

  int selectedIndex(int index) {
    serviceIndex.value = index;
    update();
    return serviceIndex.value;
  }


  paymentClicked() {
    isPaymentClicked.value = !isPaymentClicked.value;
    update();
  }

  @override
  void onInit() {
    if (Get.arguments != null) servicesResponse = Get.arguments;
    getAllServicesData();
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
