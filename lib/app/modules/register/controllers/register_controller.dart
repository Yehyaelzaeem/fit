import 'package:app/app/utils/helper/echo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final genderIsMale = true.obs;
  final birthDate = ''.obs;
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

  selectDate() async {
    DateTime selectedDate = DateTime.now();
    DateTime firstTimeCanCustomerOrder;
    firstTimeCanCustomerOrder = DateTime(1975);

    DateTime? picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendar,
      context: Get.context!,
      locale: Locale('en'),
      initialDate: selectedDate,
      firstDate: firstTimeCanCustomerOrder,
      lastDate: DateTime.now(),
    );

    Echo('picked $picked');
    if (picked != null) {
      selectedDate = picked;
      String formatDate = '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
      birthDate.value = formatDate;
    } else {
      String formatDate = '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
      birthDate.value = formatDate;
    }
  }
}
