
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
import '../../other_calories/repositories/other_calories_repository.dart';
import '../../pdf_viewr.dart';
import '../../timeSleep/cubits/time_sleep_cubit.dart';
import '../../usuals/repositories/usual_repository.dart';
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
  final UsualRepository _usualRepository;

  DiaryCubit(this._diaryRepository,this._timeSleepCubit,this._otherCaloriesRepository,this._usualRepository) : super(DiaryInitial());
  static const String lastBackgroundTimeKey = "LAST_BACKGROUND_TIME";
  bool isOnInit = false;

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
  // List<CaloriesDetails> caloriesDetails = [];
  // List<CaloriesDetails> carbsDetails = [];
  // List<CaloriesDetails> fatsDetails = [];

  List<CaloriesDetails> caloriesDeleted = [];
  List<CaloriesDetails> carbsDeleted = [];
  List<CaloriesDetails> fatsDeleted = [];
  MyOtherCaloriesResponse otherCaloriesResponse = MyOtherCaloriesResponse();
  MyOtherCaloriesUnitsResponse myOtherCaloriesUnitsResponse = MyOtherCaloriesUnitsResponse();
  double waterSheetVal = 0;

  DayDetailsResponse? dayDetailsResponse;
  FocusNode workoutTitleDescFocus = FocusNode();
  final isLoading = true.obs;
  final refreshLoadingProtine = false.obs;
  final refreshLoadingCarbs = false.obs;
  final refreshLoadingFats = false.obs;
  String chosenDay = 'today';
  final noSessions = false.obs;
  final showLoader = false.obs;
  final lastSelectedDate = ''.obs;
  final date = ''.obs;
  // final apiDate = ''.obs;
  final workOutData = ''.obs;
  final qtyProtine = ''.obs;
  final foodProtine = ''.obs;
  String? workDesc;
  String? clinicDesc;
  final length = 0.obs;
  final workOut = 0.obs;
  bool isAdding = false;
  bool _isSwitching = false;

  changeWaterSheetVal(double valWater){
    waterSheetVal = valWater;
    emit(DiaryLoaded());
  }

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



  /// Start
  ///
  onInit() async {
    final connectivityStatus = await Connectivity().checkConnectivity();

    if (connectivityStatus != ConnectivityResult.none) {
      print("isOnInit$isOnInit");
      if (!isOnInit) {
        isOnInit = true;
        isSending = true;
        isLoading.value = true;
        emit(DiaryLoading());
        // Set the default date if none is selected
        if (lastSelectedDate.value == '') {
          lastSelectedDate.value = getEgyptTime().toString().substring(0, 10);
        }

        // Perform asynchronous tasks sequentially
        await _initializeAppData();
        await _syncOfflineData();
        await _loadDiaryData();
        isOnInit = false;
      }
    }else{
      await _loadDiaryData();
    }
  }

// Split initialization logic
  Future<void> _initializeAppData() async {
    getNotifications();  // Assuming this is quick
    await getFromCash();
  }

// Centralized sync for offline data
  Future<void> _syncOfflineData() async {
    final connectivityStatus = await Connectivity().checkConnectivity();

    if (connectivityStatus != ConnectivityResult.none) {
      isLoading.value = true;
      emit(DiaryLoading());

      // Sync various cached data
      await fetchOtherCalories().then((value) async{
        await _otherCaloriesRepository.createOtherCaloriesData(otherCaloriesResponse);
      });

      await _diaryRepository.sendSavedDiaryDataByDay();
      await _timeSleepCubit.sendSavedSleepTimes();
      await _usualRepository.sendLocallySavedUsualMeals();

      // Refresh diary data after sync
      isSending = false;
      // await getDiaryData(lastSelectedDate.value != ''
      //     ? lastSelectedDate.value
      //     : getEgyptTime().toString().substring(0, 10), isSending,refresh: false);

    }
  }

// Load the diary data (online/offline)
  Future<void> _loadDiaryData() async {
    await getDiaryData(
        lastSelectedDate.value != ''
            ? lastSelectedDate.value
            : getEgyptTime().toString().substring(0, 10),
        isSending
    );
    clinicDesc = dayDetailsResponse?.data?.dayClinicNote ;
    workDesc = dayDetailsResponse?.data?.dayWorkouts?.workoutDesc;
  }

// Example function to handle diary data retrieval (getDiaryData)
  Future getDiaryData(String _date, bool isSending, {bool reset = true,bool refresh = true}) async {
    print("Fetching diary for date: $_date");


    // if (dayDetailsResponse?.data != null && isLoading.value) return;

    lastSelectedDate.value = _date;
    isLoading.value = true;
    emit(DiaryLoading());

    // Fetch data from the repository
    final result = await _diaryRepository.getDiaryView(_date, !isSending, false, true);

    result.fold(
            (failure) => emit(DiaryFailure(failure)),
            (value) {
          if (value.data != null) {
            dayDetailsResponse = value;

            clinicDesc = dayDetailsResponse?.data?.dayClinicNote ;
            workDesc = dayDetailsResponse?.data?.dayWorkouts?.workoutDesc;
            if(refresh)
            _handleSuccessfulDiaryData(reset);
          } else {
            print("Error: no data returned.");
            emit(DiaryFailure(Failure(500,'"No data available"')));
          }
        }
    );
  }

