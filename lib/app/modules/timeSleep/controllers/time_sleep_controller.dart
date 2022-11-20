import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class TimeSleepController extends GetxController {
  String? selectedGender;
  final List<String> dayTime = ["From", "To"];
  TimeOfDay selectedTimeFrom = TimeOfDay.now();
  TimeOfDay selectedTimeTo = TimeOfDay.now();
  String? select;

  addSleepTime({
    required String sleepTimeFrom,
    required String sleepTimeTo,
  }) async {
    await ApiProvider()
        .addSleepTime(sleepTimeFrom: sleepTimeFrom, sleepTimeTo: sleepTimeTo)
        .then((value) {
      Fluttertoast.showToast(msg: value.message.toString());
      Get.toNamed(Routes.HOME);
    });
  }

  onClickRadioButton(value) {
    print(value);
    select = value;
    update();
    return value;
  }

  Future<void> selectTimeFrom(
    BuildContext context,
  ) async {
    final TimeOfDay? picked_s = await showTimePicker(
      context: context,
      initialTime: selectedTimeFrom,
    );
    if (picked_s != null) {
      selectedTimeFrom = picked_s;
      selectedTimeFrom.format(context);
    }
    update();
  }

  Future<void> selectTimeTo(
    BuildContext context,
  ) async {
    final TimeOfDay? picked_s = await showTimePicker(
      context: context,
      initialTime: selectedTimeTo,
    );
    if (picked_s != null) {
      selectedTimeTo = picked_s;
      selectedTimeTo.format(context);
    }
    update();
  }

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
  }
}
