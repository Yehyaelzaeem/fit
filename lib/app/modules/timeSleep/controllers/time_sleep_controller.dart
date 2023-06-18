import 'package:app/app/modules/diary/controllers/diary_controller.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class TimeSleepController extends GetxController {
  final controllerDiary = Get.find<DiaryController>(tag: 'diary');

  String? selectedGender;
  final List<String> dayTime = ["From", "To"];
  TimeOfDay selectedTimeFrom = TimeOfDay.now();
  TimeOfDay selectedTimeTo = TimeOfDay.now();
  String? select;
  RxBool? isToday;
  final loadingButton = false.obs;
  addSleepTime({
    required String sleepTimeFrom,
    required String sleepTimeTo,
  }) async {
    if (selectedTimeFrom == selectedTimeTo) {
      Fluttertoast.showToast(msg: "Please, Select time first");
    } else {
      loadingButton.value=true;
      await ApiProvider()
          .addSleepTime(
              sleepTimeFrom: sleepTimeFrom,
              sleepTimeTo: sleepTimeTo,
              date: isToday == true
                  ? DateTime.now().toString().substring(0, 10)
                  : DateTime.now()
                      .subtract(Duration(days: 1))
                      .toString()
                      .substring(0, 10))
          .then((value) {
        value.code==200? loadingButton.value=false: loadingButton.value=true;
        Fluttertoast.showToast(msg: value.message.toString());
       controllerDiary.onInit();
       Get.toNamed(Routes.HOME);
        isToday == false
            ? controllerDiary.getDiaryData(
                controllerDiary.response.value.data!.days![1].date!)
            : controllerDiary.getDiaryData(
                controllerDiary.response.value.data!.days![0].date!);
      });
    }
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
    if (Get.arguments != null) isToday = Get.arguments[0]['isToday'];
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
