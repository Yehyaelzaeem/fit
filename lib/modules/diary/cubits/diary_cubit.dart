
import 'dart:math';

import 'package:app/core/resources/app_values.dart';
import 'package:app/core/utils/globals.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/day_details_reposne.dart';

import '../../../core/models/my_other_calories_response.dart';
import '../../../core/models/other_calories_units_repose.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/utils/shared_helper.dart';
import '../../home/view/screens/home_screen.dart';
import '../../other_calories/repositories/other_calories_repository.dart';
import '../../pdf_viewr.dart';
import '../../timeSleep/cubits/time_sleep_cubit.dart';
import '../models/diary_data.dart';
import '../repositories/diary_repository.dart';
import 'package:timezone/timezone.dart' as tz;

part 'diary_states.dart';

DateTime? otherLoaded;
bool isSending = false;
bool sendingOffline = false;
class DiaryCubit extends Cubit<DiaryState> {
  final DiaryRepository _diaryRepository;
  final TimeSleepCubit _timeSleepCubit;
  final OtherCaloriesRepository _otherCaloriesRepository;

  DiaryCubit(this._diaryRepository,this._timeSleepCubit,this._otherCaloriesRepository) : super(DiaryInitial());
  static const String lastBackgroundTimeKey = "LAST_BACKGROUND_TIME";

