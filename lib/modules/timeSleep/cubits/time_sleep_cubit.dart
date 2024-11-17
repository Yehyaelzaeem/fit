
import 'dart:convert';

import 'package:app/modules/diary/cubits/diary_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/models/day_details_reposne.dart';


import '../../../core/models/sleeping_time_response.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/utils/shared_helper.dart';
import '../../diary/repositories/diary_repository.dart';
import '../repositories/time_sleep_repository.dart';

part 'time_sleep_states.dart';

class TimeSleepCubit extends Cubit<TimeSleepStates> {
  final TimeSleepRepository _timeSleepRepository;
  // final DiaryRepository _diaryCubit;

  TimeSleepCubit(this._timeSleepRepository) : super(TimeSleepInitialState());


  String? selectedGender;
  final List<String> dayTime = ["From", "To"];
  TimeOfDay selectedTimeFrom = TimeOfDay.now();
  TimeOfDay selectedTimeTo = TimeOfDay.now();
  String? select;
  RxBool? isToday;
  final loadingButton = false.obs;


  // Add sleep time
  Future<void> addSleepTime({
    required String sleepTimeFrom,
    required String sleepTimeTo,
    required bool isToday,
    required DiaryCubit diaryCubit
  }) async {
    emit(TimeSleepLoadingState());

    final result = await Connectivity().checkConnectivity();
    if (false) {
      final date = isToday
          ? DateTime.now().toString().substring(0, 10)
          : DateTime.now().subtract(Duration(days: 1)).toString().substring(0, 10);

      final response = await _timeSleepRepository.addSleepTime(
        sleepTimeFrom: sleepTimeFrom,
        sleepTimeTo: sleepTimeTo,
        date: date,
      );

      response.fold(
            (failure) => emit(TimeSleepFailureState(failure)),
            (sleepTimeResponse) {
          Fluttertoast.showToast(msg: sleepTimeResponse.message.toString());
/// important
          diaryCubit.onInit(); // Refresh diary
          emit(TimeSleepSuccessState());
        },
      );
    } else {
      await _saveSleepTimeOffline(sleepTimeFrom, sleepTimeTo, diaryCubit.lastSelectedDate.value,diaryCubit);
    }
    emit(TimeSleepSuccessState());

  }

  // Save sleep time locally and refresh diary
  Future<void> _saveSleepTimeOffline(String sleepTimeFrom, String sleepTimeTo, String date,DiaryCubit diaryCubit) async {
    emit(TimeSleepLoadingState());

    // final date = isToday
    //     ? DateTime.now().toString().substring(0, 10)
    //     : DateTime.now().subtract(Duration(days: 1)).toString().substring(0, 10);


    final sleepTime = SleepTime(sleepTimeFrom: sleepTimeFrom, sleepTimeTo: sleepTimeTo, date: date);

    print('sleepingStatus?.name');
    await _timeSleepRepository.saveSleepTimeLocally(sleepTime);

    // final sleepingStatus = await diaryCubit.getSleepTimeStatus(sleepTimeFrom, sleepTimeTo);
    // diaryCubit.updateSleepingData(sleepTimeFrom, sleepTimeTo, sleepingStatus);
    SleepingStatus? sleepingStatus=await getSleepTimeName(calculateTimeDifference(sleepTimeFrom,sleepTimeTo));
    diaryCubit.dayDetailsResponse!.data?.sleepingTime = SleepingTime(
        sleepingFrom: sleepTimeFrom,
        sleepingTo: sleepTimeTo,
        sleepingDuration: calculateTimeDifference(sleepTimeFrom,sleepTimeTo),
        sleepingStatus: sleepingStatus??SleepingStatus(

        )
    );


    await diaryCubit.saveDiaryLocally(diaryCubit.dayDetailsResponse!, diaryCubit.lastSelectedDate.value);
    await diaryCubit.saveDiaryToSend(diaryCubit.dayDetailsResponse!, diaryCubit.lastSelectedDate.value);

    Fluttertoast.showToast(msg: 'Saved successfully');
    emit(TimeSleepOfflineSavedState());
  }