// Handle successful diary data retrieval
  void _handleSuccessfulDiaryData(bool reset) async{
    isLoading.value = false;
    showLoader.value = false;

    if (reset) emit(DiaryLoaded());

    // length.value = dayDetailsResponse!.data!.water! + 3;
    // ... (additional handling code)

    // refreshCaloriesList(dayDetailsResponse!.data!.proteins!.caloriesDetails ?? []);
    // refreshCarbsList(dayDetailsResponse!.data!.carbs!.caloriesDetails ?? []);
    // refreshFatsList(dayDetailsResponse!.data!.fats!.caloriesDetails ?? []);
  }

  /// End



  sendAndRefresh()async{
    isLoading.value = true;
    emit(DiaryLoading());
    await sendSavedDiaryDataByDay();

    await sendSavedSleepTimes();

    refreshDiaryDataLive(
        lastSelectedDate.value);
  }

  Future<void> loadData() async {
    emit(DiaryLoading());

    try {
      DateTime? lastLoadTime = await _diaryRepository.getLastLoadingTime();
      final result = await Connectivity().checkConnectivity();

      if (result != ConnectivityResult.none) {
        if (lastLoadTime == null || lastLoadTime.isBefore(getEgyptTime().subtract(Duration(hours: 6)))) {
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
      await fetchOtherCalories().then((value) async{
        await _otherCaloriesRepository.createOtherCaloriesData(otherCaloriesResponse);
      });
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
    if (state is! DiaryLoading) {
      emit(DiaryLoading());

    }

    await _diaryRepository.sendSavedDiaryDataByDay();

  }
  Future sendSavedSleepTimes()async{
    if (state is! DiaryLoading) {
      emit(DiaryLoading());
      isLoading.value = true;

    }
    await _timeSleepCubit.sendSavedSleepTimes();

  }



  String _timezone = 'Unknown';
  List<String> _availableTimezones = <String>[];

  final isLogged = false.obs;

  Future getFromCash() async {
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
      // final result = await Connectivity().checkConnectivity();
      // if (result == ConnectivityResult.none){
      //   getDiaryData(getEgyptTime().toString().substring(0, 10),isSending,reset: false);
      //
      // }
    }
  }

  void getDiaryDataRefreshResponse(String _date) async {
    if(chosenDay=='today'){
      _diaryRepository.getDiaryView(dayDetailsResponse!.data!.days![1].date!.toString(),!isSending,false,true);
    }else{
      _diaryRepository.getDiaryView(dayDetailsResponse!.data!.days![0].date!.toString(),!isSending,false,true);
    }
  }



  addNewRow(String type){
    if (type == 'Proteins') {
      dayDetailsResponse!.data!.proteins!.caloriesDetails!.add(CaloriesDetails());
      // diaryCubit.caloriesDetails.add(CaloriesDetails());
    } else if (type == 'Carbs') {
      dayDetailsResponse!.data!.carbs!.caloriesDetails!.add(CaloriesDetails());

      // carbsDetails.add(CaloriesDetails());
    } else {
      dayDetailsResponse!.data!.fats!.caloriesDetails!.add(CaloriesDetails());
      // fatsDetails.add(CaloriesDetails());
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
      await _diaryRepository.saveDairyLocally(dayDetailsResponse, date);
      // emit(DiaryLoaded());
    } catch (e) {
      emit(DiaryError(e.toString()));
    }
  }



  Future<void> refreshDiaryData(String date, String type) async {
    emit(DiaryLoading());


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
        if (      dayDetailsResponse!.data!.proteins!.caloriesDetails!

            .where((element2) => element.id == element2.id &&element.randomId == element2.randomId)
            .toList()
            .length >
            0) {

          dayDetailsResponse!.data!.proteins!.caloriesDetails!.forEach((item) {
            if (item.id == element.id  && element.randomId == item.randomId) {
              item.quality = element.quality;
              item.qty = element.qty;
              item.calories = element.calories;
            }
          });
        } else {
          // refreshCaloriesList(
          //     dayDetailsResponse!.data!.proteins!.caloriesDetails ?? []);
        }
      });

    }
    if (data.data!.carbs!.caloriesDetails!.isNotEmpty) {
      // Update carbs list
      data.data!.carbs!.caloriesDetails!.forEach((element) {
        if (dayDetailsResponse!.data!.carbs!.caloriesDetails!
            .where((element2) => element.id == element2.id &&element.randomId == element2.randomId)
            .toList()
            .length >
            0) {


          dayDetailsResponse!.data!.carbs!.caloriesDetails!.forEach((item) {
            if (item.id == element.id && element.randomId == item.randomId) {

              item.quality = element.quality;
              item.qty = element.qty;
              item.calories = element.calories;
            }
          });
        } else {
          // refreshCarbsList(dayDetailsResponse!.data!.carbs!.caloriesDetails ?? []);
        }
      });

    }
    if (data.data!.fats!.caloriesDetails!.isNotEmpty) {
      // Update fats list
      dayDetailsResponse!.data!.fats!.caloriesDetails!.forEach((element) {
        if (dayDetailsResponse!.data!.fats!.caloriesDetails!
            .where((element2) => element.id == element2.id &&element.randomId == element2.randomId)
            .toList()
            .length >
            0) {
          dayDetailsResponse!.data!.fats!.caloriesDetails!.forEach((item) {
            if (item.id == element.id  && element.randomId == item.randomId) {
              item.quality = element.quality;
              item.qty = element.qty;
              item.calories = element.calories;
            }
          });
        } else {
          // refreshFatsList(dayDetailsResponse!.data!.fats!.caloriesDetails ?? []);
        }
      });

    }
  }


  Future refreshDiaryDataLive(String _date) async {

    lastSelectedDate.value = _date;
    if (state is! DiaryLoading) {
      emit(DiaryLoading());
    }

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
        // return;
      } else {
        // caloriesDetails.removeWhere((element) => element.id == null);
        // carbsAndFats.removeWhere((element) => element.id == null);
        dayDetailsResponse!.data!.proteins!.caloriesDetails!.forEach((element) {
          if (dayDetailsResponse!.data!.proteins!.caloriesDetails!
              .where((element2) =>
          element.id == element2.id && element.randomId == element2.randomId)
              .toList()
              .length >
              0) {
            dayDetailsResponse!.data!.proteins!.caloriesDetails!.forEach((item) {
              if (item.id == element.id && element.randomId == item.randomId) {
                item.quality = element.quality;
                item.qty = element.qty;
                item.calories = element.calories;
              }
            });
          } else {
            // refreshCaloriesList(
            //     dayDetailsResponse!.data!.proteins!.caloriesDetails ?? []);
          }
        });
        dayDetailsResponse!.data!.carbs!.caloriesDetails!.forEach((element) {
          if (dayDetailsResponse!.data!.carbs!.caloriesDetails!
              .where((element2) =>
          element.id == element2.id && element.randomId == element2.randomId)
              .toList()
              .length >
              0) {
            dayDetailsResponse!.data!.carbs!.caloriesDetails!.forEach((item) {
              if (item.id == element.id && element.randomId == item.randomId) {
                item.quality = element.quality;
                item.qty = element.qty;
                item.calories = element.calories;
              }
            });
          } else {
            // refreshCarbsList(dayDetailsResponse!.data!.carbs!.caloriesDetails ?? []);
          }
        });

        dayDetailsResponse!.data!.fats!.caloriesDetails!.forEach((element) {
          if (dayDetailsResponse!.data!.fats!.caloriesDetails!
              .where((element2) =>
          element.id == element2.id && element.randomId == element2.randomId)
              .toList()
              .length >
              0) {
            dayDetailsResponse!.data!.fats!.caloriesDetails!.forEach((item) {
              if (item.id == element.id && element.randomId == item.randomId) {
                item.quality = element.quality;
                item.qty = element.qty;
                item.calories = element.calories;
              }
            });
          } else {
            // refreshFatsList(
            //     dayDetailsResponse!.data!.fats!.caloriesDetails ?? []);
          }
        });
      }

      clinicDesc = dayDetailsResponse?.data?.dayClinicNote??dayDetailsResponse?.data?.clinicNote ;
      workDesc = dayDetailsResponse?.data?.dayWorkouts?.workoutDesc;
      emit(DiaryLoaded());
      isLoading.value = false;

    });


  }
  Future<void> deleteItem({
    required int? id,
    required int? randomId,
    required String? quality,
    required String date,
    required String type,
    bool isCached = false,
  }) async {

    // Determine which list to update based on type
    var detailsList;
    switch (type) {
      case 'proteins':
        detailsList = dayDetailsResponse!.data!.proteins!.caloriesDetails!;
        break;
      case 'carbs':
        detailsList = dayDetailsResponse!.data!.carbs!.caloriesDetails!;
        break;
      case 'fats':
        detailsList = dayDetailsResponse!.data!.fats!.caloriesDetails!;
        break;
      default:
        throw Exception('Unknown type: $type');
    }

    // Remove item based on id or randomId
    if (isCached && randomId != null) {
      detailsList.removeWhere((element) => element.randomId == randomId && element.quality==quality);
    } if (isCached && randomId == null) {
      detailsList.removeWhere((element) => element.randomId == randomId);
    } else if (!isCached && id != null) {
      detailsList.removeWhere((element) => element.id == id && element.quality==quality);
    } else if (!isCached && id == null&& randomId == null) {
      detailsList.removeWhere((element) => element.id == id && element.randomId == randomId);
    }

    // Recalculate the values for the specified nutrient
    switch (type) {
      case 'proteins':
        dayDetailsResponse!.data!.proteins!.caloriesDetails = detailsList;
        await calculateProteins();
        break;
      case 'carbs':
        dayDetailsResponse!.data!.carbs!.caloriesDetails = detailsList;
        await calculateCarbs();
        break;
      case 'fats':
        dayDetailsResponse!.data!.fats!.caloriesDetails = detailsList;
        await calculateFats();
        break;
    }

    // Save updated data locally
    await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, lastSelectedDate.value);
    await _diaryRepository.saveDairyLocally(dayDetailsResponse!, lastSelectedDate.value);

    emit(DiaryLoaded());
  }

  Future<void> switchDay(String day) async {
    chosenDay = day;
    emit(DiaryLoading());

    final result = await Connectivity().checkConnectivity();
    final selectedDate = getDateForDay(day);
    lastSelectedDate.value = selectedDate;
    if (result != ConnectivityResult.none) {

      // await getDiaryData(selectedDate, isSending);
      // await sendSavedSleepTimes();
      // await sendSavedDiaryDataByDay();
      onInit();
      // await refreshDiaryDataLive(selectedDate);
    } else {
      await getDiaryData(selectedDate, false);
      emit(DiaryLoaded());
    }
  }

  // Future<void> switchDay(String day) async {
  //   if (_isSwitching) {
  //     return;
  //   }
  //
  //   // if (_isSwitching) return; // Prevent additional calls until the current one completes
  //   _isSwitching = true;
  //
  //   chosenDay = day;
  //   emit(DiaryLoading());
  //
  //   final result = await Connectivity().checkConnectivity();
  //   final selectedDate = getDateForDay(day);
  //
  //   try {
  //     if (result != ConnectivityResult.none) {
  //       await getDiaryData(selectedDate, isSending);
  //       await sendSavedSleepTimes();
  //       await sendSavedDiaryDataByDay();
  //       await refreshDiaryDataLive(selectedDate);
  //     } else {
  //       await getDiaryData(selectedDate, false);
  //       emit(DiaryLoaded());
  //     }
  //   } finally {
  //     _isSwitching = false; // Reset the flag after the action completes
  //   }
  // }

  String getDateForDay(String day) {
    switch (day) {
      case 'yesterday':
        return DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days: 1)));
      case 'today':
        return DateFormat("yyyy-MM-dd").format(DateTime.now());
      case 'tomorrow':
        return DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: 1)));
      default:
        return DateFormat("yyyy-MM-dd").format(DateTime.now());
    }
  }



  Future<void> deleteItemEmpty({

    required int index,

    required String date,
    required String type,
    bool isCached = false,
  }) async {



    // Recalculate the values for the specified nutrient
    switch (type) {
      case 'proteins':
        dayDetailsResponse!.data!.proteins!.caloriesDetails!.removeAt(index);
        await calculateProteins();
        break;
      case 'carbs':
        dayDetailsResponse!.data!.carbs!.caloriesDetails!.removeAt(index);
        await calculateCarbs();
        break;
      case 'fats':
        dayDetailsResponse!.data!.fats!.caloriesDetails!.removeAt(index);
        await calculateFats();
        break;
    }


    // Save updated data locally
    await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, lastSelectedDate.value);
    await _diaryRepository.saveDairyLocally(dayDetailsResponse!, lastSelectedDate.value);

    emit(DiaryLoaded());
  }



  Future<void> fetchOtherCalories({bool isChangeState = false}) async {
    emit(DiaryLoading());
    try {
      final response = await _diaryRepository.getOtherCalories();
      otherCaloriesResponse = response;
      if(isChangeState){
        emit(DiaryLoadedOtherCalories());
      }
    } catch (e) {
      emit(DiaryError(e.toString()));
    }
  }

  Future<void> fetchOtherCaloriesUnits({bool changeState=false}) async {
    emit(DiaryLoading());
    try {
      final response = await _diaryRepository.getOtherCaloriesUnit();
      myOtherCaloriesUnitsResponse = response;
      if(changeState){
        emit(DiaryLoaded());
      }
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
        .caloriesDetails!.fold(0.0, (previousValue, element) {
      String caloriesString = element.calories?.toString().replaceAll(',', '').trim() ?? '0';
      if (RegExp(r'^[0-9]*\.?[0-9]+$').hasMatch(caloriesString)) {
        return previousValue + double.parse(caloriesString);
      } else {
        print('Invalid numeric format: $caloriesString');
        return previousValue;
      }
    }).toStringAsFixed(2);
    dayDetailsResponse!.data!.proteins!.caloriesTotal!.progress?.percentage = (double.parse(dayDetailsResponse!.data!.proteins!.caloriesTotal!.taken.toString())/double.parse(dayDetailsResponse!.data!.proteins!.caloriesTotal!.imposed.toString()))*100.toInt();
    if(dayDetailsResponse!.data!.proteins!.caloriesTotal!.progress?.percentage <100){
      dayDetailsResponse!.data!.proteins!.caloriesTotal!.progress!.bg = '4169E1';
    }else if(dayDetailsResponse!.data!.proteins!.caloriesTotal!.progress?.percentage >100){
      dayDetailsResponse!.data!.proteins!.caloriesTotal!.progress!.bg = 'f00000';
    }
    if((double.parse(dayDetailsResponse!.data!.proteins!.caloriesTotal!.imposed.toString())-double.parse(dayDetailsResponse!.data!.proteins!.caloriesTotal!.taken.toString()))<=50 && (double.parse(dayDetailsResponse!.data!.proteins!.caloriesTotal!.imposed.toString())-double.parse(dayDetailsResponse!.data!.proteins!.caloriesTotal!.taken.toString()))>=-25){
      dayDetailsResponse!.data!.proteins!.caloriesTotal!.progress!.bg = '7fc902';
    }
    emit(DiaryLoaded());
  }
  calculateCarbs(){
    if(dayDetailsResponse!.data!.carbs!
        .caloriesDetails!.isEmpty){
      dayDetailsResponse!.data!.carbs!.caloriesTotal!.taken = 0.0.toStringAsFixed(2);
    }
    dayDetailsResponse!.data!.carbs!.caloriesTotal!.taken = dayDetailsResponse!.data!.carbs!
        .caloriesDetails!.fold(0.0, (previousValue, element) {
      String caloriesString = element.calories?.toString().replaceAll(',', '').trim() ?? '0';
      if (RegExp(r'^[0-9]*\.?[0-9]+$').hasMatch(caloriesString)) {
        return previousValue + double.parse(caloriesString);
      } else {
        print('Invalid numeric format: $caloriesString');
        return previousValue;
      }
    }).toStringAsFixed(2);
    dayDetailsResponse!.data!.carbs!.caloriesTotal!.progress?.percentage = (double.parse(dayDetailsResponse!.data!.carbs!.caloriesTotal!.taken.toString())/double.parse(dayDetailsResponse!.data!.carbs!.caloriesTotal!.imposed.toString()))*100.toInt();
    if(dayDetailsResponse!.data!.carbs!.caloriesTotal!.progress?.percentage <100){
      dayDetailsResponse!.data!.carbs!.caloriesTotal!.progress!.bg = '4169E1';
    }else if(dayDetailsResponse!.data!.carbs!.caloriesTotal!.progress?.percentage >100){
      dayDetailsResponse!.data!.carbs!.caloriesTotal!.progress!.bg = 'f00000';
    }

    if((double.parse(dayDetailsResponse!.data!.carbs!.caloriesTotal!.imposed.toString())-double.parse(dayDetailsResponse!.data!.carbs!.caloriesTotal!.taken.toString()))<=50 && (double.parse(dayDetailsResponse!.data!.carbs!.caloriesTotal!.imposed.toString())-double.parse(dayDetailsResponse!.data!.carbs!.caloriesTotal!.taken.toString()))>=-25){
      dayDetailsResponse!.data!.carbs!.caloriesTotal!.progress!.bg = '7fc902';
    }
    emit(DiaryLoaded());
  }
  calculateFats(){
    if(dayDetailsResponse!.data!.fats!
        .caloriesDetails!.isEmpty){
      dayDetailsResponse!.data!.fats!.caloriesTotal!.taken = 0.0.toStringAsFixed(2);
    }

    dayDetailsResponse!.data!.fats!.caloriesTotal!.taken = dayDetailsResponse!.data!.fats!
        .caloriesDetails!.fold(0.0, (previousValue, element) {
      String caloriesString = element.calories?.toString().replaceAll(',', '').trim() ?? '0';
      if (RegExp(r'^[0-9]*\.?[0-9]+$').hasMatch(caloriesString)) {
        return previousValue + double.parse(caloriesString);
      } else {
        print('Invalid numeric format: $caloriesString');
        return previousValue;
      }
    }).toStringAsFixed(2);

    dayDetailsResponse!.data!.fats!.caloriesTotal!.progress?.percentage = (double.parse(dayDetailsResponse!.data!.fats!.caloriesTotal!.taken.toString())/double.parse(dayDetailsResponse!.data!.fats!.caloriesTotal!.imposed.toString()))*100.toInt();
    if(dayDetailsResponse!.data!.fats!.caloriesTotal!.progress?.percentage <100){
      dayDetailsResponse!.data!.fats!.caloriesTotal!.progress!.bg = '4169E1';
    }else if(dayDetailsResponse!.data!.fats!.caloriesTotal!.progress?.percentage > 100){
      dayDetailsResponse!.data!.fats!.caloriesTotal!.progress!.bg = 'f00000';
    }

    if((double.parse(dayDetailsResponse!.data!.fats!.caloriesTotal!.imposed.toString())-double.parse(dayDetailsResponse!.data!.fats!.caloriesTotal!.taken.toString()))<=50 && (double.parse(dayDetailsResponse!.data!.fats!.caloriesTotal!.imposed.toString())-double.parse(dayDetailsResponse!.data!.fats!.caloriesTotal!.taken.toString()))>=-25){
      dayDetailsResponse!.data!.fats!.caloriesTotal!.progress!.bg = '7fc902';
    }
    emit(DiaryLoaded());
  }


  Future updateWaterData(String water) async {

    final result = await Connectivity().checkConnectivity();
    if (false) {

    }else{
      // await _diaryRepository
      //     .createDiaryData(water: water, date: lastSelectedDate.value);
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

      await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, lastSelectedDate.value);
      await _diaryRepository.saveDairyLocally(dayDetailsResponse!, lastSelectedDate.value);
      // refreshDiaryData(apiDate.value, 'proteins');
    }


  }

  final workoutLoading = false.obs;

  Future updateWork() async {
    final result = await Connectivity().checkConnectivity();
    // await _diaryRepository
    //     .createDiaryData(
    //   workOut: workOut.value,
    //   workoutDesc: workDesc,
    //   date: apiDate.value,
    // );
    Fluttertoast.showToast(msg: "Saved successfully");

    print(lastSelectedDate.value);

    dayDetailsResponse!.data!.dayWorkouts = DayWorkouts(
        workoutType: workOutData.value??dayDetailsResponse?.data?.workouts?.last.title,
        workoutDesc: workDesc
    );


    await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, lastSelectedDate.value);
    await _diaryRepository.saveDairyLocally(dayDetailsResponse!, lastSelectedDate.value);

    print('dayDetailsResponse?.data?.dayWorkouts?.workoutDesc');
    print(dayDetailsResponse?.data?.dayWorkouts?.workoutDesc);

    refreshDiaryData(lastSelectedDate.value, "carbs");


  }

  Future updateNote() async {
    final result = await Connectivity().checkConnectivity();

    Fluttertoast.showToast(msg: "Saved successfully");

    dayDetailsResponse!.data!.dayClinicNote = clinicDesc;
    await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, lastSelectedDate.value);
    await _diaryRepository.saveDairyLocally(dayDetailsResponse!, lastSelectedDate.value);
    refreshDiaryData(lastSelectedDate.value, "carbs");

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

  void createOrUpdateFoodData(Food? food, double _quantity, {
    int? index,
    int? randomId,
    int? itemIndex,
    required String type,
    bool? hasNoId,
    bool? isUsual,
  }) async {
    DateTime formattedTime = getEgyptTime();

    // Generate randomId if not provided
    int? randomIDD = randomId ?? int.parse(
        '${food!.id}${Random().nextInt(100).toString().padLeft(2, '0')}');

    CaloriesDetails newDetails = CaloriesDetails(
      randomId: randomIDD,
      qty: _quantity,
      quality: food!.title,
      color: food.color,
      createdAt: DateFormat('yyyy-MM-dd HH:mm').format(formattedTime),
      calories: (food.caloriePerUnit * _quantity).toStringAsFixed(2),
      unit: food.unit,
      id: index,
    );

    List<CaloriesDetails>? detailsList;
    switch (type) {
      case 'proteins':
        detailsList = dayDetailsResponse!.data!.proteins!.caloriesDetails;
        break;
      case 'carbs':
        detailsList = dayDetailsResponse!.data!.carbs!.caloriesDetails;
        break;
      default:
        detailsList = dayDetailsResponse!.data!.fats!.caloriesDetails;
    }

    if (isUsual == true) {
      detailsList!.add(newDetails);
    }

    // Check if the item already exists (enhanced check)
    int existingIndex = detailsList!.indexWhere((element) {
      return (element.randomId != null && element.randomId == newDetails.randomId) ||
          (element.randomId == null && element.quality == newDetails.quality && element.calories == newDetails.calories);
    });

    if (existingIndex == -1) {
      // Add only if not found
      print('Adding');
      detailsList.add(newDetails);
    } else {
      // Update the existing item if needed
      detailsList[existingIndex] = newDetails;
    }

    // Assign the updated list back to the corresponding property
    switch (type) {
      case 'proteins':
        dayDetailsResponse!.data!.proteins!.caloriesDetails = detailsList;
        await calculateProteins();
        break;
      case 'carbs':
        dayDetailsResponse!.data!.carbs!.caloriesDetails = detailsList;
        await calculateCarbs();
        break;
      default:
        dayDetailsResponse!.data!.fats!.caloriesDetails = detailsList;
        await calculateFats();
    }
      // Save data locally and refresh the diary
      await _diaryRepository.saveDairyLocally(dayDetailsResponse!, lastSelectedDate.value);
      await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, lastSelectedDate.value);
        // await refreshDiaryData(lastSelectedDate.value, type);

      emit(DiaryLoaded());
  }


  // void createOrUpdateFoodData(Food? food, double _quantity,
  //     {int? index, int? randomId, int? itemIndex, required String type, bool? hasNoId, bool? isUsual}) async {
  //
  //   DateTime formattedTime = getEgyptTime();
  //
  //   // Generate randomId if not provided
  //
  //   int? randomIDD = randomId;
  //   if(index==null && randomId == null) {
  //     randomIDD = int.parse(
  //         '${food!.id}${Random().nextInt(100).toString().padLeft(2, '0')}');
  //   }
  //
  //   CaloriesDetails newDetails = CaloriesDetails(
  //     randomId: randomIDD,
  //     qty: _quantity,
  //     quality: food!.title,
  //     color: food.color,
  //     createdAt: DateFormat('yyyy-MM-dd HH:mm').format(formattedTime),
  //     calories: (food.caloriePerUnit * _quantity).toStringAsFixed(2),
  //     unit: food.unit,
  //     id: index
  //   );
  //
  //
  //   // List to update based on type
  //   List<CaloriesDetails>? detailsList;
  //   switch (type) {
  //     case 'proteins':
  //       detailsList = dayDetailsResponse!.data!.proteins!.caloriesDetails;
  //       break;
  //     case 'carbs':
  //       detailsList = dayDetailsResponse!.data!.carbs!.caloriesDetails;
  //       break;
  //     default:
  //       detailsList = dayDetailsResponse!.data!.fats!.caloriesDetails;
  //       // break;
  //   }
  //   if(isUsual==true){
  //     // detailsList!.add(newDetails);
  //     switch (type) {
  //       case 'proteins':
  //         dayDetailsResponse!.data!.proteins!.caloriesDetails!.add(newDetails);
  //         break;
  //       case 'carbs':
  //         dayDetailsResponse!.data!.carbs!.caloriesDetails!.add(newDetails);
  //         break;
  //       default:
  //         dayDetailsResponse!.data!.fats!.caloriesDetails!.add(newDetails);
  //     // break;
  //     }
  //
  //   }
  //   // Check if item already exists (by randomId or index)
  //   int existingIndex = detailsList!.indexWhere((element) => element.randomId == randomId && element.id == index);
  //
  //   if (existingIndex == -1) {
  //     print('Adding');
  //     // Entry does not exist, add a new one
  //     // detailsList.add(newDetails);
  //     if(detailsList.isEmpty) {
  //
  //       detailsList.add(newDetails);
  //
  //     }
  //     else if(hasNoId==true) {
  //       if(detailsList.last.quality != newDetails.quality || detailsList.last.calories!=newDetails.calories) {
  //
  //
  //
  //           if(detailsList.any((item) => (item.randomId==newDetails.randomId)|| (item.randomId == null&& item.quality == newDetails.quality))){
  //
  //           }else{
  //             detailsList.add(newDetails);
  //           }
  //       }else{
  //         detailsList.last.randomId= newDetails.randomId;
  //         switch (type) {
  //           case 'proteins':
  //             dayDetailsResponse!.data!.proteins!.caloriesDetails = detailsList;
  //             await calculateProteins();
  //             break;
  //           case 'carbs':
  //             dayDetailsResponse!.data!.carbs!.caloriesDetails = detailsList;
  //             await calculateCarbs();
  //             break;
  //           case 'fats':
  //             dayDetailsResponse!.data!.fats!.caloriesDetails = detailsList;
  //             await calculateFats();
  //             break;
  //         }
  //       }
  //     }
  //     else{
  //       if(newDetails.id ==null) {
  //         print('Adding2');
  //
  //
  //         if(itemIndex!=null){
  //           print('Addingindex');
  //
  //           switch (type) {
  //             case 'proteins':
  //               dayDetailsResponse!.data!.proteins!.caloriesDetails![itemIndex].randomId = newDetails.randomId;
  //               break;
  //             case 'carbs':
  //               dayDetailsResponse!.data!.carbs!.caloriesDetails![itemIndex].randomId = newDetails.randomId;
  //               break;
  //             default:
  //               dayDetailsResponse!.data!.fats!.caloriesDetails![itemIndex].randomId = newDetails.randomId;
  //           // break;
  //           }
  //
  //
  //         }else{
  //         switch (type) {
  //           case 'proteins':
  //             dayDetailsResponse!.data!.proteins!.caloriesDetails!.last.randomId = newDetails.randomId;
  //             break;
  //           case 'carbs':
  //             dayDetailsResponse!.data!.carbs!.caloriesDetails!.last.randomId = newDetails.randomId;
  //             break;
  //           default:
  //             dayDetailsResponse!.data!.fats!.caloriesDetails!.last.randomId = newDetails.randomId;
  //         // break;
  //         }
  //         }
  //       }else{
  //         detailsList[detailsList.indexWhere((element) => element.id==newDetails.id)] = newDetails;
  //       }
  //     }
  //   } else {
  //     // Entry exists, update it
  //     detailsList[existingIndex] = newDetails;
  //
  //   }
  //
  //   // Recalculate the nutrient values
  //   switch (type) {
  //     case 'proteins':
  //       await calculateProteins();
  //       break;
  //     case 'carbs':
  //       await calculateCarbs();
  //       break;
  //     default:
  //       await calculateFats();
  //       // break;
  //   }
  //
  //   // switch (type) {
  //   //   case 'proteins':
  //   //     dayDetailsResponse!.data!.proteins!.caloriesDetails = detailsList;
  //   //     break;
  //   //   case 'carbs':
  //   //     dayDetailsResponse!.data!.carbs!.caloriesDetails = detailsList;
  //   //     break;
  //   //   case 'fats':
  //   //     dayDetailsResponse!.data!.fats!.caloriesDetails = detailsList;
  //   //     break;
  //   // }
  //
  //
  //   // Save data locally and refresh the diary
  //   await _diaryRepository.saveDairyLocally(dayDetailsResponse!, lastSelectedDate.value);
  //   await _diaryRepository.saveDairyToSendLocally(dayDetailsResponse!, lastSelectedDate.value);
  //     // await refreshDiaryData(lastSelectedDate.value, type);
  //
  //   emit(DiaryLoaded());
  //
  // }


  updateDiaryDataLocally(int randomId,Food? food, double _quantity,
      {int? index, required String type})async{

    await _diaryRepository.saveDiaryDataLocally(
      DiaryData(
        date: lastSelectedDate.value,
        foodProtine: food!.id,
        qtyProtiene: _quantity,
        randomId: randomId,
      )
    );
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

  // void refreshCaloriesList(List<CaloriesDetails> list) {
  //   List<CaloriesDetails> emptyList = [];
  //   emptyList.addAll(
  //       caloriesDetails.where((element) => element.qty == null).toList());
  //
  //   caloriesDetails.clear();
  //   caloriesDetails.addAll(list);
  //   caloriesDetails.addAll(emptyList);
  //   return;
  // }
  //
  // void refreshCarbsList(List<CaloriesDetails> list) {
  //   List<CaloriesDetails> emptyList = [];
  //   emptyList
  //       .addAll(carbsDetails.where((element) => element.qty == null).toList());
  //   carbsDetails.clear();
  //   carbsDetails.addAll(list);
  //   carbsDetails.addAll(emptyList);
  //   return;
  //
  // }
  //
  // void refreshFatsList(List<CaloriesDetails> list) {
  //   List<CaloriesDetails> emptyList = [];
  //   emptyList
  //       .addAll(fatsDetails.where((element) => element.qty == null).toList());
  //   fatsDetails.clear();
  //   fatsDetails.addAll(list);
  //   fatsDetails.addAll(emptyList);
  //   return;
  //
  // }

  Future saveMyOtherCaloriesLocally(MyOtherCaloriesResponse response)async{
    await _diaryRepository.saveMyOtherCaloriesLocally(response);
  }

  Future<void> deleteCalorie(String endPoint, int id) async {
    try {
      emit(CalorieLoading());

      // Call the repository method
      final result = await _diaryRepository.deleteCalorie(endPoint, id);

      result.fold(
            (failure) {
          // Handle failure case
          emit(CalorieDeletedFailure(failure.message));
        },
            (response) {
          // Handle success case
          if (response.success??false) {
            emit(CalorieDeletedSuccess(response.message??''));
          } else {
            emit(CalorieDeletedFailure("Failed to delete calorie entry."));
          }
        },
      );
    } catch (error) {
      emit(CalorieDeletedFailure(error.toString()));
    }
  }

  // Adding Favorite Calorie
  Future<void> addFavoriteCalorie(int calorieId) async {
    emit(FavoriteCalorieAdding());
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity != ConnectivityResult.none) {
      final result = await _diaryRepository.addFavoriteCalorie(calorieId);
      result.fold(
            (failure) => emit(DiaryError(failure.message)),
            (_) {
              emit(FavoriteCalorieAdded());
            },
      );
    } else {
      await _diaryRepository.saveFavoriteActionOffline('add', calorieId);
      emit(FavoriteCalorieAddedOffline());
    }
  }

// Deleting Favorite Calorie
  Future<void> deleteFavoriteCalorie(int calorieId) async {
    emit(FavoriteCalorieDeleting());
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity != ConnectivityResult.none) {
      final result = await _diaryRepository.deleteFavoriteCalorie(calorieId);
      result.fold(
            (failure) => emit(DiaryError(failure.message)),
            (_) => emit(FavoriteCalorieDeleted("")),
      );
    } else {
      await _diaryRepository.saveFavoriteActionOffline('delete', calorieId);
      emit(FavoriteCalorieDeletedOffline());
    }
  }

// Syncing Favorite Actions
  Future<void> syncFavoriteActions() async {
    emit(FavoriteActionsSyncing());
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity != ConnectivityResult.none) {
      try {
        await _diaryRepository.sendCachedFavoriteActions();
        emit(FavoriteActionsSynced());
      } catch (error) {
        emit(FavoriteActionsSyncFailed());
      }
    }
  }

}


class SingleImageItem {
  int id;
  String imagePath;
  bool selected;

  SingleImageItem(
      {required this.id, required this.imagePath, required this.selected});
}

