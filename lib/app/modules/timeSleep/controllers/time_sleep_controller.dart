import 'dart:convert';

import 'package:app/app/modules/diary/controllers/diary_controller.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../models/day_details_reposne.dart';
import '../../../models/sleeping_time_response.dart';
import '../../../network_util/shared_helper.dart';

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
      final result = await Connectivity().checkConnectivity();
      if (result != ConnectivityResult.none) {

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
      } else {
        loadingButton.value=false;
        await saveSleepTimeLocally(SleepTime(
          sleepTimeFrom: sleepTimeFrom,
          sleepTimeTo: sleepTimeTo,
            date: isToday == true
                ? DateTime.now().toString().substring(0, 10)
                : DateTime.now()
                .subtract(Duration(days: 1))
                .toString()
                .substring(0, 10)
        ));
        SleepingStatus? sleepingStatus=await getSleepTimeName(calculateTimeDifference(sleepTimeFrom,sleepTimeTo));
        controllerDiary.response.value.data?.sleepingTime = SleepingTime(
          sleepingFrom: sleepTimeFrom,
          sleepingTo: sleepTimeTo,
          sleepingDuration: calculateTimeDifference(sleepTimeFrom,sleepTimeTo),
          sleepingStatus: sleepingStatus??SleepingStatus(

          )
        );
        await ApiProvider().saveDairyLocally(controllerDiary.response.value, controllerDiary.apiDate.value);
        controllerDiary.refreshDiaryData(controllerDiary.apiDate.value, "fats");
        Fluttertoast.showToast(msg: 'Saved successfully');
        Get.toNamed(Routes.HOME);
      }

    }
  }


// Function to calculate time difference between two time strings
  String calculateTimeDifference(String startTime, String endTime) {
    // Define date format with time
    DateFormat dateFormat = DateFormat('hh:mm a');

    // Parse start and end time strings into DateTime objects
    DateTime startTimeDT = dateFormat.parse(startTime)!;
    DateTime endTimeDT = dateFormat.parse(endTime)!;

    // Calculate time difference
    Duration difference = endTimeDT.difference(startTimeDT);

    // Check if the difference is negative
    if (difference.isNegative) {
      // Add 24 hours to the difference to get the positive time difference
      difference += Duration(hours: 24);
    }

    // Convert difference to hours and minutes
    int hours = difference.inHours.remainder(24);
    int minutes = difference.inMinutes.remainder(60);

    // Format the difference as a time string
    String timeDifference = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

    return timeDifference;
  }

  Future<SleepingStatus?> getSleepTimeName(String time) async{
    int hour = int.parse(time.split(":")[0]);
    int minute = int.parse(time.split(":")[1]);

    int totalMinutes = hour * 60 + minute;

    SleepingTimesResponse? sleepingTimesResponse = await ApiProvider().readSleepingTimesLocally();

    for (int i=0; i<sleepingTimesResponse!.data!.length;i++) {
      if (totalMinutes >= sleepingTimesResponse.data![i].from * 60 && totalMinutes < sleepingTimesResponse.data![i].to * 60) {
        return SleepingStatus(
          id: sleepingTimesResponse.data![i].id,
          name: sleepingTimesResponse.data![i].name,
          image: sleepingTimesResponse.data![i].image,
        );
      }
    }

    return null; // No matching sleep time found
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
    updateTime();
    super.onInit();
  }
  updateTime(){
    print("sleepingTo");
    print(controllerDiary.response.value.data?.sleepingTime?.sleepingTo);
    if(controllerDiary.response.value.data?.sleepingTime?.sleepingTo !=null){
      selectedTimeTo = convertStringToTimeOfDay(controllerDiary.response.value.data!.sleepingTime!.sleepingTo!);
    }
    if(controllerDiary.response.value.data?.sleepingTime?.sleepingFrom !=null){
      selectedTimeFrom = convertStringToTimeOfDay(controllerDiary.response.value.data!.sleepingTime!.sleepingFrom!);
    }
    update();
  }

  TimeOfDay convertStringToTimeOfDay(String timeString) {
    // Define date format with time
    DateFormat dateFormat = DateFormat('hh:mm a');

    // Parse the time string into a DateTime object
    DateTime dateTime = dateFormat.parse(timeString);

    // Extract the hour and minute components
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    // Create a TimeOfDay object
    TimeOfDay timeOfDay = TimeOfDay(hour: hour, minute: minute);

    return timeOfDay;
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

  // Function to save sleep time data locally
  Future<void> saveSleepTimeLocally(SleepTime sleepTime) async {
    List<String> sleepTimesJson = (await SharedHelper().readStringList(CachingKey.SLEEP_TIMES)) ?? [];
    sleepTimesJson.add(jsonEncode(sleepTime.toJson()));
    await SharedHelper().writeData(CachingKey.SLEEP_TIMES, sleepTimesJson);
  }

// Function to send locally saved sleep time data to API
  Future<void> sendSavedSleepTimes() async {
    List<String> sleepTimesJson = (await SharedHelper().readStringList(CachingKey.SLEEP_TIMES)) ?? [];
    List<SleepTime> sleepTimes = sleepTimesJson
        .map((sleepTimeJson) => SleepTime.fromJson(jsonDecode(sleepTimeJson)))
        .toList();

    for (SleepTime sleepTime in sleepTimes) {
      await ApiProvider().addSleepTime(
        sleepTimeFrom: sleepTime.sleepTimeFrom,
        sleepTimeTo: sleepTime.sleepTimeTo,
        date: sleepTime.date,
      );
    }

    // Clear locally saved sleep time data after successfully sending to API
    await SharedHelper().removeData(CachingKey.SLEEP_TIMES);
  }

}

class SleepTime {
  final String sleepTimeFrom;
  final String sleepTimeTo;
  final String date;

  SleepTime({
    required this.sleepTimeFrom,
    required this.sleepTimeTo,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'sleepTimeFrom': sleepTimeFrom,
      'sleepTimeTo': sleepTimeTo,
      'date': date,
    };
  }

  factory SleepTime.fromJson(Map<String, dynamic> json) {
    return SleepTime(
      sleepTimeFrom: json['sleepTimeFrom'],
      sleepTimeTo: json['sleepTimeTo'],
      date: json['date'],
    );
  }
}