  void handleLifecycleChange(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      // App is going to background
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(lastBackgroundTimeKey, getEgyptTime().millisecondsSinceEpoch);
    } else if (state == AppLifecycleState.resumed) {
      // App is coming to foreground
      final prefs = await SharedPreferences.getInstance();
      int? lastBackgroundTime = prefs.getInt(lastBackgroundTimeKey);

      if (lastBackgroundTime != null) {
        final lastBackgroundDateTime = DateTime.fromMillisecondsSinceEpoch(lastBackgroundTime);
        final difference = getEgyptTime().difference(lastBackgroundDateTime);

        if (getEgyptTime().toString().substring(0,10) != lastBackgroundDateTime.toString().substring(0,10)){

          await viewCachedRequests();
          // response.value = await _diaryRepository.getDiaryView(lastSelectedDate.value,true,true,false);
          // refreshDiaryData(lastSelectedDate.value, type);
          onInit();
        }
      }
    }
  }

  GlobalKey<FormState> key = GlobalKey();
  TextEditingController textEditController = TextEditingController();
  List<SingleImageItem> waterBottlesList = [];
  List<CaloriesDetails> caloriesDetails = [];
  List<CaloriesDetails> carbsDetails = [];
  List<CaloriesDetails> fatsDetails = [];

  List<CaloriesDetails> caloriesDeleted = [];
  List<CaloriesDetails> carbsDeleted = [];
  List<CaloriesDetails> fatsDeleted = [];
  MyOtherCaloriesResponse otherCaloriesResponse = MyOtherCaloriesResponse();

  DayDetailsResponse? dayDetailsResponse;
  FocusNode workoutTitleDescFocus = FocusNode();
  final isLoading = true.obs;
  final refreshLoadingProtine = false.obs;
  final refreshLoadingCarbs = false.obs;
  final refreshLoadingFats = false.obs;
  bool isToday = false;
  final noSessions = false.obs;
  final showLoader = false.obs;
  final lastSelectedDate = ''.obs;
  final date = ''.obs;
  final apiDate = ''.obs;
  final workOutData = ''.obs;
  final qtyProtine = ''.obs;
  final foodProtine = ''.obs;
  String? workDesc;
  final length = 0.obs;
  final workOut = 0.obs;
  bool isAdding = false;

  getNotifications() async {
    if (await Permission.accessNotificationPolicy.isPermanentlyDenied &&
        await Permission.accessNotificationPolicy.isDenied &&
        await Permission.accessNotificationPolicy.isRestricted) {
      Permission.notification.request();
    }
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });
    await Permission.notification.isRestricted.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });
    await Permission.notification.isPermanentlyDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });
  }

  bool isOnInit = false;

  void onInit() async{
    if(!isOnInit) {
      isOnInit = true;
      isSending = true;
      if (lastSelectedDate.value == '') {
        lastSelectedDate.value = getEgyptTime().toString().substring(0, 10);
      }

      getNotifications();
      getFromCash();
      await viewCachedRequests();
      await loadData();
      isOnInit = false;
      // isLoading.value = false;
      // if(iSLoggedNow) {
      //   isLoading.value = true;
      //   await Future.delayed(Duration(seconds: 10));
      //   isLoading.value = false;
      // }
    }else{

    }
    //   _initData();
  }



  Future<void> loadData() async {
    emit(DiaryLoading());

    try {
      DateTime? lastLoadTime = await _diaryRepository.getLastLoadingTime();
      final result = await Connectivity().checkConnectivity();

      if (result != ConnectivityResult.none) {
        if (lastLoadTime == null || lastLoadTime.isBefore(getEgyptTime().subtract(Duration(days: 1)))) {
          await _timeSleepCubit.getSleepingTimesData();
          if (currentUser!=null) {
            await fetchOtherCalories;
            await fetchOtherCaloriesUnits();
            await _diaryRepository.saveLastLoadingTime(getEgyptTime());
          }
        }
      } else {
        if (lastLoadTime != null && lastLoadTime.isBefore(getEgyptTime().subtract(Duration(days: 2)))) {
          Fluttertoast.showToast(
            msg: "Please connect to the internet",
            toastLength: Toast.LENGTH_LONG,
          );
        }
      }
      emit(DiaryLoaded());
    } catch (e) {
      emit(DiaryError(e.toString()));
    }
  }

  Future viewCachedRequests()async{
// Listen for connectivity changes

    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      isLoading.value =  true;
      emit(DiaryLoading());
      await _otherCaloriesRepository.createOtherCaloriesData();

      await _diaryRepository.sendSavedDiaryDataByDay();
      await _timeSleepCubit.sendSavedSleepTimes();
      isSending = false;
      await getDiaryData(
          lastSelectedDate.value != '' ? lastSelectedDate.value :
          getEgyptTime().toString().substring(0, 10),isSending);
      // isLoading.value =  false;
      emit(DiaryLoaded());


    }
  }
  Future sendSavedDiaryDataByDay()async{
    print('sendSavedDiaryDataByDay Cubit');
    await _diaryRepository.sendSavedDiaryDataByDay();

  }
  Future sendSavedSleepTimes()async{
    await _timeSleepCubit.sendSavedSleepTimes();

  }



  String _timezone = 'Unknown';
  List<String> _availableTimezones = <String>[];

  final isLogged = false.obs;

  void getFromCash() async {
    isLogged.value = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    if (isLogged.value != true) {
      // Navigator.pushAndRemoveUntil(
      //     Get.context!,
      //     MaterialPageRoute(
      //       builder: (context) => UnAuthView(),
      //     ),
      //     (Route<dynamic> route) => false);
      // getDiaryData(getEgyptTime().toString().substring(0, 10));

    } else {
      final result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none){
        getDiaryData(getEgyptTime().toString().substring(0, 10),isSending);

      }
    }
  }

  void getDiaryDataRefreshResponse(String _date) async {
    if(isToday){
      _diaryRepository.getDiaryView(dayDetailsResponse!.data!.days![1].date!.toString(),!isSending,false,true);
    }else{
      _diaryRepository.getDiaryView(dayDetailsResponse!.data!.days![0].date!.toString(),!isSending,false,true);
    }
    // isLoading.value = true;
    // try {
    //   await _diaryRepository.getDiaryView(_date,!isSending,false,true).then((value) {
    //     if (value.success == false && value.data == null) {
    //       noSessions.value = true;
    //     } else {
    //       response.value = value;
    //     }
    //     if(isToday.value){
    //       _diaryRepository.getDiaryView(response.value.data!.days![1].date!.toString(),!isSending,false,true);
    //     }else{
    //       _diaryRepository.getDiaryView(response.value.data!.days![0].date!.toString(),!isSending,false,true);
    //     }
    //   });
    // } catch (e) {}
    // isLoading.value = false;
  }



  Future getDiaryData(String _date,bool isSending) async {
    print("DATEDATE$_date");
    if(dayDetailsResponse?.data!=null) {
      if (isLoading.value) return;
      if (refreshLoadingProtine.value) return;
      if (refreshLoadingCarbs.value) return;
      if (refreshLoadingFats.value) return;
    }
    lastSelectedDate.value = _date;
    isLoading.value = true;
    emit(DiaryLoading());

    caloriesDetails.clear();
    carbsDetails.clear();
    fatsDetails.clear();

    if(sendingOffline == true){
      await Future.delayed(Duration(seconds: 3));
    }

    final result = await _diaryRepository.getDiaryView(_date,!isSending,false,true);

    result.fold(
          (failure) => emit(DiaryFailure(failure)),
          (value) {
            if (value.success == false && value.data == null) {
              //  isLoading.value = false;
              //  noSessions.value = true;
              // SharedHelper().logout();
              // Get.offAllNamed(Routes.LOGIN);
              // Fluttertoast.showToast(msg: "${value.message}");
            } else {
              if (value.data != null) {


                dayDetailsResponse = value;
                isLoading.value = false;
                showLoader.value = false;
                emit(DiaryLoaded());
                length.value = dayDetailsResponse!.data!.water! + 3;
                workOut.value = dayDetailsResponse!.data!.workouts![0].id!;
                workDesc = dayDetailsResponse!.data!.dayWorkouts == null
                    ? " "
                    : dayDetailsResponse!.data!.dayWorkouts!.workoutDesc!;
                textEditController.text = dayDetailsResponse!.data!.dayWorkouts == null
                    ? " "
                    : dayDetailsResponse!.data!.dayWorkouts!.workoutDesc!;
                workOutData.value = dayDetailsResponse!.data!.dayWorkouts == null
                    ? " "
                    : dayDetailsResponse!.data!.dayWorkouts!.workoutType!;
                waterBottlesList.clear();

                if(dayDetailsResponse!.data!.days![0].date != getEgyptTime().toString().substring(0,10)){
                  String date = getEgyptTime().toString().substring(0,10);
                  List<Days> newDays= List.generate(3, (index){
                    if(index==0){
                      return  Days(date: date,dateFormat: DateFormat('EEEE, d MMMM y').format(DateTime.parse(date)),active: dayDetailsResponse!.data!.days!.firstWhere((element) => element.date == date).active);
                    }else
                    if(index==1) {
                      return  Days(date: DateTime.parse(date).subtract(Duration(days: 1))
                          .toString()
                          .substring(0, 10),
                          dateFormat: DateFormat('EEEE, d MMMM y').format(
                              DateTime.parse(date).subtract(Duration(days: 1))),
                          active: dayDetailsResponse!.data!.days!.firstWhere((element) => element.date == getEgyptTime().subtract(Duration(days: 1)).toString().substring(0,10)).active
                      );
                    }else
                    if(index==2) {
                      return  Days(date: DateTime.parse(date).add(Duration(days: 1))
                          .toString()
                          .substring(0, 10),
                          dateFormat: DateFormat('EEEE, d MMMM y').format(
                              DateTime.parse(date).add(Duration(days: 1))),
                          active: false);
                    }else{
                      return Days(date: DateTime.parse(date).add(Duration(days: 1))
                          .toString()
                          .substring(0, 10),
                          dateFormat: DateFormat('EEEE, d MMMM y').format(
                              DateTime.parse(date).add(Duration(days: 1))),
                          active: false);
                    }
                  });
                  dayDetailsResponse!.data!.days = newDays;
                  _diaryRepository.saveDairyLocally(dayDetailsResponse!, date!);
                }

                print("CAaaaHnge");
                if (dayDetailsResponse!.data!.days![0].active == true) {
                  isToday = true;
                } else {
                  isToday = false;
                }
                emit(state);
                for (int i = 0; i < dayDetailsResponse!.data!.days!.length; i++) {
                  if (dayDetailsResponse!.data!.days![i].active == true) {
                    date.value = dayDetailsResponse!.data!.days![i].dateFormat!;
                    apiDate.value = dayDetailsResponse!.data!.days![i].date!;
                  } else {}
                }


                for (int i = 1; i <= length.value; i++) {
                  if (i <= dayDetailsResponse!.data!.water!) {
                    waterBottlesList.add(
                      SingleImageItem(
                          id: i,
                          imagePath: 'assets/img/im_holder1.png',
                          selected: true),
                    );
                  } else {
                    waterBottlesList.add(
                      SingleImageItem(
                          id: i,
                          imagePath: 'assets/img/im_holder1.png',
                          selected: false),
                    );
                  }
                }

              } else {
                if (lastSelectedDate.value.isNotEmpty) {
                  getDiaryData(lastSelectedDate.value,isSending);
                } else {
                  getDiaryData(getEgyptTime().toString().substring(0, 10),isSending);
                }
                dayDetailsResponse = value;
                isLoading.value = false;
                showLoader.value = false;
                emit(DiaryLoaded());

                date.value = _date;
                print("error");
              }

              refreshCaloriesList(dayDetailsResponse!.data!.proteins!.caloriesDetails ?? []);
              refreshCarbsList(dayDetailsResponse!.data!.carbs!.caloriesDetails ?? []);
              refreshFatsList(dayDetailsResponse!.data!.fats!.caloriesDetails ?? []);
      }
            },
    );


    await _diaryRepository.getDiaryView(_date,!isSending,false,true).then((value) async{

        // caloriesDetails.addAll(dayDetailsResponse!.data!.proteins!.caloriesDetails!);
        // carbsAndFats.addAll(dayDetailsResponse!.data!.carbsFats!.caloriesDetails!);
      }
    );

    try {
      // important
      // await _diaryRepository.getHomeData().then((value) {
      //   if (value.success == true) {
      //     globalIsIosInReview = (value.data!.subscriptionStatus == false);
      //   } else {}
      // });
    } catch (e) {}


  }

  addNewRow(String type){
    if (type == 'proteins') {
      caloriesDetails.add(CaloriesDetails());
      // diaryCubit.caloriesDetails.add(CaloriesDetails());
    } else if (type == 'carbs') {
      carbsDetails.add(CaloriesDetails());
    } else {
      fatsDetails.add(CaloriesDetails());
    }
    emit(DiaryLoaded());

  }

  Future<void> saveDiaryLocally(DayDetailsResponse dayDetailsResponse, String date) async {
    try {
      await _diaryRepository.saveDairyLocally(dayDetailsResponse, date);
      // emit(DiarySavedSuccess());
    } catch (e) {
      emit(DiaryError(e.toString()));
    }
  }

  Future<void> saveDiaryToSend(DayDetailsResponse dayDetailsResponse, String date) async {
    try {
      await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse, date);
      // emit(DiaryLoaded());
    } catch (e) {
      emit(DiaryError(e.toString()));
    }
  }



  Future<void> refreshDiaryData(String date, String type) async {
    emit(DiaryLoading());

    print('Refresh');

    final result = await _diaryRepository.getDiaryView(date, !isSending, false, false);

    result.fold(
          (failure) => emit(DiaryFailure(failure)),
          (data) {
        // Logic to refresh and update the lists
        _updateCalorieLists(data);
        dayDetailsResponse = data;
        emit(DiarySuccess());
      },
    );
  }

  void _updateCalorieLists(DayDetailsResponse data) {
    if (data.data!.proteins!.caloriesDetails!.isNotEmpty) {
      // Update proteins list
      data.data!.proteins!.caloriesDetails!.forEach((element) {
        if (caloriesDetails
            .where((element2) => element.id == element2.id &&element.randomId == element2.randomId)
            .toList()
            .length >
            0) {
          print("element"+element.quality.toString()+element.randomId.toString());

          caloriesDetails.forEach((item) {
            if (item.id == element.id  && element.randomId == item.randomId) {
              print("item"+item.quality.toString()+item.randomId.toString());
              item.quality = element.quality;
              item.qty = element.qty;
              item.calories = element.calories;
            }
          });
        } else {
          refreshCaloriesList(
              dayDetailsResponse!.data!.proteins!.caloriesDetails ?? []);
        }
      });

    }
    if (data.data!.carbs!.caloriesDetails!.isNotEmpty) {
      // Update carbs list
      data.data!.carbs!.caloriesDetails!.forEach((element) {
        if (carbsDetails
            .where((element2) => element.id == element2.id &&element.randomId == element2.randomId)
            .toList()
            .length >
            0) {


          carbsDetails.forEach((item) {
            print("item"+item.quality.toString()+item.randomId.toString());
            if (item.id == element.id && element.randomId == item.randomId) {
              print(item.quality);
              print(element.quality);
              print("AAAA");
              item.quality = element.quality;
              item.qty = element.qty;
              item.calories = element.calories;
            }
          });
        } else {
          refreshCarbsList(dayDetailsResponse!.data!.carbs!.caloriesDetails ?? []);
        }
      });

    }
    if (data.data!.fats!.caloriesDetails!.isNotEmpty) {
      // Update fats list
      dayDetailsResponse!.data!.fats!.caloriesDetails!.forEach((element) {
        if (fatsDetails
            .where((element2) => element.id == element2.id &&element.randomId == element2.randomId)
            .toList()
            .length >
            0) {
          fatsDetails.forEach((item) {
            if (item.id == element.id  && element.randomId == item.randomId) {
              item.quality = element.quality;
              item.qty = element.qty;
              item.calories = element.calories;
            }
          });
        } else {
          refreshFatsList(dayDetailsResponse!.data!.fats!.caloriesDetails ?? []);
        }
      });

    }
  }


  Future refreshDiaryDataLive(String _date) async {

    lastSelectedDate.value = _date;

    // await checkDeletion();
    final result = await _diaryRepository.getDiaryView(lastSelectedDate.value,true,false,true);

    result.fold(
            (failure) => emit(DiaryFailure(failure)),
            (value)
    {
      dayDetailsResponse = value;

      if (dayDetailsResponse!.data!.proteins!.caloriesDetails!.isEmpty &&
          dayDetailsResponse!.data!.carbs!.caloriesDetails!.isEmpty &&
          dayDetailsResponse!.data!.fats!.caloriesDetails!.isEmpty) {
        // if (type == 'proteins') refreshLoadingProtine.value = false;
        // if (type == 'carbs') refreshLoadingCarbs.value = false;
        // if (type == 'fats') refreshLoadingFats.value = false;
        return;
      } else {
        // caloriesDetails.removeWhere((element) => element.id == null);
        // carbsAndFats.removeWhere((element) => element.id == null);
        dayDetailsResponse!.data!.proteins!.caloriesDetails!.forEach((element) {
          if (caloriesDetails
              .where((element2) =>
          element.id == element2.id && element.randomId == element2.randomId)
              .toList()
              .length >
              0) {
            caloriesDetails.forEach((item) {
              if (item.id == element.id && element.randomId == item.randomId) {
                item.quality = element.quality;
                item.qty = element.qty;
                item.calories = element.calories;
              }
            });
          } else {
            refreshCaloriesList(
                dayDetailsResponse!.data!.proteins!.caloriesDetails ?? []);
          }
        });
        dayDetailsResponse!.data!.carbs!.caloriesDetails!.forEach((element) {
          if (carbsDetails
              .where((element2) =>
          element.id == element2.id && element.randomId == element2.randomId)
              .toList()
              .length >
              0) {
            carbsDetails.forEach((item) {
              if (item.id == element.id && element.randomId == item.randomId) {
                item.quality = element.quality;
                item.qty = element.qty;
                item.calories = element.calories;
              }
            });
          } else {
            refreshCarbsList(dayDetailsResponse!.data!.carbs!.caloriesDetails ?? []);
          }
        });

        dayDetailsResponse!.data!.fats!.caloriesDetails!.forEach((element) {
          if (fatsDetails
              .where((element2) =>
          element.id == element2.id && element.randomId == element2.randomId)
              .toList()
              .length >
              0) {
            fatsDetails.forEach((item) {
              if (item.id == element.id && element.randomId == item.randomId) {
                item.quality = element.quality;
                item.qty = element.qty;
                item.calories = element.calories;
              }
            });
          } else {
            refreshFatsList(
                dayDetailsResponse!.data!.fats!.caloriesDetails ?? []);
          }
        });
      }
      emit(DiaryLoaded());
    });


  }


  Future<void> deleteItemCalories(int id, String _date, String type) async {

    final result = await Connectivity().checkConnectivity();
    if (false) {
      // dayDetailsResponse!.data!.proteins!
      //     .caloriesDetails!.removeWhere((element) => element.id==id);
      //
      // await calculateProteins();
      //
      // await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
      //
      // // refreshDiaryData(apiDate.value, type);
      // await _diaryRepository
      //     .deleteCalorie("delete_calories_details", id)
      //     .then((value) {
      //   if (value.success == true) {
      //     caloriesDetails.removeWhere((element) => element.id == id);
      //     // refreshDiaryData(apiDate.value, type);
      //   } else {
      //     caloriesDetails.removeWhere((element) => element.id == id);
      //     // refreshDiaryData(apiDate.value, type);
      //     Fluttertoast.showToast(msg: "${value.message}");
      //   }
      // });
    }else{
      await _diaryRepository.deleteCalorieLocally(id);

      dayDetailsResponse!.data!.proteins!
          .caloriesDetails!.removeWhere((element) => element.id==id);

      await calculateProteins();

      await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, apiDate.value);
      await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
      refreshDiaryData(apiDate.value, type);
    }
  }

  Future<void> deleteItemCarbs(int id, String _date, String type) async {

    final result = await Connectivity().checkConnectivity();
    if (false) {
      // dayDetailsResponse!.data!.carbs!
      //     .caloriesDetails!.removeWhere((element) => element.id==id);
      //
      // await calculateCarbs();
      //
      // await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
      //
      // // refreshDiaryData(apiDate.value, type);
      // await _diaryRepository
      //     .deleteCalorie("delete_calories_details", id)
      //     .then((value) {
      //   if (value.success == true) {
      //     carbsDetails.removeWhere((element) => element.id == id);
      //     // refreshDiaryData(apiDate.value, type);
      //   } else {
      //     carbsDetails.removeWhere((element) => element.id == id);
      //     // refreshDiaryData(apiDate.value, type);
      //     Fluttertoast.showToast(msg: "${value.message}");
      //   }
      // });

    }else{
      await _diaryRepository.deleteCalorieLocally(id);

      dayDetailsResponse!.data!.carbs!
          .caloriesDetails!.removeWhere((element) => element.id==id);

      await calculateCarbs();

      await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, apiDate.value);
      await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
      refreshDiaryData(apiDate.value, type);
    }
  }

  Future<void> deleteItemFats(int id, String _date, String type) async {

    final result = await Connectivity().checkConnectivity();
    if (false) {

    }else{
      await _diaryRepository.deleteCalorieLocally(id);

      dayDetailsResponse!.data!.fats!
          .caloriesDetails!.removeWhere((element) => element.id==id);


      await calculateFats();

      await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, apiDate.value);
      await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
      refreshDiaryData(apiDate.value, type);
    }
  }

  Future<void> deleteItemCaloriesCached(int randomId, String _date, String type) async {

    await _diaryRepository.removeCachedDiaryDataLocally(randomId);
    // dayDetailsResponse!.data!.proteins!.caloriesTotal!.taken = double.parse(dayDetailsResponse!.data!.proteins!.caloriesTotal!.taken.toString())-double.parse(dayDetailsResponse!.data!.proteins!.caloriesDetails!.firstWhere((element) => element.randomId==randomId).calories.toString());
    // dayDetailsResponse!.data!.proteins!.caloriesTotal!.progress?.percentage = (double.parse(dayDetailsResponse!.data!.proteins!.caloriesTotal!.taken.toString())/double.parse(dayDetailsResponse!.data!.proteins!.caloriesTotal!.imposed.toString()))*100.toInt();
    // if(dayDetailsResponse!.data!.proteins!.caloriesTotal!.progress?.percentage >0){
    //   dayDetailsResponse!.data!.proteins!.caloriesTotal!.progress!.bg = '4169E1';
    // }else if(dayDetailsResponse!.data!.proteins!.caloriesTotal!.progress?.percentage >100){
    //   dayDetailsResponse!.data!.proteins!.caloriesTotal!.progress!.bg = 'f00000';
    // }
    dayDetailsResponse!.data!.proteins!
        .caloriesDetails!.removeWhere((element) => element.randomId==randomId);

    await calculateProteins();

    caloriesDetails.removeWhere((element) => element.randomId==randomId);
    await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, apiDate.value);
    await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
    refreshDiaryData(apiDate.value, type);

  }

  Future<void> deleteItemCarbsCached(int randomId, String _date, String type) async {

    await _diaryRepository.removeCachedDiaryDataLocally(randomId);

    dayDetailsResponse!.data!.carbs!
        .caloriesDetails!.removeWhere((element) => element.randomId==randomId);
    carbsDetails.removeWhere((element) => element.randomId==randomId);


    await calculateCarbs();


    await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, apiDate.value);
    await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
    refreshDiaryData(apiDate.value, type);

  }

  Future<void> deleteItemFatsCached(int randomId, String _date, String type) async {

    await _diaryRepository.removeCachedDiaryDataLocally(randomId);

    dayDetailsResponse!.data!.fats!
        .caloriesDetails!.removeWhere((element) => element.randomId==randomId);
    fatsDetails.removeWhere((element) => element.randomId==randomId);

    await calculateFats();

    await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, apiDate.value);
    await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);

    refreshDiaryData(apiDate.value, type);

  }


  Future<void> fetchOtherCalories() async {
    emit(DiaryLoading());
    try {
      final response = await _diaryRepository.getOtherCalories();
      otherCaloriesResponse = response;
      emit(DiaryLoadedOtherCalories());
    } catch (e) {
      emit(DiaryError(e.toString()));
    }
  }

  Future<void> fetchOtherCaloriesUnits() async {
    emit(DiaryLoading());
    try {
      final response = await _diaryRepository.getOtherCaloriesUnit();
      // emit(DiaryLoadedOtherCaloriesUnits(response));
    } catch (e) {
      emit(DiaryError(e.toString()));
    }
  }

  calculateProteins(){
    if(dayDetailsResponse!.data!.proteins!
        .caloriesDetails!.isEmpty){
      dayDetailsResponse!.data!.proteins!.caloriesTotal!.taken = 0.0.toStringAsFixed(2);
    }
    dayDetailsResponse!.data!.proteins!.caloriesTotal!.taken = dayDetailsResponse!.data!.proteins!
        .caloriesDetails!.fold(0.0, (previousValue, element) => previousValue+ double.parse(element.calories.toString().replaceAll(',', ''))).toStringAsFixed(2);
    dayDetailsResponse!.data!.proteins!.caloriesTotal!.progress?.percentage = (double.parse(dayDetailsResponse!.data!.proteins!.caloriesTotal!.taken.toString())/double.parse(dayDetailsResponse!.data!.proteins!.caloriesTotal!.imposed.toString()))*100.toInt();
    if(dayDetailsResponse!.data!.proteins!.caloriesTotal!.progress?.percentage <100){
      dayDetailsResponse!.data!.proteins!.caloriesTotal!.progress!.bg = '4169E1';
    }else if(dayDetailsResponse!.data!.proteins!.caloriesTotal!.progress?.percentage >100){
      dayDetailsResponse!.data!.proteins!.caloriesTotal!.progress!.bg = 'f00000';
    }
    if((double.parse(dayDetailsResponse!.data!.proteins!.caloriesTotal!.imposed.toString())-double.parse(dayDetailsResponse!.data!.proteins!.caloriesTotal!.taken.toString()))<=50 && (double.parse(dayDetailsResponse!.data!.proteins!.caloriesTotal!.imposed.toString())-double.parse(dayDetailsResponse!.data!.proteins!.caloriesTotal!.taken.toString()))>=-25){
      dayDetailsResponse!.data!.proteins!.caloriesTotal!.progress!.bg = '7fc902';
    }
  }
  calculateCarbs(){
    if(dayDetailsResponse!.data!.carbs!
        .caloriesDetails!.isEmpty){
      dayDetailsResponse!.data!.carbs!.caloriesTotal!.taken = 0.0.toStringAsFixed(2);
    }
    dayDetailsResponse!.data!.carbs!.caloriesTotal!.taken = dayDetailsResponse!.data!.carbs!
        .caloriesDetails!.fold(0.0, (previousValue, element) => previousValue+ double.parse(element.calories.toString().replaceAll(',', ''))).toStringAsFixed(2);

    dayDetailsResponse!.data!.carbs!.caloriesTotal!.progress?.percentage = (double.parse(dayDetailsResponse!.data!.carbs!.caloriesTotal!.taken.toString())/double.parse(dayDetailsResponse!.data!.carbs!.caloriesTotal!.imposed.toString()))*100.toInt();
    if(dayDetailsResponse!.data!.carbs!.caloriesTotal!.progress?.percentage <100){
      dayDetailsResponse!.data!.carbs!.caloriesTotal!.progress!.bg = '4169E1';
    }else if(dayDetailsResponse!.data!.carbs!.caloriesTotal!.progress?.percentage >100){
      dayDetailsResponse!.data!.carbs!.caloriesTotal!.progress!.bg = 'f00000';
    }

    if((double.parse(dayDetailsResponse!.data!.carbs!.caloriesTotal!.imposed.toString())-double.parse(dayDetailsResponse!.data!.carbs!.caloriesTotal!.taken.toString()))<=50 && (double.parse(dayDetailsResponse!.data!.carbs!.caloriesTotal!.imposed.toString())-double.parse(dayDetailsResponse!.data!.carbs!.caloriesTotal!.taken.toString()))>=-25){
      dayDetailsResponse!.data!.carbs!.caloriesTotal!.progress!.bg = '7fc902';
    }
  }
  calculateFats(){
    if(dayDetailsResponse!.data!.fats!
        .caloriesDetails!.isEmpty){
      dayDetailsResponse!.data!.fats!.caloriesTotal!.taken = 0.0.toStringAsFixed(2);
    }
    dayDetailsResponse!.data!.fats!.caloriesTotal!.taken = dayDetailsResponse!.data!.fats!
        .caloriesDetails!.fold(0.0, (previousValue, element) => previousValue+ double.parse(element.calories.toString().replaceAll(',', ''))).toStringAsFixed(2);

    dayDetailsResponse!.data!.fats!.caloriesTotal!.progress?.percentage = (double.parse(dayDetailsResponse!.data!.fats!.caloriesTotal!.taken.toString())/double.parse(dayDetailsResponse!.data!.fats!.caloriesTotal!.imposed.toString()))*100.toInt();
    if(dayDetailsResponse!.data!.fats!.caloriesTotal!.progress?.percentage <100){
      dayDetailsResponse!.data!.fats!.caloriesTotal!.progress!.bg = '4169E1';
    }else if(dayDetailsResponse!.data!.fats!.caloriesTotal!.progress?.percentage > 100){
      dayDetailsResponse!.data!.fats!.caloriesTotal!.progress!.bg = 'f00000';
    }

    if((double.parse(dayDetailsResponse!.data!.fats!.caloriesTotal!.imposed.toString())-double.parse(dayDetailsResponse!.data!.fats!.caloriesTotal!.taken.toString()))<=50 && (double.parse(dayDetailsResponse!.data!.fats!.caloriesTotal!.imposed.toString())-double.parse(dayDetailsResponse!.data!.fats!.caloriesTotal!.taken.toString()))>=-25){
      dayDetailsResponse!.data!.fats!.caloriesTotal!.progress!.bg = '7fc902';
    }
  }


  void updateWaterData(String water) async {

    final result = await Connectivity().checkConnectivity();
    if (false) {

    }else{
      // await _diaryRepository
      //     .createDiaryData(water: water, date: apiDate.value);
// Fluttertoast.showToast(msg: "${value.message}");
      dayDetailsResponse!.data!.water = int.parse(water);
      length.value = dayDetailsResponse!.data!.water! + 3;
      waterBottlesList.clear();
      for (int i = 1; i <= length.value; i++) {
        if (i <= dayDetailsResponse!.data!.water!) {
          waterBottlesList.add(
            SingleImageItem(
                id: i,
                imagePath: 'assets/img/im_holder1.png',
                selected: true),
          );
        } else {
          waterBottlesList.add(
            SingleImageItem(
                id: i,
                imagePath: 'assets/img/im_holder1.png',
                selected: false),
          );
        }
      }

      isLoading.value = false;
      showLoader.value = false;
      showLoader.value = false;
      emit(DiaryLoaded());

      print("error");

      await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, apiDate.value);
      await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
      // refreshDiaryData(apiDate.value, 'proteins');
    }


  }

  final workoutLoading = false.obs;

  void updateWork() async {
    final result = await Connectivity().checkConnectivity();
    if (true) {
      await _diaryRepository
          .createDiaryData(
        workOut: workOut.value,
        workoutDesc: workDesc,
        date: apiDate.value,
      );
      Fluttertoast.showToast(msg: "Saved successfully");

      dayDetailsResponse!.data!.dayWorkouts = DayWorkouts(
          workoutType: workOutData.value,
          workoutDesc: workDesc
      );

      await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, apiDate.value);
      await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
      refreshDiaryData(apiDate.value, "carbs");

    }else {
      // workoutLoading.value = true;
      // await _diaryRepository
      //     .createDiaryData(
      //   workOut: workOut.value,
      //   workout_desc: workDesc,
      //   date: apiDate.value,
      // ).then((value) {
      //   if (value.success == true) {
      //     workoutLoading.value = false;
      //     Fluttertoast.showToast(msg: "${value.message}");
      //   } else {
      //     workoutLoading.value = false;
      //     Fluttertoast.showToast(msg: "Server Error");
      //     Echo("error");
      //   }
      // });
    }
  }

  void downloadFile(BuildContext context,String url) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PDFPreview(res: "$url", name: "Calories Calculator")));
  }

  void showPobUp(BuildContext context,String text) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0)),
                height: deviceHeight / 1.5,
                padding: EdgeInsets.only(top: 8, left: 4, right: 4),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        "${text}",
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )),
          );
        });
  }

  void launchURL(_url) async => await launch(_url);

  void createProtineData(Food? food, double _quantity,
      {int? index, required String type}) async {
    // if (type == 'proteins') refreshLoadingProtine.value = true;
    // if (type == 'carbs') refreshLoadingCarbs.value = true;
    // if (type == 'fats') refreshLoadingFats.value = true;

    final result = await Connectivity().checkConnectivity();
    DateTime formattedTime = getEgyptTime();

    if (false) {
      isAdding = true;
      if (type == 'proteins'){
        // dayDetailsResponse!.data!.proteins!.caloriesTotal!.taken = double.parse(dayDetailsResponse!.data!.proteins!.caloriesTotal!.taken.toString())+(dayDetailsResponse!.data!.proteins!.food!.firstWhere((element) => element.id==food.id).caloriePerUnit! *_quantity);

        dayDetailsResponse!.data!.proteins!
            .caloriesDetails!.add(CaloriesDetails(
            qty: _quantity,
            quality: food!.title,
            color: food.color,
            calories: food.caloriePerUnit * _quantity,
            unit: food.unit
        ));

        await calculateProteins();
        await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
        // refreshDiaryData(apiDate.value, type);
      }
      if (type == 'carbs'){
        // dayDetailsResponse!.data!.carbs!.caloriesTotal!.taken = double.parse(dayDetailsResponse!.data!.carbs!.caloriesTotal!.taken.toString())+(dayDetailsResponse!.data!.carbs!.food!.firstWhere((element) => element.id==food.id).caloriePerUnit! *_quantity);

        dayDetailsResponse!.data!.carbs!
            .caloriesDetails!.add(CaloriesDetails(
            qty: _quantity,
            quality: food!.title,
            color: food.color,
            calories: food.caloriePerUnit * _quantity,unit: food!.unit));

        await calculateCarbs();

        await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
        // refreshDiaryData(apiDate.value, type);
      }else
      if (type == 'fats'){
        // dayDetailsResponse!.data!.fats!.caloriesTotal!.taken = double.parse(dayDetailsResponse!.data!.fats!.caloriesTotal!.taken.toString())+(dayDetailsResponse!.data!.fats!.food!.firstWhere((element) => element.id==food.id).caloriePerUnit! *_quantity);

        dayDetailsResponse!.data!.fats!
            .caloriesDetails!.add(CaloriesDetails(
            qty: _quantity,quality: food!.title,
            color: food.color,
            calories: food.caloriePerUnit * _quantity,unit: food!.unit));


        await calculateFats();

        await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
        // refreshDiaryData(apiDate.value, type);
      }
      // caloriesDetails.refresh();
      // carbsDetails.refresh();
      // fatsDetails.refresh();
      // caloriesDetails.forEach((element) {
      //   print(element.quality.toString() + element.qty.toString());
      // });
      // carbsDetails.forEach((element) {
      //   print(element.quality.toString() + element.qty.toString());
      // });
      // carbsDetails.forEach((element) {
      //   print(element.quality.toString() + element.qty.toString());
      //
      // });
      // fatsDetails.forEach((element) {
      //   print(element.quality.toString() + element.qty.toString());
      //
      // });
      if (type == 'proteins') refreshLoadingProtine.value = false;
      if (type == 'carbs') refreshLoadingCarbs.value = false;
      if (type == 'fats') refreshLoadingFats.value = false;

      await _diaryRepository.createDiaryData(
          foodProtine: food!.id, qtyProtiene: _quantity, date: apiDate.value);
      isAdding = false;

      // await checkDeletion();

      refreshDiaryData(apiDate.value, type);

    }else{
      int randomId =int.parse('${food!.id}${Random().nextInt(100).toString().padLeft(2,'0')}');
      await _diaryRepository.createDiaryData(
          randomId: randomId,
          foodProtine: food.id,
          foodName:food.title,
          caloriesPerUnit:food.caloriePerUnit,
          qtyProtiene: _quantity, date: apiDate.value);
      if (type == 'proteins'){
        // dayDetailsResponse!.data!.proteins!.caloriesTotal!.taken = double.parse(dayDetailsResponse!.data!.proteins!.caloriesTotal!.taken.toString())+(dayDetailsResponse!.data!.proteins!.food!.firstWhere((element) => element.id==food.id).caloriePerUnit! *_quantity);

        dayDetailsResponse!.data!.proteins!
            .caloriesDetails!.add(CaloriesDetails(
            randomId: randomId,
            qty: _quantity,
            quality: food.title,
            color: food.color,
            createdAt: DateFormat('yyyy-MM-dd HH:mm').format(formattedTime),
            calories: (food.caloriePerUnit * _quantity).toStringAsFixed(2),
            unit: food.unit
        ));
        await calculateProteins();

        print('After Calc');
        await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
        await _diaryRepository. saveDairyToSendLocally(dayDetailsResponse!, apiDate.value);
        refreshDiaryData(apiDate.value, type);
      }
      if (type == 'carbs'){
        // dayDetailsResponse!.data!.carbs!.caloriesTotal!.taken = double.parse(dayDetailsResponse!.data!.carbs!.caloriesTotal!.taken.toString())+(dayDetailsResponse!.data!.carbs!.food!.firstWhere((element) => element.id==food.id).caloriePerUnit! *_quantity);

        dayDetailsResponse!.data!.carbs!
            .caloriesDetails!.add(CaloriesDetails(
            randomId: randomId,
            qty: _quantity,quality: food!.title,
            color: food.color,
            calories: (food.caloriePerUnit * _quantity).toStringAsFixed(2),
            createdAt: DateFormat('yyyy-MM-dd HH:mm').format(formattedTime),
            unit: food!.unit));

        await calculateCarbs();

        await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, apiDate.value);
        await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
        refreshDiaryData(apiDate.value, type);
      }else
      if (type == 'fats'){
        // dayDetailsResponse!.data!.fats!.caloriesTotal!.taken = double.parse(dayDetailsResponse!.data!.fats!.caloriesTotal!.taken.toString())+(dayDetailsResponse!.data!.fats!.food!.firstWhere((element) => element.id==food.id).caloriePerUnit! *_quantity);

        dayDetailsResponse!.data!.fats!
            .caloriesDetails!.add(CaloriesDetails(
            randomId: randomId,
            qty: _quantity,quality: food!.title,
            color: food.color,
            createdAt: DateFormat('yyyy-MM-dd HH:mm').format(formattedTime),
            calories: (food.caloriePerUnit * _quantity).toStringAsFixed(2),
            unit: food!.unit));


        await calculateFats();

        await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, apiDate.value);
        await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
        refreshDiaryData(apiDate.value, type);
      }
      emit(DiaryLoaded());
      if (type == 'proteins') refreshLoadingProtine.value = false;
      if (type == 'carbs') refreshLoadingCarbs.value = false;
      if (type == 'fats') refreshLoadingFats.value = false;
    }
  }

  updateDiaryDataLocally(int randomId,Food? food, double _quantity,
      {int? index, required String type})async{
    print("randomId");

    await _diaryRepository.saveDiaryDataLocally(
      DiaryData(
        date: apiDate.value,
        foodProtine: food!.id,
        qtyProtiene: _quantity,
        randomId: randomId,
      )
    );
  }

  void updateProtineData(
      int? index,
      Food? food,
      double _quantity,
      {required String type}) async {
    DateTime formattedTime = getEgyptTime();

    // if (type == 'proteins') refreshLoadingProtine.value = true;
    // if (type == 'carbs') refreshLoadingCarbs.value = true;
    // if (type == 'fats') refreshLoadingFats.value = true;


    final result = await Connectivity().checkConnectivity();
    if (false) {
      // if (type == 'proteins'){
      //
      //   dayDetailsResponse!.data!.proteins!
      //       .caloriesDetails![dayDetailsResponse!.data!.proteins!
      //       .caloriesDetails!.indexWhere((element) => element.id == index)] = CaloriesDetails(
      //       id: index,
      //       qty: _quantity,quality: food!.title,
      //       color: food.color,
      //       calories: food.caloriePerUnit * _quantity,unit: food.unit);
      //
      //   await calculateProteins();
      //
      //   await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
      //   // refreshDiaryData(apiDate.value, type);
      // }
      // if (type == 'carbs'){
      //
      //   dayDetailsResponse!.data!.carbs!
      //       .caloriesDetails![dayDetailsResponse!.data!.carbs!
      //       .caloriesDetails!.indexWhere((element) => element.id == index)] = CaloriesDetails(
      //       id: index,
      //       qty: _quantity,quality: food!.title,
      //       color: food.color,
      //       calories: food.caloriePerUnit * _quantity,unit: food!.unit);
      //
      //
      //   await calculateCarbs();
      //
      //   await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
      //   // refreshDiaryData(apiDate.value, type);
      // }else
      // if (type == 'fats'){
      //
      //   dayDetailsResponse!.data!.fats!
      //       .caloriesDetails![dayDetailsResponse!.data!.fats!
      //       .caloriesDetails!.indexWhere((element) => element.id == index)] = CaloriesDetails(
      //       id: index,
      //       qty: _quantity,quality: food!.title,
      //       color: food.color,
      //       calories: food.caloriePerUnit * _quantity,unit: food!.unit);
      //
      //
      //   await calculateFats();
      //
      //   await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
      //   // refreshDiaryData(apiDate.value, type);
      // }
      // caloriesDetails.refresh();
      // carbsDetails.refresh();
      // fatsDetails.refresh();
      //
      // if (type == 'proteins') refreshLoadingProtine.value = false;
      // if (type == 'carbs') refreshLoadingCarbs.value = false;
      // if (type == 'fats') refreshLoadingFats.value = false;
      //
      // await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
      //
      // // refreshDiaryData(apiDate.value, type);
      // await _diaryRepository.editDiaryData(
      //     foodProtine: food!.id,
      //     qtyProtiene: _quantity,
      //     date: apiDate.value,
      //     id: index);
      // refreshDiaryData(apiDate.value, type);
    }else{
      // await _diaryRepository.editDiaryData(
      //     foodProtine: food!.id,
      //     qtyProtiene: _quantity,
      //     date: apiDate.value,
      //     id: index);

      if (type == 'proteins'){

        dayDetailsResponse!.data!.proteins!
            .caloriesDetails![dayDetailsResponse!.data!.proteins!
            .caloriesDetails!.indexWhere((element) => element.id == index)] = CaloriesDetails(
            id: index,
            qty: _quantity,quality: food!.title,
            color: food.color,
            calories: (food.caloriePerUnit * _quantity).toStringAsFixed(2),
            createdAt: DateFormat('yyyy-MM-dd HH:mm').format(formattedTime),
            unit: food!.unit);

        await calculateProteins();
        await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, apiDate.value);
        await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
        refreshDiaryData(apiDate.value, type);
      }
      if (type == 'carbs'){

        dayDetailsResponse!.data!.carbs!
            .caloriesDetails![dayDetailsResponse!.data!.carbs!
            .caloriesDetails!.indexWhere((element) => element.id == index)] = CaloriesDetails(
            id: index,
            qty: _quantity,quality: food!.title,
            color: food.color,
            calories: (food.caloriePerUnit * _quantity).toStringAsFixed(2),
            createdAt: getEgyptTime().toString().substring(0,16),
            unit: food!.unit);


        await calculateCarbs();
        await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, apiDate.value);
        await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
        refreshDiaryData(apiDate.value, type);
      }
      if (type == 'fats'){

        dayDetailsResponse!.data!.fats!
            .caloriesDetails![dayDetailsResponse!.data!.fats!
            .caloriesDetails!.indexWhere((element) => element.id == index)] = CaloriesDetails(
            id: index,
            qty: _quantity,quality: food!.title,
            color: food.color,
            calories: (food.caloriePerUnit * _quantity).toStringAsFixed(2),
            createdAt: DateFormat('yyyy-MM-dd HH:mm').format(formattedTime),
            unit: food!.unit);


        await calculateFats();
        await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, apiDate.value);
        await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
        refreshDiaryData(apiDate.value, type);
      }
      emit(DiaryLoaded());

      if (type == 'proteins') refreshLoadingProtine.value = false;
      if (type == 'carbs') refreshLoadingCarbs.value = false;
      if (type == 'fats') refreshLoadingFats.value = false;

    }

  }

  void updateProtineDataRandomId(
      int? randomId,
      int? index,
      Food? food,
      double _quantity,
      {required String type}) async {
    // if (type == 'proteins') refreshLoadingProtine.value = true;
    // if (type == 'carbs') refreshLoadingCarbs.value = true;
    // if (type == 'fats') refreshLoadingFats.value = true;


    final result = await Connectivity().checkConnectivity();
    if (false) {
      // if (type == 'proteins'){
      //
      //   dayDetailsResponse!.data!.proteins!
      //       .caloriesDetails![dayDetailsResponse!.data!.proteins!
      //       .caloriesDetails!.indexWhere((element) => element.id == index)] = CaloriesDetails(
      //       id: index,
      //       qty: _quantity,quality: food!.title,
      //       color: food.color,
      //       calories: food.caloriePerUnit * _quantity,unit: food.unit);
      //
      //   await calculateProteins();
      //
      //   await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
      //   // refreshDiaryData(apiDate.value, type);
      // }
      // if (type == 'carbs'){
      //
      //   dayDetailsResponse!.data!.carbs!
      //       .caloriesDetails![dayDetailsResponse!.data!.carbs!
      //       .caloriesDetails!.indexWhere((element) => element.id == index)] = CaloriesDetails(
      //       id: index,
      //       qty: _quantity,quality: food!.title,
      //       color: food.color,
      //       calories: food.caloriePerUnit * _quantity,unit: food!.unit);
      //
      //
      //   await calculateCarbs();
      //
      //   await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
      //   // refreshDiaryData(apiDate.value, type);
      // }else
      // if (type == 'fats'){
      //
      //   dayDetailsResponse!.data!.fats!
      //       .caloriesDetails![dayDetailsResponse!.data!.fats!
      //       .caloriesDetails!.indexWhere((element) => element.id == index)] = CaloriesDetails(
      //       id: index,
      //       qty: _quantity,quality: food!.title,
      //       color: food.color,
      //       calories: food.caloriePerUnit * _quantity,unit: food!.unit);
      //
      //
      //   await calculateFats();
      //
      //   await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
      //   // refreshDiaryData(apiDate.value, type);
      // }
      // caloriesDetails.refresh();
      // carbsDetails.refresh();
      // fatsDetails.refresh();
      //
      // if (type == 'proteins') refreshLoadingProtine.value = false;
      // if (type == 'carbs') refreshLoadingCarbs.value = false;
      // if (type == 'fats') refreshLoadingFats.value = false;
      //
      // await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
      //
      // // refreshDiaryData(apiDate.value, type);
      // await _diaryRepository.editDiaryData(
      //     foodProtine: food!.id,
      //     qtyProtiene: _quantity,
      //     date: apiDate.value,
      //     id: index);
      // refreshDiaryData(apiDate.value, type);
    }else{
      // await _diaryRepository.editDiaryData(
      //     foodProtine: food!.id,
      //     qtyProtiene: _quantity,
      //     date: apiDate.value,
      //     id: index);

      if (type == 'proteins'){


        dayDetailsResponse!.data!.proteins!
            .caloriesDetails![dayDetailsResponse!.data!.proteins!
            .caloriesDetails!.indexWhere((element) => element.id == index && element.randomId == randomId)] = CaloriesDetails(
            id: index,
            qty: _quantity,quality: food!.title,
            color: food.color,
            randomId: randomId,
            calories: (food.caloriePerUnit * _quantity).toStringAsFixed(2),
            unit: food.unit);

        await calculateProteins();
        await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, apiDate.value);
        await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
        refreshDiaryData(apiDate.value, type);
      }
      if (type == 'carbs'){

        if(randomId!=null) {

          dayDetailsResponse!.data!.carbs!
              .caloriesDetails![dayDetailsResponse!.data!.carbs!
              .caloriesDetails!.indexWhere((element) =>
          element.id == index && element.randomId == randomId)]
          = CaloriesDetails(
              id: index,
              qty: _quantity,
              quality: food!.title,
              color: food.color,
              calories: (food.caloriePerUnit * _quantity).toStringAsFixed(2),
              randomId: randomId,
              unit: food.unit);
        }else{
          dayDetailsResponse!.data!.carbs!
              .caloriesDetails!.forEach((element) {
            print(element.randomId);
          });
          print(dayDetailsResponse!.data!.carbs!
              .caloriesDetails![dayDetailsResponse!.data!.carbs!
              .caloriesDetails!.indexWhere((element) =>
          element.id == index)].quality);
          dayDetailsResponse!.data!.carbs!
              .caloriesDetails![dayDetailsResponse!.data!.carbs!
              .caloriesDetails!.indexWhere((element) =>
          element.id == index)]
          = CaloriesDetails(
              id: index,
              qty: _quantity,
              quality: food!.title,
              color: food.color,
              calories: (food.caloriePerUnit * _quantity).toStringAsFixed(2),
              unit: food.unit);
        }


        await calculateCarbs();
        await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, apiDate.value);
        await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
        refreshDiaryData(apiDate.value, type);
      }
      if (type == 'fats'){

        dayDetailsResponse!.data!.fats!
            .caloriesDetails![dayDetailsResponse!.data!.fats!
            .caloriesDetails!.indexWhere((element) => element.id == index&& element.randomId == randomId)] = CaloriesDetails(
            id: index,
            randomId: randomId,
            qty: _quantity,quality: food!.title,
            color: food.color,
            calories: (food.caloriePerUnit * _quantity).toStringAsFixed(2),
            unit: food!.unit);


        await calculateFats();
        await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, apiDate.value);
        await _diaryRepository.saveDairyLocally(dayDetailsResponse!, apiDate.value);
        refreshDiaryData(apiDate.value, type);
      }
      emit(DiaryLoaded());

      if (type == 'proteins') refreshLoadingProtine.value = false;
      if (type == 'carbs') refreshLoadingCarbs.value = false;
      if (type == 'fats') refreshLoadingFats.value = false;

    }

  }


  DateTime getEgyptTime(){
    final egyptTimeZone = tz.getLocation('Africa/Cairo');
    final nowInEgypt = tz.TZDateTime.now(egyptTimeZone);
    final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(nowInEgypt);

    return DateTime.parse(formattedTime);

  }

  Color getColor(String title) {
    if (title == 'أنتويرب') return Colors.red;
    if (title == 'خقخل') return Colors.red;

    return Colors.black87;
  }

  void refreshCaloriesList(List<CaloriesDetails> list) {
    List<CaloriesDetails> emptyList = [];
    emptyList.addAll(
        caloriesDetails.where((element) => element.qty == null).toList());

    caloriesDetails.clear();
    caloriesDetails.addAll(list);
    caloriesDetails.addAll(emptyList);
    return;
    list.forEach((resItem) {
      if (caloriesDetails.where((item) {
        return item.quality == resItem.quality && item.qty == resItem.qty;
      }).length >
          0) {
        caloriesDetails.forEach((item) {
          if (item.quality == resItem.quality && item.qty == resItem.qty) {
            item.id = resItem.id;
            item.calories = resItem.calories;
            item.unit = resItem.unit;
          }
        });
      } else {
        caloriesDetails.add(resItem);
      }
    });
  }

  void refreshCarbsList(List<CaloriesDetails> list) {
    List<CaloriesDetails> emptyList = [];
    emptyList
        .addAll(carbsDetails.where((element) => element.qty == null).toList());
    carbsDetails.clear();
    carbsDetails.addAll(list);
    carbsDetails.addAll(emptyList);
    return;
    list.forEach((resItem) {
      if (carbsDetails.where((item) {
        return item.quality == resItem.quality && item.qty == resItem.qty;
      }).length >
          0) {
        carbsDetails
          ..forEach((item) {
            if (item.quality == resItem.quality && item.qty == resItem.qty) {
              item.id = resItem.id;
              item.calories = resItem.calories;
              item.unit = resItem.unit;
            }
          });
      } else {
        carbsDetails..add(resItem);
      }
    });
  }

  void refreshFatsList(List<CaloriesDetails> list) {
    List<CaloriesDetails> emptyList = [];
    emptyList
        .addAll(fatsDetails.where((element) => element.qty == null).toList());
    fatsDetails.clear();
    fatsDetails.addAll(list);
    fatsDetails.addAll(emptyList);
    return;
    list.forEach((resItem) {
      if (fatsDetails.where((item) {
        return item.quality == resItem.quality && item.qty == resItem.qty;
      }).length >
          0) {
        fatsDetails
          ..forEach((item) {
            if (item.quality == resItem.quality && item.qty == resItem.qty) {
              item.id = resItem.id;
              item.calories = resItem.calories;
              item.unit = resItem.unit;
            }
          });
      } else {
        fatsDetails..add(resItem);
      }
    });
  }


}


class SingleImageItem {
  int id;
  String imagePath;
  bool selected;

  SingleImageItem(
      {required this.id, required this.imagePath, required this.selected});
}

