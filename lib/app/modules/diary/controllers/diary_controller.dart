import 'dart:convert';
import 'dart:math';

import 'package:app/app/models/day_details_reposne.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/pdf_viewr.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:app/home_page_view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../routes/app_pages.dart';
DateTime? otherLoaded;
bool isSending = false;
class DiaryController extends GetxController {
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController textEditController = TextEditingController();
  RxList<SingleImageItem> waterBottlesList = RxList();
  RxList<CaloriesDetails> caloriesDetails = RxList();
  RxList<CaloriesDetails> carbsDetails = RxList();
  RxList<CaloriesDetails> fatsDetails = RxList();
  final response = DayDetailsResponse().obs;
  FocusNode workoutTitleDescFocus = FocusNode();
  final isLoading = false.obs;
  final refreshLoadingProtine = false.obs;
  final refreshLoadingCarbs = false.obs;
  final refreshLoadingFats = false.obs;
  final isToday = false.obs;
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
  // final controllerTimeSleep = Get.find<TimeSleepController>(tag: 'timeSleep');

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

  @override
  void onInit() async{
    super.onInit();
    isSending = true;
    if(lastSelectedDate.value==''){
      lastSelectedDate.value=DateTime.now().toString().substring(0, 10);
    }

    getNotifications();
    getFromCash();
    await viewCachedRequests();
    loadData();
    //   _initData();
  }