  // addSleepTime({
  //   required String sleepTimeFrom,
  //   required String sleepTimeTo,
  //   required DiaryCubit diaryCubit,
  // }) async {
  //   if (selectedTimeFrom == selectedTimeTo) {
  //     Fluttertoast.showToast(msg: "Please, Select time first");
  //   } else {
  //     loadingButton.value=true;
  //     final result = await Connectivity().checkConnectivity();
  //     if (false) {
  //
  //       await ApiProvider()
  //           .addSleepTime(
  //           sleepTimeFrom: sleepTimeFrom,
  //           sleepTimeTo: sleepTimeTo,
  //           date: isToday == true
  //               ? DateTime.now().toString().substring(0, 10)
  //               : DateTime.now()
  //               .subtract(Duration(days: 1))
  //               .toString()
  //               .substring(0, 10))
  //           .then((value) {
  //         value.code==200? loadingButton.value=false: loadingButton.value=true;
  //         Fluttertoast.showToast(msg: value.message.toString());
  //         diaryCubit.onInit();
  //         Get.toNamed(Routes.homeScreen);
  //         isToday == false
  //             ? diaryCubit.getDiaryData(
  //             diaryCubit.response.value.data!.days![1].date!,false)
  //             : diaryCubit.getDiaryData(
  //             diaryCubit.response.value.data!.days![0].date!,false);
  //       });
  //     } else {
  //       loadingButton.value=false;
  //       await saveSleepTimeLocally(SleepTime(
  //           sleepTimeFrom: sleepTimeFrom,
  //           sleepTimeTo: sleepTimeTo,
  //           date: isToday == true
  //               ? getEgyptTime().toString().substring(0, 10)
  //               : getEgyptTime()
  //               .subtract(Duration(days: 1))
  //               .toString()
  //               .substring(0, 10)
  //       ));
  //       SleepingStatus? sleepingStatus=await getSleepTimeName(calculateTimeDifference(sleepTimeFrom,sleepTimeTo));
  //       diaryCubit.response.value.data?.sleepingTime = SleepingTime(
  //           sleepingFrom: sleepTimeFrom,
  //           sleepingTo: sleepTimeTo,
  //           sleepingDuration: calculateTimeDifference(sleepTimeFrom,sleepTimeTo),
  //           sleepingStatus: sleepingStatus??SleepingStatus(
  //
  //           )
  //       );
  //       await ApiProvider().saveDairyLocally(diaryCubit.response.value, diaryCubit.apiDate.value);
  //       await ApiProvider().saveDairyToSendLocally(diaryCubit.response.value, diaryCubit.apiDate.value);
  //       diaryCubit.refreshDiaryData(diaryCubit.apiDate.value, "fats");
  //       Fluttertoast.showToast(msg: 'Saved successfully');
  //       Get.toNamed(Routes.homeScreen);
  //     }
  //
  //   }
  // }


// Function to calculate time difference between two time strings
  String calculateTimeDifference(String startTime, String endTime) {
    // Define date format with time
    DateFormat dateFormat = DateFormat('hh:mm a');


    // Parse start and end time strings into DateTime objects
    DateTime startTimeDT = parseTime(startTime,dateFormat);
    DateTime endTimeDT = parseTime(endTime,dateFormat);

    // If the end time is before the start time, add one day to the end time
    if (endTimeDT.isBefore(startTimeDT)) {
      endTimeDT = endTimeDT.add(Duration(days: 1));
    }
    // Calculate time difference
    Duration difference = endTimeDT.difference(startTimeDT);

    // Check if the difference is negative
    if (difference.isNegative) {
      // Add 24 hours to the difference to get the positive time difference
      difference += Duration(hours: 12);
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

    SleepingTimesResponse? sleepingTimesResponse = await _timeSleepRepository.readSleepingTimesLocally();

    if(sleepingTimesResponse!=null){
      for (int i=0; i<sleepingTimesResponse.data!.length;i++) {
        if (totalMinutes >= sleepingTimesResponse.data![i].from * 60 && totalMinutes < sleepingTimesResponse.data![i].to * 60) {
          return SleepingStatus(
            id: sleepingTimesResponse.data![i].id,
            name: sleepingTimesResponse.data![i].name,
            image: sleepingTimesResponse.data![i].image,
          );
        }
      }}else{
      await _timeSleepRepository.getSleepingTimesData();
      sleepingTimesResponse = await _timeSleepRepository.readSleepingTimesLocally();
      for (int i=0; i<sleepingTimesResponse!.data!.length;i++) {
        if (totalMinutes >= sleepingTimesResponse.data![i].from * 60 && totalMinutes < sleepingTimesResponse.data![i].to * 60) {
          return SleepingStatus(
            id: sleepingTimesResponse.data![i].id,
            name: sleepingTimesResponse.data![i].name,
            image: sleepingTimesResponse.data![i].image,
          );
        }
      }
    }

    return null; // No matching sleep time found
  }

  onClickRadioButton(value) {
    print(value);
    select = value;
    emit(state);
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
      print(picked_s);
      selectedTimeFrom = picked_s;
      selectedTimeFrom.format(context);
    }
    emit(state);
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
    emit(state);
  }

