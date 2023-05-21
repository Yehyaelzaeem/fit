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
  final userLastName = ''.obs;
  bool isGuest = false;
  bool isGuestSaved = false;
  String userId = "";
  Future<String> getFromCash() async {
    userPhone.value = await SharedHelper().readString(CachingKey.PHONE);
    userEmail.value = await SharedHelper().readString(CachingKey.EMAIL);
    userName.value =  await SharedHelper().readString(CachingKey.USER_NAME);
    userLastName.value =
        await SharedHelper().readString(CachingKey.USER_LAST_NAME);
    if (userPhone.value.isEmpty &&
        userEmail.value.isEmpty &&
        userName.value.isEmpty) {
      // Fluttertoast.showToast(msg: "Kindly enter your all data!");
      return await "noPhone";
    } else if (userLastName.value.isEmpty) {
      //  Fluttertoast.showToast(msg: "Kindly enter your all data!");
      return await "noLastName";
    } else {
      return await "haveAllData";
    }
    ;
  }

  PackagePaymentResponse packagePaymentResponse = PackagePaymentResponse();

  Future packagePayment({
    required BuildContext context,
    required int packageId,
    String? email,
    String? name,
    String? lastName,
    String? phone,
  }) async {
    userId = await SharedHelper().readString(CachingKey.USER_ID);
    isGuest = await SharedHelper().readBoolean(CachingKey.IS_GUEST);
    isGuestSaved = await SharedHelper().readBoolean(CachingKey.IS_GUEST_SAVED);
    paymentClicked();
if(isGuest!=true)    await getFromCash();
    if (userId.isNotEmpty) {
      await ApiProvider()
          .packagePayment(
        email: email ?? userEmail.value,
        name: name ?? userName.value,
        lastName: lastName ?? userLastName.value,
        packageId: packageId,
        phone: phone ?? userPhone.value, isGuest: false

      )
          .then((value) {
        if (value.success == true) {
          print("value data =>${value.data}");
          packagePaymentResponse = value;
          loading.value = false;
          paymentClicked();
          print(isPaymentClicked.value);
          update();
        } else {
          Fluttertoast.showToast(msg: "Server Error");
        }
      });
    }  else  if  (isGuest) {
      await ApiProvider()
          .packagePayment(
        email: email ?? userEmail.value,
        name: name ?? userName.value,
        lastName: lastName ?? userLastName.value,
        packageId: packageId,
        phone: phone ?? userPhone.value,
        isGuest: true
      ).then((value) async{
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
    } else {
      loading.value = false;
    }
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

  BuildContext? context;

  @override
  void onInit() {
    if (Get.arguments != null) servicesResponse = Get.arguments;
    getAllServicesData();
    if(isGuest!=true)  getFromCash();
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