  loadData()async{

    DateTime? lastLoadTime = await ApiProvider().getLastLoadingTime();

    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
    if(lastLoadTime == null || lastLoadTime.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      // await ApiProvider().getContactData();
      // await ApiProvider().getAboutData();
      await ApiProvider().getSleepingTimesData();
      // await ApiProvider().getOrientationVideos();
      // await ApiProvider().getMessagesData();
      // await ApiProvider().getTransformationData();
      await ApiProvider().getOtherCaloreis();
      await ApiProvider().getOtherCaloriesUnit();
      print("Load First");
      await ApiProvider().saveLastLoadingTime(DateTime.now());
      if (response.value.data == null) {
        getDiaryData(
            lastSelectedDate.value != '' ? lastSelectedDate.value : DateTime
                .now().toString().substring(0, 10),isSending);
      }

    }else{
      // if(otherLoaded==null ||otherLoaded!.isBefore(DateTime.now().subtract(Duration(seconds: 90)))){
      //   await ApiProvider().getOtherCaloreis().then((value) => otherLoaded= DateTime.now());
      // }
    }
    }else{
      if(lastLoadTime!.isBefore(DateTime.now().subtract(Duration(days: 2)))){
        Fluttertoast.showToast(msg: "Please You want to connect the internet",toastLength: Toast.LENGTH_LONG);
      }
    }
  }
  Future viewCachedRequests()async{
// Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        Fluttertoast.showToast(msg: "Connecting to live",toastLength: Toast.LENGTH_LONG);

        // If internet connection is available, send saved diary data
        await ApiProvider().createOtherCaloriesData();

        await ApiProvider().sendSavedDiaryDataByDay();
        await ApiProvider().sendDeleteCalorie();
        await ApiProvider().sendDeleteOtherCalorie();
        // You can add additional methods to send other saved data if needed
        // await controllerTimeSleep.sendSavedSleepTimes();
        await ApiProvider().sendSavedSleepTimes();
        await ApiProvider().createUsualMealData();
        await ApiProvider().sendDeleteUsualMeal();
        isSending = false;
        getDiaryData(
            lastSelectedDate.value != '' ? lastSelectedDate.value : DateTime
                .now().toString().substring(0, 10),true);

        // refreshDiaryData(apiDate.value, 'proteins');

      }
    });
  }


  String _timezone = 'Unknown';
  List<String> _availableTimezones = <String>[];

  final isLogggd = false.obs;

  void getFromCash() async {
    isLogggd.value = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    if (isLogggd.value != true) {
      // Navigator.pushAndRemoveUntil(
      //     Get.context!,
      //     MaterialPageRoute(
      //       builder: (context) => UnAuthView(),
      //     ),
      //     (Route<dynamic> route) => false);
      // getDiaryData(DateTime.now().toString().substring(0, 10));

    } else {
      getDiaryData(DateTime.now().toString().substring(0, 10),isSending);
    }
  }

  void getDiaryDataRefreshResponse(String _date) async {
    isLoading.value = true;
    try {
      await ApiProvider().getDiaryView(_date,!isSending,false).then((value) {
        if (value.success == false && value.data == null) {
          noSessions.value = true;
        } else {
          response.value = value;
        }
      });
    } catch (e) {}
    isLoading.value = false;
  }

  void getDiaryData(String _date,bool isSending) async {
    print("DATEDATE$_date");
    if(response.value.data!=null) {
      if (isLoading.value) return;
      if (refreshLoadingProtine.value) return;
      if (refreshLoadingCarbs.value) return;
      if (refreshLoadingFats.value) return;
    }
    Echo('getDiaryData');
    lastSelectedDate.value = _date;
    isLoading.value = true;
    caloriesDetails.clear();
    carbsDetails.clear();
    fatsDetails.clear();
    Echo("====> Gittng Day $_date Info ");

    await ApiProvider().getDiaryView(_date,!isSending,false).then((value) {
      if (value.success == false && value.data == null) {
        //  isLoading.value = false;
        //  noSessions.value = true;
        SharedHelper().logout();
        // Get.offAllNamed(Routes.LOGIN);
        Fluttertoast.showToast(msg: "${value.message}");
      } else {
        if (value.data != null) {
          response.value = value;
          isLoading.value = false;
          showLoader.value = false;
          length.value = response.value.data!.water! + 3;
          workOut.value = response.value.data!.workouts![0].id!;
          workDesc = response.value.data!.dayWorkouts == null
              ? " "
              : response.value.data!.dayWorkouts!.workoutDesc!;
          textEditController.text = response.value.data!.dayWorkouts == null
              ? " "
              : response.value.data!.dayWorkouts!.workoutDesc!;
          workOutData.value = response.value.data!.dayWorkouts == null
              ? " "
              : response.value.data!.dayWorkouts!.workoutType!;
          waterBottlesList.clear();

          if (response.value.data!.days![0].active == true) {
            isToday.value = true;
          } else {
            isToday.value = false;
          }
          for (int i = 0; i < response.value.data!.days!.length; i++) {
            if (response.value.data!.days![i].active == true) {
              date.value = response.value.data!.days![i].dateFormat!;
              apiDate.value = response.value.data!.days![i].date!;
            } else {}
          }

          for (int i = 1; i <= length.value; i++) {
            if (i <= response.value.data!.water!) {
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
          Echo(
              "Percentage ${response.value.data!.proteins!.caloriesTotal!.progress!.percentage!.toDouble()} For ${response.value.data!.proteins!.caloriesTotal!.taken} / ${response.value.data!.proteins!.caloriesTotal!.imposed}");
        } else {
          if (lastSelectedDate.value.isNotEmpty) {
            getDiaryData(lastSelectedDate.value,isSending);
          } else {
            getDiaryData(DateTime.now().toString().substring(0, 10),isSending);
          }
          response.value = value;
          isLoading.value = false;
          showLoader.value = false;
          date.value = _date;
          Echo("error");
        }
        // caloriesDetails.clear();
        // carbsAndFats.clear();
        refreshCaloriesList(
            response.value.data!.proteins!.caloriesDetails ?? []);
        refreshCarbsList(response.value.data!.carbs!.caloriesDetails ?? []);
        refreshFatsList(response.value.data!.fats!.caloriesDetails ?? []);

        // caloriesDetails.addAll(response.value.data!.proteins!.caloriesDetails!);
        // carbsAndFats.addAll(response.value.data!.carbsFats!.caloriesDetails!);
      }
    });

    try {
      await ApiProvider().getHomeData().then((value) {
        if (value.success == true) {
          globalIsIosInReview = (value.data!.subscriptionStatus == false);
        } else {}
      });
    } catch (e) {}


  }

  void refreshDiaryData(String _date, String type) async {
    Echo('refreshDiaryData');
    // if (type == 'proteins') refreshLoadingProtine.value = true;
    // if (type == 'carbs') refreshLoadingCarbs.value = true;
    // if (type == 'fats') refreshLoadingFats.value = true;
    lastSelectedDate.value = _date;
    response.value = await ApiProvider().getDiaryView(_date,!isSending,false);
    if (response.value.data!.proteins!.caloriesDetails!.isEmpty &&
        response.value.data!.carbs!.caloriesDetails!.isEmpty &&
        response.value.data!.fats!.caloriesDetails!.isEmpty) {
      if (type == 'proteins') refreshLoadingProtine.value = false;
      if (type == 'carbs') refreshLoadingCarbs.value = false;
      if (type == 'fats') refreshLoadingFats.value = false;
      return;
    } else {
      // caloriesDetails.removeWhere((element) => element.id == null);
      // carbsAndFats.removeWhere((element) => element.id == null);
      response.value.data!.proteins!.caloriesDetails!.forEach((element) {
        if (caloriesDetails
                .where((element2) => element.id == element2.id &&element.randomId == element2.randomId)
                .toList()
                .length >
            0) {
          caloriesDetails.forEach((item) {
            if (item.id == element.id  && element.randomId == item.randomId) {
              item.quality = element.quality;
              item.qty = element.qty;
              item.calories = element.calories;
            }
          });
        } else {
          refreshCaloriesList(
              response.value.data!.proteins!.caloriesDetails ?? []);
        }
      });
      response.value.data!.carbs!.caloriesDetails!.forEach((element) {
        if (carbsDetails
                .where((element2) => element.id == element2.id &&element.randomId == element2.randomId)
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
          refreshCarbsList(response.value.data!.carbs!.caloriesDetails ?? []);
        }
      });

      response.value.data!.fats!.caloriesDetails!.forEach((element) {
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
          refreshFatsList(response.value.data!.fats!.caloriesDetails ?? []);
        }
      });
    }
    caloriesDetails.refresh();
    carbsDetails.refresh();
    fatsDetails.refresh();
    caloriesDetails.forEach((element) {
      print(element.quality.toString() + element.qty.toString());
    });
    carbsDetails.forEach((element) {
      print(element.quality.toString() + element.qty.toString());
    });
    carbsDetails.forEach((element) {
      print(element.quality.toString() + element.qty.toString());

    });
    fatsDetails.forEach((element) {
      print(element.quality.toString() + element.qty.toString());

    });
    if (type == 'proteins') refreshLoadingProtine.value = false;
    if (type == 'carbs') refreshLoadingCarbs.value = false;
    if (type == 'fats') refreshLoadingFats.value = false;
  }

  Future<void> deleteItemCalories(int id, String _date, String type) async {

    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      response.value.data!.proteins!
          .caloriesDetails!.removeWhere((element) => element.id==id);

      await calculateProteins();

      await ApiProvider().saveDairyLocally(response.value, apiDate.value);

      // refreshDiaryData(apiDate.value, type);
      await ApiProvider()
          .deleteCalorie("delete_calories_details", id)
          .then((value) {
        if (value.success == true) {
          caloriesDetails.removeWhere((element) => element.id == id);
          // refreshDiaryData(apiDate.value, type);
        } else {
          caloriesDetails.removeWhere((element) => element.id == id);
          // refreshDiaryData(apiDate.value, type);
          Fluttertoast.showToast(msg: "${value.message}");
        }
      });
    }else{
      await ApiProvider().deleteCalorieLocally(id);

      response.value.data!.proteins!
          .caloriesDetails!.removeWhere((element) => element.id==id);

      await calculateProteins();

      await ApiProvider().saveDairyToSendLocally(response.value, apiDate.value);
      await ApiProvider().saveDairyLocally(response.value, apiDate.value);
      refreshDiaryData(apiDate.value, type);
    }
  }

  Future<void> deleteItemCarbs(int id, String _date, String type) async {

    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      response.value.data!.carbs!
          .caloriesDetails!.removeWhere((element) => element.id==id);

      await calculateCarbs();

      await ApiProvider().saveDairyLocally(response.value, apiDate.value);

      // refreshDiaryData(apiDate.value, type);
      await ApiProvider()
          .deleteCalorie("delete_calories_details", id)
          .then((value) {
        if (value.success == true) {
          carbsDetails.removeWhere((element) => element.id == id);
          // refreshDiaryData(apiDate.value, type);
        } else {
          carbsDetails.removeWhere((element) => element.id == id);
          // refreshDiaryData(apiDate.value, type);
          Fluttertoast.showToast(msg: "${value.message}");
        }
      });

    }else{
      await ApiProvider().deleteCalorieLocally(id);

      response.value.data!.carbs!
          .caloriesDetails!.removeWhere((element) => element.id==id);

      await calculateCarbs();

      await ApiProvider().saveDairyToSendLocally(response.value, apiDate.value);
      await ApiProvider().saveDairyLocally(response.value, apiDate.value);
      refreshDiaryData(apiDate.value, type);
    }
  }

  Future<void> deleteItemFats(int id, String _date, String type) async {

    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      response.value.data!.fats!
          .caloriesDetails!.removeWhere((element) => element.id==id);


      await calculateFats();

      await ApiProvider().saveDairyLocally(response.value, apiDate.value);

      // refreshDiaryData(apiDate.value, type);

      await ApiProvider()
          .deleteCalorie("delete_calories_details", id)
          .then((value) {
        if (value.success == true) {
          fatsDetails.removeWhere((element) => element.id == id);
          // refreshDiaryData(apiDate.value, type);
        } else {
          fatsDetails.removeWhere((element) => element.id == id);
          // refreshDiaryData(apiDate.value, type);
          Fluttertoast.showToast(msg: "${value.message}");
        }
      });
    }else{
      await ApiProvider().deleteCalorieLocally(id);

      response.value.data!.fats!
          .caloriesDetails!.removeWhere((element) => element.id==id);


      await calculateFats();

      await ApiProvider().saveDairyToSendLocally(response.value, apiDate.value);
      await ApiProvider().saveDairyLocally(response.value, apiDate.value);
      refreshDiaryData(apiDate.value, type);
    }
  }

  Future<void> deleteItemCaloriesCached(int randomId, String _date, String type) async {

      await ApiProvider().removeCashedDiaryDataLocally(randomId);
      // response.value.data!.proteins!.caloriesTotal!.taken = double.parse(response.value.data!.proteins!.caloriesTotal!.taken.toString())-double.parse(response.value.data!.proteins!.caloriesDetails!.firstWhere((element) => element.randomId==randomId).calories.toString());
      // response.value.data!.proteins!.caloriesTotal!.progress?.percentage = (double.parse(response.value.data!.proteins!.caloriesTotal!.taken.toString())/double.parse(response.value.data!.proteins!.caloriesTotal!.imposed.toString()))*100.toInt();
      // if(response.value.data!.proteins!.caloriesTotal!.progress?.percentage >0){
      //   response.value.data!.proteins!.caloriesTotal!.progress!.bg = '4169E1';
      // }else if(response.value.data!.proteins!.caloriesTotal!.progress?.percentage >100){
      //   response.value.data!.proteins!.caloriesTotal!.progress!.bg = 'f00000';
      // }
      response.value.data!.proteins!
          .caloriesDetails!.removeWhere((element) => element.randomId==randomId);

      await calculateProteins();

      caloriesDetails.removeWhere((element) => element.randomId==randomId);
      await ApiProvider().saveDairyToSendLocally(response.value, apiDate.value);
      await ApiProvider().saveDairyLocally(response.value, apiDate.value);
      refreshDiaryData(apiDate.value, type);

  }

  Future<void> deleteItemCarbsCached(int randomId, String _date, String type) async {

      await ApiProvider().removeCashedDiaryDataLocally(randomId);

      response.value.data!.carbs!
          .caloriesDetails!.removeWhere((element) => element.randomId==randomId);
      carbsDetails.removeWhere((element) => element.randomId==randomId);


      await calculateCarbs();


      await ApiProvider().saveDairyToSendLocally(response.value, apiDate.value);
      await ApiProvider().saveDairyLocally(response.value, apiDate.value);
      refreshDiaryData(apiDate.value, type);

  }

  Future<void> deleteItemFatsCached(int randomId, String _date, String type) async {

      await ApiProvider().removeCashedDiaryDataLocally(randomId);

      response.value.data!.fats!
          .caloriesDetails!.removeWhere((element) => element.randomId==randomId);
      fatsDetails.removeWhere((element) => element.randomId==randomId);

      await calculateFats();

      await ApiProvider().saveDairyToSendLocally(response.value, apiDate.value);
      await ApiProvider().saveDairyLocally(response.value, apiDate.value);

      refreshDiaryData(apiDate.value, type);

  }

  calculateProteins(){
    response.value.data!.proteins!.caloriesTotal!.taken = response.value.data!.proteins!
        .caloriesDetails!.fold(0.0, (previousValue, element) => previousValue+ double.parse(element.calories.toString())).toStringAsFixed(2);
    response.value.data!.proteins!.caloriesTotal!.progress?.percentage = (double.parse(response.value.data!.proteins!.caloriesTotal!.taken.toString())/double.parse(response.value.data!.proteins!.caloriesTotal!.imposed.toString()))*100.toInt();
    if(response.value.data!.proteins!.caloriesTotal!.progress?.percentage <100){
      response.value.data!.proteins!.caloriesTotal!.progress!.bg = '4169E1';
    }else if(response.value.data!.proteins!.caloriesTotal!.progress?.percentage >100){
      response.value.data!.proteins!.caloriesTotal!.progress!.bg = 'f00000';
    }
  }
  calculateCarbs(){
    response.value.data!.carbs!.caloriesTotal!.taken = response.value.data!.carbs!
        .caloriesDetails!.fold(0.0, (previousValue, element) => previousValue+ double.parse(element.calories.toString())).toStringAsFixed(2);

    response.value.data!.carbs!.caloriesTotal!.progress?.percentage = (double.parse(response.value.data!.carbs!.caloriesTotal!.taken.toString())/double.parse(response.value.data!.carbs!.caloriesTotal!.imposed.toString()))*100.toInt();
    if(response.value.data!.carbs!.caloriesTotal!.progress?.percentage <100){
      response.value.data!.carbs!.caloriesTotal!.progress!.bg = '4169E1';
    }else if(response.value.data!.carbs!.caloriesTotal!.progress?.percentage >100){
      response.value.data!.carbs!.caloriesTotal!.progress!.bg = 'f00000';
    }
  }
  calculateFats(){
    response.value.data!.fats!.caloriesTotal!.taken = response.value.data!.fats!
        .caloriesDetails!.fold(0.0, (previousValue, element) => previousValue+ double.parse(element.calories.toString())).toStringAsFixed(2);

    response.value.data!.fats!.caloriesTotal!.progress?.percentage = (double.parse(response.value.data!.fats!.caloriesTotal!.taken.toString())/double.parse(response.value.data!.fats!.caloriesTotal!.imposed.toString()))*100.toInt();
    if(response.value.data!.fats!.caloriesTotal!.progress?.percentage <100){
      response.value.data!.fats!.caloriesTotal!.progress!.bg = '4169E1';
    }else if(response.value.data!.fats!.caloriesTotal!.progress?.percentage > 100){
      response.value.data!.fats!.caloriesTotal!.progress!.bg = 'f00000';
    }
  }


  void updateWaterData(String water) async {

    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      showLoader.value = true;
      response.value.data!.water = int.parse(water);
      length.value = response.value.data!.water! + 3;
      waterBottlesList.clear();
      for (int i = 1; i <= length.value; i++) {
        if (i <= response.value.data!.water!) {
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
      Echo("error");

      await ApiProvider().saveDairyLocally(response.value, apiDate.value);
      // refreshDiaryData(apiDate.value, 'proteins');
      await ApiProvider()
          .createDiaryData(water: water, date: apiDate.value)
          .then((value) {
        if (value.success == true) {
          showLoader.value = false;
          // getDiaryData(apiDate.value);
          Fluttertoast.showToast(msg: "${value.message}");
        } else {
          // Fluttertoast.showToast(msg: "${value.message}");
          response.value.data!.water = int.parse(water);
          length.value = response.value.data!.water! + 3;
          waterBottlesList.clear();
          for (int i = 1; i <= length.value; i++) {
            if (i <= response.value.data!.water!) {
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
          Echo("error");
        }
      });
    }else{
      await ApiProvider()
          .createDiaryData(water: water, date: apiDate.value);
// Fluttertoast.showToast(msg: "${value.message}");
      response.value.data!.water = int.parse(water);
      length.value = response.value.data!.water! + 3;
      waterBottlesList.clear();
      for (int i = 1; i <= length.value; i++) {
        if (i <= response.value.data!.water!) {
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
      Echo("error");

      await ApiProvider().saveDairyToSendLocally(response.value, apiDate.value);
      await ApiProvider().saveDairyLocally(response.value, apiDate.value);
      // refreshDiaryData(apiDate.value, 'proteins');
    }


  }

  final workoutLoading = false.obs;

  void updateWork() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      await ApiProvider()
          .createDiaryData(
        workOut: workOut.value,
        workout_desc: workDesc,
        date: apiDate.value,
      );
      Fluttertoast.showToast(msg: "Saved successfully");

      response.value.data!.dayWorkouts = DayWorkouts(
        workoutType: workOutData.value,
        workoutDesc: workDesc
      );

      await ApiProvider().saveDairyToSendLocally(response.value, apiDate.value);
      await ApiProvider().saveDairyLocally(response.value, apiDate.value);
      refreshDiaryData(apiDate.value, "carbs");

    }else {
      workoutLoading.value = true;
      await ApiProvider()
          .createDiaryData(
        workOut: workOut.value,
        workout_desc: workDesc,
        date: apiDate.value,
      ).then((value) {
        if (value.success == true) {
          workoutLoading.value = false;
          Fluttertoast.showToast(msg: "${value.message}");
        } else {
          workoutLoading.value = false;
          Fluttertoast.showToast(msg: "Server Error");
          Echo("error");
        }
      });
    }
  }

  void downloadFile(String url) async {
    Navigator.push(
        Get.context!,
        MaterialPageRoute(
            builder: (context) =>
                PDFPreview(res: "$url", name: "Calories Calculator")));
  }

  void showPobUp(String text) {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0)),
                height: MediaQuery.of(Get.context!).size.height / 1.5,
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
    if (type == 'proteins') refreshLoadingProtine.value = true;
    if (type == 'carbs') refreshLoadingCarbs.value = true;
    if (type == 'fats') refreshLoadingFats.value = true;

    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      print('OKOK');
      if (type == 'proteins'){
        // response.value.data!.proteins!.caloriesTotal!.taken = double.parse(response.value.data!.proteins!.caloriesTotal!.taken.toString())+(response.value.data!.proteins!.food!.firstWhere((element) => element.id==food.id).caloriePerUnit! *_quantity);

        response.value.data!.proteins!
            .caloriesDetails!.add(CaloriesDetails(
            qty: _quantity,
            quality: food!.title,
            color: food.color,
            calories: food.caloriePerUnit * _quantity,
            unit: food.unit
        ));

        await calculateProteins();
        await ApiProvider().saveDairyLocally(response.value, apiDate.value);
        // refreshDiaryData(apiDate.value, type);
      }
      if (type == 'carbs'){
        // response.value.data!.carbs!.caloriesTotal!.taken = double.parse(response.value.data!.carbs!.caloriesTotal!.taken.toString())+(response.value.data!.carbs!.food!.firstWhere((element) => element.id==food.id).caloriePerUnit! *_quantity);

        response.value.data!.carbs!
            .caloriesDetails!.add(CaloriesDetails(
            qty: _quantity,
            quality: food!.title,
            color: food.color,
            calories: food.caloriePerUnit * _quantity,unit: food!.unit));

        await calculateCarbs();

        await ApiProvider().saveDairyLocally(response.value, apiDate.value);
        // refreshDiaryData(apiDate.value, type);
      }else
      if (type == 'fats'){
        // response.value.data!.fats!.caloriesTotal!.taken = double.parse(response.value.data!.fats!.caloriesTotal!.taken.toString())+(response.value.data!.fats!.food!.firstWhere((element) => element.id==food.id).caloriePerUnit! *_quantity);

        response.value.data!.fats!
            .caloriesDetails!.add(CaloriesDetails(
            qty: _quantity,quality: food!.title,
            color: food.color,
            calories: food.caloriePerUnit * _quantity,unit: food!.unit));


        await calculateFats();

        await ApiProvider().saveDairyLocally(response.value, apiDate.value);
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

      await ApiProvider().createDiaryData(
          foodProtine: food!.id, qtyProtiene: _quantity, date: apiDate.value);
      refreshDiaryData(apiDate.value, type);

    }else{
      int randomId =int.parse('${food!.id}${Random().nextInt(100).toString().padLeft(2,'0')}');
      await ApiProvider().createDiaryData(
          randomId: randomId,
          foodProtine: food.id,
          foodName:food.title,
          caloriesPerUnit:food.caloriePerUnit,
          qtyProtiene: _quantity, date: apiDate.value);
      if (type == 'proteins'){
        // response.value.data!.proteins!.caloriesTotal!.taken = double.parse(response.value.data!.proteins!.caloriesTotal!.taken.toString())+(response.value.data!.proteins!.food!.firstWhere((element) => element.id==food.id).caloriePerUnit! *_quantity);

    response.value.data!.proteins!
            .caloriesDetails!.add(CaloriesDetails(
            randomId: randomId,
            qty: _quantity,
        quality: food.title,
        color: food.color,
        calories: food.caloriePerUnit * _quantity,
        unit: food.unit
    ));
    await calculateProteins();

        await ApiProvider().saveDairyLocally(response.value, apiDate.value);
        await ApiProvider().saveDairyToSendLocally(response.value, apiDate.value);
        refreshDiaryData(apiDate.value, type);
      }
      if (type == 'carbs'){
        // response.value.data!.carbs!.caloriesTotal!.taken = double.parse(response.value.data!.carbs!.caloriesTotal!.taken.toString())+(response.value.data!.carbs!.food!.firstWhere((element) => element.id==food.id).caloriePerUnit! *_quantity);

        response.value.data!.carbs!
            .caloriesDetails!.add(CaloriesDetails(
            randomId: randomId,
            qty: _quantity,quality: food!.title,
            color: food.color,
            calories: food.caloriePerUnit * _quantity,unit: food!.unit));

        await calculateCarbs();

        await ApiProvider().saveDairyToSendLocally(response.value, apiDate.value);
        await ApiProvider().saveDairyLocally(response.value, apiDate.value);
        refreshDiaryData(apiDate.value, type);
      }else
      if (type == 'fats'){
        // response.value.data!.fats!.caloriesTotal!.taken = double.parse(response.value.data!.fats!.caloriesTotal!.taken.toString())+(response.value.data!.fats!.food!.firstWhere((element) => element.id==food.id).caloriePerUnit! *_quantity);

        response.value.data!.fats!
            .caloriesDetails!.add(CaloriesDetails(
            randomId: randomId,
            qty: _quantity,quality: food!.title,
            color: food.color,
            calories: food.caloriePerUnit * _quantity,unit: food!.unit));


        await calculateFats();

        await ApiProvider().saveDairyToSendLocally(response.value, apiDate.value);
        await ApiProvider().saveDairyLocally(response.value, apiDate.value);
        refreshDiaryData(apiDate.value, type);
      }
      caloriesDetails.refresh();
      carbsDetails.refresh();
      fatsDetails.refresh();
      caloriesDetails.forEach((element) {
        print(element.quality.toString() + element.qty.toString());
      });
      carbsDetails.forEach((element) {
        print(element.quality.toString() + element.qty.toString());
      });
      carbsDetails.forEach((element) {
        print(element.quality.toString() + element.qty.toString());

      });
      fatsDetails.forEach((element) {
        print(element.quality.toString() + element.qty.toString());

      });
      if (type == 'proteins') refreshLoadingProtine.value = false;
      if (type == 'carbs') refreshLoadingCarbs.value = false;
      if (type == 'fats') refreshLoadingFats.value = false;
    }
  }

  updateDiaryDataLocally(int randomId,Food? food, double _quantity,
  {int? index, required String type})async{
    print("randomId");

    await ApiProvider().saveDiaryDataLocally(
        DiaryData(
          date: apiDate.value,
          foodProtine: food!.id,
          qtyProtiene: _quantity,
          randomId: randomId,
        ),
    );
  }

  void updateProtineData(
      int? index,
  Food? food,
      double _quantity,
      {required String type}) async {
    if (type == 'proteins') refreshLoadingProtine.value = true;
    if (type == 'carbs') refreshLoadingCarbs.value = true;
    if (type == 'fats') refreshLoadingFats.value = true;


    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      if (type == 'proteins'){

        response.value.data!.proteins!
            .caloriesDetails![response.value.data!.proteins!
            .caloriesDetails!.indexWhere((element) => element.id == index)] = CaloriesDetails(
            id: index,
            qty: _quantity,quality: food!.title,
            color: food.color,
            calories: food.caloriePerUnit * _quantity,unit: food.unit);

        await calculateProteins();

        await ApiProvider().saveDairyLocally(response.value, apiDate.value);
        // refreshDiaryData(apiDate.value, type);
      }
      if (type == 'carbs'){

        response.value.data!.carbs!
            .caloriesDetails![response.value.data!.carbs!
            .caloriesDetails!.indexWhere((element) => element.id == index)] = CaloriesDetails(
            id: index,
            qty: _quantity,quality: food!.title,
            color: food.color,
            calories: food.caloriePerUnit * _quantity,unit: food!.unit);


        await calculateCarbs();

        await ApiProvider().saveDairyLocally(response.value, apiDate.value);
        // refreshDiaryData(apiDate.value, type);
      }else
      if (type == 'fats'){

        response.value.data!.fats!
            .caloriesDetails![response.value.data!.fats!
            .caloriesDetails!.indexWhere((element) => element.id == index)] = CaloriesDetails(
            id: index,
            qty: _quantity,quality: food!.title,
            color: food.color,
            calories: food.caloriePerUnit * _quantity,unit: food!.unit);


        await calculateFats();

        await ApiProvider().saveDairyLocally(response.value, apiDate.value);
        // refreshDiaryData(apiDate.value, type);
      }
      caloriesDetails.refresh();
      carbsDetails.refresh();
      fatsDetails.refresh();

      if (type == 'proteins') refreshLoadingProtine.value = false;
      if (type == 'carbs') refreshLoadingCarbs.value = false;
      if (type == 'fats') refreshLoadingFats.value = false;

      await ApiProvider().saveDairyLocally(response.value, apiDate.value);

      // refreshDiaryData(apiDate.value, type);
      await ApiProvider().editDiaryData(
          foodProtine: food!.id,
          qtyProtiene: _quantity,
          date: apiDate.value,
          id: index);
      refreshDiaryData(apiDate.value, type);
    }else{
      await ApiProvider().editDiaryData(
          foodProtine: food!.id,
          qtyProtiene: _quantity,
          date: apiDate.value,
          id: index);
      if (type == 'proteins'){

        response.value.data!.proteins!
            .caloriesDetails![response.value.data!.proteins!
            .caloriesDetails!.indexWhere((element) => element.id == index)] = CaloriesDetails(
          id: index,
            qty: _quantity,quality: food!.title,
            color: food.color,
            calories: food.caloriePerUnit * _quantity,unit: food!.unit);

        await calculateProteins();
        await ApiProvider().saveDairyToSendLocally(response.value, apiDate.value);
        await ApiProvider().saveDairyLocally(response.value, apiDate.value);
        refreshDiaryData(apiDate.value, type);
      }
      if (type == 'carbs'){

        response.value.data!.carbs!
            .caloriesDetails![response.value.data!.carbs!
            .caloriesDetails!.indexWhere((element) => element.id == index)] = CaloriesDetails(
            id: index,
            qty: _quantity,quality: food!.title,
            color: food.color,
            calories: food.caloriePerUnit * _quantity,unit: food!.unit);


        await calculateCarbs();
        await ApiProvider().saveDairyToSendLocally(response.value, apiDate.value);
        await ApiProvider().saveDairyLocally(response.value, apiDate.value);
        refreshDiaryData(apiDate.value, type);
      }else
      if (type == 'fats'){

        response.value.data!.fats!
            .caloriesDetails![response.value.data!.fats!
            .caloriesDetails!.indexWhere((element) => element.id == index)] = CaloriesDetails(
            id: index,
            qty: _quantity,quality: food!.title,
            color: food.color,
            calories: food.caloriePerUnit * _quantity,unit: food!.unit);


        await calculateFats();
        await ApiProvider().saveDairyToSendLocally(response.value, apiDate.value);
        await ApiProvider().saveDairyLocally(response.value, apiDate.value);
        refreshDiaryData(apiDate.value, type);
      }
      caloriesDetails.refresh();
      carbsDetails.refresh();
      fatsDetails.refresh();

      if (type == 'proteins') refreshLoadingProtine.value = false;
      if (type == 'carbs') refreshLoadingCarbs.value = false;
      if (type == 'fats') refreshLoadingFats.value = false;

    }

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
            Echo('item ${item.quality} resItem${resItem.quality}');
            Echo('item ${item.qty} resItem${resItem.qty}');
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
            Echo('item ${item.quality} resItem${resItem.quality}');
            Echo('item ${item.qty} resItem${resItem.qty}');
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
            Echo('item ${item.quality} resItem${resItem.quality}');
            Echo('item ${item.qty} resItem${resItem.qty}');
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
