import 'package:app/app/models/services_response.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscribeController extends GetxController with SingleGetTickerProviderMixin {
  final error = ''.obs;
  final loading = false.obs;
  final serviceIndex = 0.obs;
  final currentPageIndex = 0.obs;


  PageController pc = new PageController(viewportFraction:0.75);
  bool smaller = false;
  final isLoading = true.obs;

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

  int selectedIndex(int index){
    serviceIndex.value = index;
    update();
    return serviceIndex.value;
  }


  @override
  void onInit() {
    if(Get.arguments != null)
      servicesResponse = Get.arguments;
      getAllServicesData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
  }

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