  final error = ''.obs;
  final loading = false.obs;

  void onInit(
      DiaryCubit diaryCubit,
      ) {
    updateTime(diaryCubit);
  }
  updateTime(
      DiaryCubit diaryCubit,
      ){
    if(diaryCubit.dayDetailsResponse?.data?.sleepingTime?.sleepingTo !=null){
      selectedTimeTo = convertStringToTimeOfDay(diaryCubit.dayDetailsResponse!.data!.sleepingTime!.sleepingTo!);
    }
    if(diaryCubit.dayDetailsResponse?.data?.sleepingTime?.sleepingFrom !=null){
      selectedTimeFrom = convertStringToTimeOfDay(diaryCubit.dayDetailsResponse!.data!.sleepingTime!.sleepingFrom!);
    }
    emit(state);
  }


  DateTime parseTime(String time, DateFormat format) {
    // Check if the time contains AM or PM
    if (!time.contains(RegExp(r'(AM|PM|am|pm)'))) {
      // If not, assume it's in 24-hour format and add "AM" if it's before noon, "PM" otherwise
      int hour = int.parse(time.split(':')[0]);
      if (hour < 12) {
        time += ' AM';
      } else {
        time += ' PM';
      }
    }

    return format.parse(time);
  }


  TimeOfDay convertStringToTimeOfDay(String timeString) {
    // Define date format with time
    DateFormat dateFormat = DateFormat('hh:mm a');


    // Parse the time string into a DateTime object
    DateTime dateTime = parseTime(timeString,dateFormat);

    // Extract the hour and minute components
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    // Create a TimeOfDay object
    TimeOfDay timeOfDay = TimeOfDay(hour: hour, minute: minute);

    return timeOfDay;
  }

  getNetworkData() async {
    error.value = '';
    loading.value = true;
    try {} catch (e) {
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
    // List<String> sleepTimesJson = (await SharedHelper().readStringList(CachingKey.SLEEP_TIMES)) ?? [];
    // List<SleepTime> sleepTimes = sleepTimesJson
    //     .map((sleepTimeJson) => SleepTime.fromJson(jsonDecode(sleepTimeJson)))
    //     .toList();
    //
    // for (SleepTime sleepTime in sleepTimes) {
      await _timeSleepRepository.sendSavedSleepTimes(
      );


    // Clear locally saved sleep time data after successfully sending to API
    // await SharedHelper().removeData(CachingKey.SLEEP_TIMES);
  }

  getSleepingTimesData() {
    _timeSleepRepository.getSleepingTimesData();
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
