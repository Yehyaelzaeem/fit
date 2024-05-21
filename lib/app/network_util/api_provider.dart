import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:app/app/models/about_response.dart';
import 'package:app/app/models/basic_response.dart';
import 'package:app/app/models/cheer_full_response.dart';
import 'package:app/app/models/cheerful_response.dart';
import 'package:app/app/models/contact_response.dart';
import 'package:app/app/models/day_details_reposne.dart';
import 'package:app/app/models/faq_response.dart';
import 'package:app/app/models/general_response.dart';
import 'package:app/app/models/home_page_response.dart';
import 'package:app/app/models/meal_details_response.dart';
import 'package:app/app/models/meal_features_home_response.dart';
import 'package:app/app/models/meal_features_status_response.dart';
import 'package:app/app/models/meal_food_list_response.dart';
import 'package:app/app/models/message_details_response.dart';
import 'package:app/app/models/messages_response.dart';
import 'package:app/app/models/my_orders_response.dart';
import 'package:app/app/models/my_other_calories_response.dart';
import 'package:app/app/models/my_packages_response.dart';
import 'package:app/app/models/mymeals_response.dart';
import 'package:app/app/models/orientation_videos_response.dart';
import 'package:app/app/models/orintation_response.dart';
import 'package:app/app/models/other_calories_units_repose.dart';
import 'package:app/app/models/package_details_response.dart';
import 'package:app/app/models/payment_package_response.dart';
import 'package:app/app/models/services_response.dart';
import 'package:app/app/models/session_response.dart';
import 'package:app/app/models/sessions_details_response.dart';
import 'package:app/app/models/sleep_time_response.dart';
import 'package:app/app/models/transformation_response.dart';
import 'package:app/app/models/user_response.dart';
import 'package:app/app/models/version_response.dart';
import 'package:app/app/network_util/network.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/const_strings.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:app/app/widgets/app_dialog.dart';
import 'package:app/globale_controller.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_core/src/get_main.dart';

import '../models/sleeping_time_response.dart';
import '../models/usual_meals_data_reposne.dart';
import '../models/usual_meals_reposne.dart';
import '../modules/timeSleep/controllers/time_sleep_controller.dart';
import '../utils/translations/strings.dart';

DateTime? loadingSessions;
DateTime? loadingHome;

class ApiProvider {
  NetworkUtil _utils = new NetworkUtil();

  Future<HomePageResponse> getHomeData() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none && (loadingHome==null||loadingHome!.isBefore(DateTime.now().subtract(Duration(minutes: 3))))) {
      Response response = await _utils.get("home");
      if (response.statusCode == 200) {
        loadingHome = DateTime.now();
        saveHomeDataLocally(HomePageResponse.fromJson(response.data));
        return HomePageResponse.fromJson(response.data);
      } else {
        saveHomeDataLocally(HomePageResponse.fromJson(response.data));
        return HomePageResponse.fromJson(response.data);
      }
    }else{
      HomePageResponse? home = await readHomeDataLocally();

      return home??HomePageResponse();
    }
  }
  // Function to save user data locally
  Future<void> saveHomeDataLocally(HomePageResponse homePageResponse) async {
    await SharedHelper().writeData(CachingKey.HOME, jsonEncode(homePageResponse.toJson()));
  }
  Future<HomePageResponse?> readHomeDataLocally() async {
    String? home = await SharedHelper().readString(CachingKey.HOME);
    if(home!=null){
      return HomePageResponse.fromJson(jsonDecode(home));
    }else{
      return null;
    }
  }


  Future<MessagesResponse> getMessagesData() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response = await _utils.get("messages");
      if (response.statusCode == 200) {
        saveMessagesLocally(MessagesResponse.fromJson(response.data));
        return MessagesResponse.fromJson(response.data);
      } else {
        saveMessagesLocally(MessagesResponse.fromJson(response.data));
        return MessagesResponse.fromJson(response.data);
      }
    } else{

  MessagesResponse? messages = await readMessagesLocally();

  return messages??MessagesResponse();
  }
  }
  Future<void> saveMessagesLocally(MessagesResponse transformationsResponse) async {
    await SharedHelper().writeData(CachingKey.MESSAGES, jsonEncode(transformationsResponse.toJson()));
  }
  Future<MessagesResponse?> readMessagesLocally() async {
    String? messages = await SharedHelper().readString(CachingKey.MESSAGES);
    if(messages!=null){
      return MessagesResponse.fromJson(jsonDecode(messages));
    }else{
      return null;
    }
  }

  Future<TransformationsResponse> getTransformationData() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response = await _utils.get("transformations");
      if (response.statusCode == 200) {
        saveTransformationLocally(TransformationsResponse.fromJson(response.data));
        return TransformationsResponse.fromJson(response.data);
      } else {
        saveTransformationLocally(TransformationsResponse.fromJson(response.data));
        return TransformationsResponse.fromJson(response.data);
      }
    }else{
      TransformationsResponse? transformations = await readTransformationLocally();
      log('TransformationsResponse ${transformations}');

      return transformations??TransformationsResponse();
    }
  }
  // Function to save Transformation data locally
  Future<void> saveTransformationLocally(TransformationsResponse transformationsResponse) async {
    await SharedHelper().writeData(CachingKey.Transformation, jsonEncode(transformationsResponse.toJson()));
  }
  Future<TransformationsResponse?> readTransformationLocally() async {
    String? home = await SharedHelper().readString(CachingKey.Transformation);
    if(home!=null){
      return TransformationsResponse.fromJson(jsonDecode(home));
    }else{
      return null;
    }
  }
  Future<GeneralResponse> deleteMessage(int id) async {
    FormData body = FormData.fromMap({
      'id': id,
    });
    Response response = await _utils.post("delete_message", body: body);
    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
  }

  Future<MessageDetailsResponse> getMessagesDetailsData(int id) async {
    Response response = await _utils.get("message/$id");
    if (response.statusCode == 200) {
      return MessageDetailsResponse.fromJson(response.data);
    } else {
      return MessageDetailsResponse.fromJson(response.data);
    }
  }
  // Function to save Transformation data locally
  Future<void> saveMessageDetailsLocally(MessageDetailsResponse messageDetailsResponse) async {
    await SharedHelper().writeData(CachingKey.Transformation, jsonEncode(messageDetailsResponse.toJson()));
  }
  Future<MessageDetailsResponse?> readMessageDetailsLocally() async {
    String? home = await SharedHelper().readString(CachingKey.Transformation);
    if(home!=null){
      return MessageDetailsResponse.fromJson(jsonDecode(home));
    }else{
      return null;
    }
  }

  Future<AboutResponse> getAboutData() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response = await _utils.get("about");
      if (response.statusCode == 200) {
        saveAboutLocally(AboutResponse.fromJson(response.data));
        return AboutResponse.fromJson(response.data);
      } else {
        saveAboutLocally(AboutResponse.fromJson(response.data));
        return AboutResponse.fromJson(response.data);
      }
    }else{

      AboutResponse? about = await readAboutLocally();

      return about??AboutResponse();
    }
  }
  // Function to save About data locally
  Future<void> saveAboutLocally(AboutResponse aboutResponse) async {
    await SharedHelper().writeData(CachingKey.ABOUT, jsonEncode(aboutResponse.toJson()));
  }
  Future<AboutResponse?> readAboutLocally() async {
    String? home = await SharedHelper().readString(CachingKey.ABOUT);
    if(home!=null){
      return AboutResponse.fromJson(jsonDecode(home));
    }else{
      return null;
    }
  }

  Future<SleepingTimesResponse> getSleepingTimesData() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response = await _utils.get("sleeping_times");
      if (response.statusCode == 200) {
        saveSleepingTimesLocally(SleepingTimesResponse.fromJson(response.data));
        return SleepingTimesResponse.fromJson(response.data);
      } else {
        saveSleepingTimesLocally(SleepingTimesResponse.fromJson(response.data));
        return SleepingTimesResponse.fromJson(response.data);
      }
    }else{

      SleepingTimesResponse? about = await readSleepingTimesLocally();

      return about??SleepingTimesResponse();
    }
  }
  // Function to save Sleep Times data locally
  Future<void> saveSleepingTimesLocally(SleepingTimesResponse sleepingTimesResponse) async {
    await SharedHelper().writeData(CachingKey.SLEEPING_TIMES, jsonEncode(sleepingTimesResponse.toJson()));
  }
  Future<SleepingTimesResponse?> readSleepingTimesLocally() async {
    String? home = await SharedHelper().readString(CachingKey.SLEEPING_TIMES);
    if(home!=null){
      return SleepingTimesResponse.fromJson(jsonDecode(home));
    }else{
      return null;
    }
  }

  Future<ContactResponse> getContactData() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response = await _utils.get("contact");
      if (response.statusCode == 200) {
        saveContactLocally(ContactResponse.fromJson(response.data));
        return ContactResponse.fromJson(response.data);
      } else {
        saveContactLocally(ContactResponse.fromJson(response.data));
        return ContactResponse.fromJson(response.data);
      }
    }else{

      ContactResponse? about = await readContactLocally();

      return about??ContactResponse();
    }
  }
  // Function to save About data locally
  Future<void> saveContactLocally(ContactResponse contactResponse) async {
    await SharedHelper().writeData(CachingKey.CONTACT, jsonEncode(contactResponse.toJson()));
  }
  Future<ContactResponse?> readContactLocally() async {
    String? home = await SharedHelper().readString(CachingKey.CONTACT);
    if(home!=null){
      return ContactResponse.fromJson(jsonDecode(home));
    }else{
      return null;
    }
  }
  Future<OrintationResponse> getOritationSelletionsData(int id) async {
    Response response = await _utils.get("orientation_settings/$id");
    if (response.statusCode == 200) {
      return OrintationResponse.fromJson(response.data);
    } else {
      return OrintationResponse.fromJson(response.data);
    }
  }

  Future<FaqResponse> getFaqtData() async {
    Response response = await _utils.get("faq");
    if (response.statusCode == 200) {
      return FaqResponse.fromJson(response.data);
    } else {
      return FaqResponse.fromJson(response.data);
    }
  }

  Future<GeneralResponse> sendContactData(String name, String email,
      String phone, String subject, String message) async {
    FormData body = FormData.fromMap({
      'name': name,
      'email': email,
      'phone': phone,
      'subject': subject,
      'message': message
    });
    Response response = await _utils.post("contact_form", body: body);
    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
  }

  Future<UserResponse> login(String id, String password) async {
    String deviceId = await kDeviceInfo();
    String deviceToken = await kDeviceToken();
    FormData body = FormData.fromMap({
      'patient_id': id,
      'password': password,
      'device_id': deviceId + id,
      'fcm_token': deviceToken,
    });
    print("Current sent Id ${deviceId + id}");
    Response response = await _utils.post("login", body: body);
    if (response.data["success"] == true) {
      return UserResponse.fromJson(response.data);
    } else {
      return UserResponse.fromJson(response.data);
    }
  }

  Future<GeneralResponse> forgetPassword(String email) async {
    FormData body = FormData.fromMap({'email': email});
    Response response = await _utils.post("forget_password", body: body);
    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
  }

  Future<UserResponse> changePassword({
    required String password,
    required String confirmPassword,
  }) async {
    FormData body = FormData.fromMap(
        {'password': password, 'password_confirmation': confirmPassword});
    Response response = await _utils.post("change_password", body: body);
    if (response.data["success"] == true) {
      return UserResponse.fromJson(response.data);
    } else {
      return UserResponse.fromJson(response.data);
    }
  }

  late int newMessages = 0;

  Future<UserResponse> getProfile() async {
    String deviceId = await kDeviceInfo();
    String deviceToken = await kDeviceToken();
    bool isGuestLogin = false;
    isGuestLogin = await SharedHelper().readBoolean(CachingKey.IS_GUEST_SAVED);
    final GlobalController globalController =
        getx.Get.find<GlobalController>(tag: 'global');
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response = await _utils.get(isGuestLogin
          ? "profile?device_id=$deviceId&fcm_token=$deviceToken"
          : "profile?fcm_token=$deviceToken");
      print(
          "Profile Url ${isGuestLogin
              ? "profile?device_id=$deviceId&fcm_token=$deviceToken"
              : "profile?fcm_token=$deviceToken"}");
      if (response.data["success"] == true) {
        UserResponse ur = UserResponse.fromJson(response.data);
        if (globalController.shoNewMessage.value) {
          if (ur.data != null &&
              ur.data!.newMessages != null &&
              ur.data!.newMessages! > 0) {
            globalController.shoNewMessage.value = false;

            appDialog(
              title: 'You have a new message from \n Dr/ Ramy Mansour',
              image: Icon(Icons.chat, size: 50, color: Colors.grey),
              barrierDismissible: false,
              cancelAction: null,
              confirmAction: () {
                globalController.canDismissNewMessageDialog.value = true;
                globalController.removeNotificationsCount.value = true;
                getx.Get.back();
                getx.Get.toNamed(Routes.NOTIFICATIONS);
              },
              cancelText: '',
              confirmText: 'Check it',
            );
          }
        }
        saveUserLocally(ur);
        return ur;
      }
      else {
        UserResponse ur = UserResponse.fromJson(response.data);
        if (globalController.shoNewMessage.value) {
          if (ur.data != null &&
              ur.data!.newMessages != null &&
              ur.data!.newMessages! > 0) {
            globalController.shoNewMessage.value = false;
          }
        }
        saveUserLocally(ur);

        return ur;
      }
    }else{
      UserResponse? ur = await readUserLocally();
      return ur??UserResponse();
    }
  }
  // Function to save user data locally
  Future<void> saveUserLocally(UserResponse userResponse) async {
    await SharedHelper().writeData(CachingKey.USER, jsonEncode(userResponse.toJson()));
  }
  Future<UserResponse?> readUserLocally() async {
    String? userr = await SharedHelper().readString(CachingKey.USER);
    if(userr!=null){
      return UserResponse.fromJson(jsonDecode(userr));
    }else{
      return null;
    }
  }


  Future<SessionResponse> getSessions() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none && (loadingSessions==null||loadingSessions!.isBefore(DateTime.now().subtract(Duration(minutes: 3))))) {
    Response response = await _utils.get("sessions");
    if (response.data["success"] == true) {
      loadingSessions = DateTime.now();
      saveSessionsLocally(SessionResponse.fromJson(response.data));
      return SessionResponse.fromJson(response.data);
    } else {
      saveSessionsLocally(SessionResponse.fromJson(response.data));
      return SessionResponse.fromJson(response.data);
    }
  }else{
      SessionResponse? ur = await readSessionsLocally();
  return ur??SessionResponse();
  }
  }
  Future<void> saveSessionsLocally(SessionResponse sessionResponse) async {
    await SharedHelper().writeData(CachingKey.SESSIONS, jsonEncode(sessionResponse.toJson()));
  }
  Future<SessionResponse?> readSessionsLocally() async {

    String? home = await SharedHelper().readString(CachingKey.SESSIONS);
    if(home!=null){
      return SessionResponse.fromJson(jsonDecode(home));
    }else{
      return null;
    }
  }

  Future<ServicesResponse> getServices() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
    Response response = await _utils.get("services");
    if (response.data["success"] == true) {
      saveServicesLocally(ServicesResponse.fromJson(response.data));
      return ServicesResponse.fromJson(response.data);
    } else {
      saveServicesLocally(ServicesResponse.fromJson(response.data));
      return ServicesResponse.fromJson(response.data);
    }
    }else{
      ServicesResponse? ur = await readServicesLocally();
      return ur??ServicesResponse();
    }
  }
  Future<void> saveServicesLocally(ServicesResponse servicesResponse) async {
    await SharedHelper().writeData(CachingKey.SERVICES, jsonEncode(servicesResponse.toJson()));
  }
  Future<ServicesResponse?> readServicesLocally() async {
    String? home = await SharedHelper().readString(CachingKey.SERVICES);
    if(home!=null){
      return ServicesResponse.fromJson(jsonDecode(home));
    }else{
      return null;
    }
  }

  Future<void> deleteAccount() async {
    await _utils.post("delete_account");
  }

  Future<SleepTimeResponse> addSleepTime({
    String? sleepTimeFrom,
    String? sleepTimeTo,
    String? date,
  }) async {
    FormData body = FormData.fromMap({
      'sleeping_from': sleepTimeFrom,
      'sleeping_to': sleepTimeTo,
      'date': date,
    });
    Response response = await _utils.post("set_sleeping_time", body: body);
    print('-------> sleep time ${response.data}');
    if (response.data["success"] == true) {
      return SleepTimeResponse.fromJson(response.data);
    } else {
      return SleepTimeResponse.fromJson(response.data);
    }
  }

  // Function to save the last loading time
  Future<void> saveLastLoadingTime(DateTime time) async {
    await SharedHelper().readString(CachingKey.USUAL_MEALS);
    SharedHelper().writeData(CachingKey.LAST_LOADING_TIME, time.millisecondsSinceEpoch);
  }

  // Function to get the last loading time
  Future<DateTime?> getLastLoadingTime() async {
    int? millisecondsSinceEpoch = await SharedHelper().readInteger(CachingKey.LAST_LOADING_TIME);
    return millisecondsSinceEpoch != null ? DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch) : null;
  }

  Future<DayDetailsResponse> getDiaryView(String? date,bool isNotSending,bool notSave,bool isLive) async {
    final result = await Connectivity().checkConnectivity();
    DayDetailsResponse? dayDetailsResponseTemp = await readDairyTempLocally();


    if (result != ConnectivityResult.none&&isNotSending && isLive) {
    print('date ====>$date');
    Response response = await _utils.get("calories_day_details?date=$date");
    log('api->calories_day_details?date=$date');
    log('response ${response.data}');
    if (response.data["success"] == true) {
      if(dayDetailsResponseTemp==null){
        saveDairyTempLocally(DayDetailsResponse.fromJson(response.data));
      }
      if(!notSave) {
        saveDairyLocally(DayDetailsResponse.fromJson(response.data), date!);
      }
      return DayDetailsResponse.fromJson(response.data);
    } else {
      if(dayDetailsResponseTemp==null){
        saveDairyTempLocally(DayDetailsResponse.fromJson(response.data));
      }
      if(!notSave) {
        saveDairyLocally(DayDetailsResponse.fromJson(response.data),date!);
      }
      return DayDetailsResponse.fromJson(response.data);
    }
    }else{
      print(date);
      Map<String, dynamic> dairy = await readDairyLocally();
      dynamic data = dairy[date];
      if (data != null) {
        return DayDetailsResponse.fromJson(data);
      } else {
        if(dayDetailsResponseTemp!=null){
          // if(dayDetailsResponseTemp.data?.days!.any((element) => element.date==date)??true){
          //   dayDetailsResponseTemp.data?.days?.forEach((element) {
          //     print(element.date);
          //     print(element.dateFormat);
          //     print(element.active);
          //     if(element.date==date){
          //       element.active = true;
          //     }else{
          //       element.active = false;
          //     }
          //
          //   });
          //   dayDetailsResponseTemp.data?.days?.forEach((element) {
          //
          //     print(element.date);
          //     print(element.dateFormat);
          //     print(element.active);
          //   });
          // }else{
            dayDetailsResponseTemp.data?.days = List.generate(3, (index){
              if(index==0){
                return  Days(date: date,dateFormat: DateFormat('EEEE, d MMMM y').format(DateTime.parse(date!)),active: true);
              }else
              if(index==1) {
                return  Days(date: DateTime.parse(date!).subtract(Duration(days: 1))
                    .toString()
                    .substring(0, 10),
                    dateFormat: DateFormat('EEEE, d MMMM y').format(
                        DateTime.parse(date!).subtract(Duration(days: 1))),
                    active: false);
              }else
              if(index==2) {
              return  Days(date: DateTime.parse(date!).add(Duration(days: 1))
                    .toString()
                    .substring(0, 10),
                    dateFormat: DateFormat('EEEE, d MMMM y').format(
                        DateTime.parse(date).add(Duration(days: 1))),
                    active: false);
              }else{
                return Days(date: DateTime.parse(date!).add(Duration(days: 1))
                    .toString()
                    .substring(0, 10),
                    dateFormat: DateFormat('EEEE, d MMMM y').format(
                        DateTime.parse(date).add(Duration(days: 1))),
                    active: false);
              }
            });
          // }
          saveDairyLocally(dayDetailsResponseTemp,date!);

        }

        return dayDetailsResponseTemp??DayDetailsResponse();
      }
      return dairy[date]??DayDetailsResponse();
    }
  }

  Future<void> saveDairyLocally(DayDetailsResponse dayDetailsResponse, String date) async {
    // Read existing data
    Map<String, dynamic> existingData =
    await readDairyLocally();

    // Check if the response date exists in the existing data
    if (existingData.containsKey(date)) {
      // Update existing entry for date4
      print("exist");
      existingData[date] = dayDetailsResponse.toJson();
    } else {
      // If the response date does not exist, add it to the map
      print("Not exist");
      existingData[date] = dayDetailsResponse.toJson();
    }

    // Save the updated map
    await SharedHelper().writeData(CachingKey.DAIRY, jsonEncode(existingData));
  }

  Future<void> saveDairyToSendLocally(DayDetailsResponse dayDetailsResponse, String date) async {
    // Read existing data
    Map<String, dynamic> existingData = await readDairyToSendLocally();

    // Check if the response date exists in the existing data
    if (existingData.containsKey(date)) {
      // Update existing entry for date4
      print("exist");
      existingData[date] = dayDetailsResponse.toJson();
    } else {
      // If the response date does not exist, add it to the map
      print("Not exist");
      existingData[date] = dayDetailsResponse.toJson();
    }

    // Save the updated map
    await SharedHelper().writeData(CachingKey.DAIRY_TO_SEND, jsonEncode(existingData));
  }

  Future<Map<String, dynamic>> readDairyLocally() async {
    String? dairy = await SharedHelper().readString(CachingKey.DAIRY);
    if (dairy != null&&dairy!='') {
      print(dairy);
      print(jsonDecode(dairy));
      return jsonDecode(dairy);
    } else {
      return {};
    }
  }

  Future<Map<String, dynamic>> readDairyToSendLocally() async {
    String? dairy = await SharedHelper().readString(CachingKey.DAIRY_TO_SEND);
    if (dairy != null&&dairy!='') {
      print(dairy);
      print(jsonDecode(dairy));
      return jsonDecode(dairy);
    } else {
      return {};
    }
  }


  // // Function to save user data locally
  // Future<void> saveDairyLocally(DayDetailsResponse dayDetailsResponse) async {
  //   // Read existing data
  //   print("existingDataexistingData");
  //   List<DayDetailsResponse> existingData = await readDairyLocally();
  //   // List<DayDetailsResponse> existingData = [];
  //
  //   print("existingDataexistingData" + existingData.length.toString());
  //   print(dayDetailsResponse.data!.days);
  //
  //   // Check if the response date exists in the existing data
  //   bool found = false;
  //   for (int i = 0; i < existingData.length; i++) {
  //
  //     if(existingData[i].data!.days!.any((element) => element.active==true)){
  //     if (existingData[i].data!.days?.firstWhere((element) => element.active==true).date == dayDetailsResponse.data!.days!.firstWhere((element) => element.active==true).date) {
  //       // Update existing entry
  //       existingData[i] = dayDetailsResponse;
  //       found = true;
  //       break;
  //     }
  //     }
  //   }
  //
  //   // If the response date does not exist, add it to the list
  //   if (!found) {
  //     existingData.add(dayDetailsResponse);
  //   }
  //
  //   // Save the updated list
  //   await SharedHelper().writeData(CachingKey.DAIRY, jsonEncode(existingData.map((e) => e.toJson()).toList()));
  // }
  //
  // // Function to read user data locally
  // Future<List<DayDetailsResponse>> readDairyLocally() async {
  //   List<DayDetailsResponse> result = [];
  //   String? dairy = await SharedHelper().readString(CachingKey.DAIRY);
  //   if (dairy != null && dairy != '') {
  //     List<dynamic> rawData = jsonDecode(dairy);
  //     rawData.forEach((element) {
  //       DayDetailsResponse response = DayDetailsResponse.fromJson(element);
  //       result.add(response);
  //     });
  //   }
  //   return result;
  // }

  // Function to read user data locally
  Future<DayDetailsResponse> readDairyDayLocallyAndMakeNewObject(String dateTime) async {
    print('aaa');
    List<DayDetailsResponse> result = [];
    String? dairy = await SharedHelper().readString(CachingKey.DAIRY);
    print('dairy'+dairy);
    if (dairy != null && dairy != '') {
      List<dynamic> rawData = jsonDecode(dairy);
      rawData.forEach((element) {
        DayDetailsResponse response = DayDetailsResponse.fromJson(element);
        result.add(response);
      });
    }
    for (int i = 0; i < result.length; i++) {

      if(result[i].data!.days!.any((element) => element.active==true)){

      if (result[i].data!.days!.firstWhere((element) => element.active==true).date == dateTime) {
        return result[i];
      }
      }
    }


    if(result.isNotEmpty) {
      result.add(result[0]);
      if(result[result.length - 1].data!.days!.any((element) =>
      element.active == true)) {
        result[result.length - 1].data!.days!.firstWhere((element) =>
        element.active == true).active = false;
        result[result.length - 1].data!.days!.firstWhere((element) =>
        element.date == dateTime).dateFormat =
            formatDateTime(DateTime.parse(dateTime));
        result[result.length - 1].data!.water = 0;
        result[result.length - 1].data!.fats!.caloriesDetails!.clear();
        result[result.length - 1].data!.proteins!.caloriesDetails!.clear();
        result[result.length - 1].data!.carbs!.caloriesDetails!.clear();

        result[result.length - 1].data!.fats!.caloriesTotal!.taken = 0.0;
        result[result.length - 1].data!.proteins!.caloriesTotal!.taken = 0.0;
        result[result.length - 1].data!.carbs!.caloriesTotal!.taken = 0.0;
      }
    }
    await SharedHelper().writeData(CachingKey.DAIRY, jsonEncode(result.map((e) => e.toJson()).toList()));


    return result[result.length-1];
  }
  String formatDateTime(DateTime dateTime) {
    DateFormat formatter = DateFormat('EEEE, dd MMMM yyyy');
    return formatter.format(dateTime);
  }

  // Function to save user data locally
  Future<void> saveDairyTempLocally(DayDetailsResponse dayDetailsResponse) async {
    await SharedHelper().writeData(CachingKey.DAIRY_TEMPLATE, jsonEncode(dayDetailsResponse.toJson()));
  }

  Future<DayDetailsResponse?> readDairyTempLocally() async {
    String? dairy = await SharedHelper().readString(CachingKey.DAIRY_TEMPLATE);
    if(dairy!=null && dairy!=''){
      print(111);
      return DayDetailsResponse.fromJson(jsonDecode(dairy));
    }else{
      print(222);

      return null;
    }
  }

  /// usuals
  Future<UsualMealsResponse> getMyUsualMeals() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
    Response response = await _utils.get("diary-meals");
    log('response ${response.data}');
    if (response.data["success"] == true) {
      saveMyUsualMealsLocally(UsualMealsResponse.fromJson(response.data));
      return UsualMealsResponse.fromJson(response.data);
    } else {
      saveMyUsualMealsLocally(UsualMealsResponse.fromJson(response.data));
      return UsualMealsResponse.fromJson(response.data);
    }
    }else{
      UsualMealsResponse? meals = await readMyUsualMealsLocally();
      log('meals ${meals}');

      return meals??UsualMealsResponse();
    }
  }
  // Function to save user data locally
  Future<void> saveMyUsualMealsLocally(UsualMealsResponse usualMealsDataResponse) async {
    await SharedHelper().writeData(CachingKey.MY_USUAL_MEALS, jsonEncode(usualMealsDataResponse.toJson()));
  }
  Future<UsualMealsResponse?> readMyUsualMealsLocally() async {
    String? meals = await SharedHelper().readString(CachingKey.MY_USUAL_MEALS);
    if(meals!=null){
      return UsualMealsResponse.fromJson(jsonDecode(meals));
    }else{
      return null;
    }
  }

  Future<UsualMealsDataResponse> getUsualMealsData() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response = await _utils.get("diary-meals/food-calories");
      log('UsualMealsDataResponse response ${response.data}');

      if (response.data["success"] == true) {
        saveUsualMealsLocally(UsualMealsDataResponse.fromJson(response.data));
        return UsualMealsDataResponse.fromJson(response.data);
      } else {
        saveUsualMealsLocally(UsualMealsDataResponse.fromJson(response.data));
        return UsualMealsDataResponse.fromJson(response.data);
      }
    }else{
      UsualMealsDataResponse? meals = await readUsualMealsLocally();
      log('meals ${meals}');

      return meals??UsualMealsDataResponse();
    }
  }

  // Function to save user data locally
  Future<void> saveUsualMealsLocally(UsualMealsDataResponse usualMealsDataResponse) async {
    await SharedHelper().writeData(CachingKey.USUAL_MEALS, jsonEncode(usualMealsDataResponse.toJson()));
  }
  Future<UsualMealsDataResponse?> readUsualMealsLocally() async {
    String? meals = await SharedHelper().readString(CachingKey.USUAL_MEALS);
    if(meals!=null){
      return UsualMealsDataResponse.fromJson(jsonDecode(meals));
    }else{
      return null;
    }
  }
  Future<GeneralResponse> createUsualMeal(
      {required Map<String, dynamic> mealParameters}) async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
    FormData body = FormData.fromMap(mealParameters);
    Response response =
        await _utils.post("diary-meals/new_diary_meal", body: body);
    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
    }else{
      await createUsualMealLocally(UsualMealData(
        name: mealParameters["name"],
        foodId: mealParameters["food_id"],
        qty: mealParameters["qty"],
      ));
      return GeneralResponse();
    }
  }


// Function to save UsualMeal data locally
  Future<void> createUsualMealLocally(UsualMealData data) async {
    List<String> mealDataListJson = (await SharedHelper().readStringList(CachingKey.Meals_Creation_LIST)) ?? [];
    mealDataListJson.add(jsonEncode(data.toJson()));
    await SharedHelper().writeData(CachingKey.Meals_Creation_LIST, mealDataListJson);
  }

// Function to send locally saved UsualMeal data to API
  Future<void> createUsualMealData() async {
    List<String> mealDataList = (await SharedHelper().readStringList(CachingKey.Meals_Creation_LIST)) ?? [];

    for (String mealDataJson in mealDataList) {
      UsualMealData mealData = UsualMealData.fromJson(jsonDecode(mealDataJson));

      if(mealData.id ==null){
        await ApiProvider().createUsualMeal(mealParameters: mealData.toJson()
        );
      }
      else{
        await ApiProvider().updateUsualMeal(
            mealParameters: mealData.toJson()
        );
      }
    }

    // Clear locally saved sleep time data after successfully sending to API
    await SharedHelper().removeData(CachingKey.Meals_Creation_LIST);
  }


  Future<GeneralResponse> mealToDiary({required int mealId}) async {
    FormData body = FormData.fromMap({
      "meal_id": mealId,
      "date": DateFormat('yyyy-MM-dd').format(DateTime.now())
    });
    Response response =
        await _utils.post("diary-meals/meal_to_diary", body: body);
    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
  }

  Future<GeneralResponse> updateUsualMeal(
      {required Map<String, dynamic> mealParameters}) async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
    FormData body = FormData.fromMap(mealParameters);
    Response response = await _utils.post(
        "diary-meals/update_diary_meal/${mealParameters['id']}",
        body: body);
    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
    }else{
      await createUsualMealLocally(UsualMealData(
        name: mealParameters["name"],
        foodId: mealParameters["food_id"],
        qty: mealParameters["qty"],
        id: mealParameters['id']
      ));
      return GeneralResponse();
    }
  }

  Future<GeneralResponse> deleteUsualMeal({required int mealId}) async {

      Response response =
      await _utils.post("diary-meals/delete_diary_meal/$mealId");
      if (response.data["success"] == true) {
        return GeneralResponse.fromJson(response.data);
      } else {
        return GeneralResponse.fromJson(response.data);
      }

  }

  // Function to save diary data locally
  Future<void> deleteUsualMealLocally(int id) async {
    List<String> dairyDataListJson = (await SharedHelper().readStringList(CachingKey.DELETE_USUAL_MEAL)) ?? [];
    dairyDataListJson.add(id.toString());
    await SharedHelper().writeData(CachingKey.DELETE_USUAL_MEAL, dairyDataListJson);
  }

// Function to send locally saved diary data to API
  Future<void> sendDeleteUsualMeal() async {
    List<String> deletedDiaryDataList = (await SharedHelper().readStringList(CachingKey.DELETE_USUAL_MEAL)) ?? [];

    for (String id in deletedDiaryDataList) {
      deleteUsualMeal( mealId: int.parse(id),);
    }

    // Clear locally saved sleep time data after successfully sending to API
    await SharedHelper().removeData(CachingKey.DELETE_USUAL_MEAL);
  }


  Future<MyOtherCaloriesResponse> getOtherCaloreis() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response = await _utils.get("other_calories");
      if (response.data["success"] == true) {
        saveMyOtherCaloriesLocally(MyOtherCaloriesResponse.fromJson(response.data));
        return MyOtherCaloriesResponse.fromJson(response.data);
      } else {
        saveMyOtherCaloriesLocally(MyOtherCaloriesResponse.fromJson(response.data));
        return MyOtherCaloriesResponse.fromJson(response.data);
      }
    }else{

      MyOtherCaloriesResponse? calories = await readMyOtherCaloriesLocally();

      return calories??MyOtherCaloriesResponse();
    }
  }

  // Function to save user data locally
  Future<void> saveMyOtherCaloriesLocally(MyOtherCaloriesResponse myOtherCaloriesResponse) async {
    await SharedHelper().writeData(CachingKey.MY_OTHER_CALORIES, jsonEncode(myOtherCaloriesResponse.toJson()));
  }
  Future<MyOtherCaloriesResponse?> readMyOtherCaloriesLocally() async {
    String? clories = await SharedHelper().readString(CachingKey.MY_OTHER_CALORIES);
    if(clories!=null){
      return MyOtherCaloriesResponse.fromJson(jsonDecode(clories));
    }else{
      return null;
    }
  }

  Future<MyOtherCaloriesUnitsResponse> getOtherCaloriesUnit() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
    Response response = await _utils.get("other_calories_units");
    if (response.data["success"] == true) {
      saveMyOtherCaloriesUnitsLocally(MyOtherCaloriesUnitsResponse.fromJson(response.data));
      return MyOtherCaloriesUnitsResponse.fromJson(response.data);
    } else {
      saveMyOtherCaloriesUnitsLocally(MyOtherCaloriesUnitsResponse.fromJson(response.data));
      return MyOtherCaloriesUnitsResponse.fromJson(response.data);
    }
    }else{

      MyOtherCaloriesUnitsResponse? calories = await readMyOtherCaloriesUnitsLocally();

      return calories??MyOtherCaloriesUnitsResponse();
    }
  }

  // Function to save user data locally
  Future<void> saveMyOtherCaloriesUnitsLocally(MyOtherCaloriesUnitsResponse myOtherCaloriesUnitsResponse) async {
    await SharedHelper().writeData(CachingKey.OTHER_CALORIES_UNITS, jsonEncode(myOtherCaloriesUnitsResponse.toJson()));
  }
  Future<MyOtherCaloriesUnitsResponse?> readMyOtherCaloriesUnitsLocally() async {
    String? meals = await SharedHelper().readString(CachingKey.OTHER_CALORIES_UNITS);
    if(meals!=null){
      return MyOtherCaloriesUnitsResponse.fromJson(jsonDecode(meals));
    }else{
      return null;
    }
  }


  Future<GeneralResponse> deleteCalorie(String endPoint, int id) async {
    FormData body = FormData.fromMap({"id": id});
    Response response = await _utils.post("${endPoint}", body: body);
    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
  }


  // Function to save diary data locally
  Future<void> deleteCalorieLocally(int id) async {
    List<String> dairyDataListJson = (await SharedHelper().readStringList(CachingKey.DELETE_CALORIE)) ?? [];
    dairyDataListJson.add(id.toString());
    await SharedHelper().writeData(CachingKey.DELETE_CALORIE, dairyDataListJson);
  }

// Function to send locally saved diary data to API
  Future<void> sendDeleteCalorie() async {
    List<String> deletedDiaryDataList = (await SharedHelper().readStringList(
        CachingKey.DELETE_CALORIE)) ?? [];

    for (String id in deletedDiaryDataList) {
      deleteCalorie("delete_calories_details", int.parse(id));
    }
  }
  // Function to save diary data locally
  Future<void> deleteOtherCalorieLocally(int id) async {
    List<String> dairyDataListJson = (await SharedHelper().readStringList(CachingKey.DELETE_OTHER_CALORIE)) ?? [];
    dairyDataListJson.add(id.toString());
    await SharedHelper().writeData(CachingKey.DELETE_OTHER_CALORIE, dairyDataListJson);
  }

// Function to send locally saved diary data to API
  Future<void> sendDeleteOtherCalorie() async {
    List<String> deletedDiaryDataList = (await SharedHelper().readStringList(CachingKey.DELETE_OTHER_CALORIE)) ?? [];

    for (String id in deletedDiaryDataList) {
      deleteCalorie("delete_other_calories", int.parse(id));
    }

    // Clear locally saved sleep time data after successfully sending to API
    await SharedHelper().removeData(CachingKey.DELETE_CALORIE);
  }

  Future<GeneralResponse> addOtherCalories(
      {required String? title,
      required String? calPerUnti,
      required int? unit,
      String? unitQuantity,
      String? unitName,
      int? type}) async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
    FormData body = FormData.fromMap({
      "title": title,
      "calorie_per_unit": calPerUnti,
      "unit": unit,
      "unit_qty": unitQuantity,
      "unit_name": unitName,
      "type": type,
    });
    Response response = await _utils.post("new_other_calories", body: body);
    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
    }else{
      createOtherCaloriesLocally(
          OtherMealData(
            title: title,
            calPerUnit: calPerUnti,
            unit: unit,
            unitQuantity: unitQuantity,
            unitName: unitName,
            type: type,
          )
      );
      return GeneralResponse();
    }
  }


// Function to save UsualMeal data locally
  Future<void> createOtherCaloriesLocally(OtherMealData data) async {
    List<String> mealDataListJson = (await SharedHelper().readStringList(CachingKey.OTHER_CALORIES_CREATION)) ?? [];
    mealDataListJson.add(jsonEncode(data.toJson()));
    await SharedHelper().writeData(CachingKey.OTHER_CALORIES_CREATION, mealDataListJson);
  }

// Function to send locally saved UsualMeal data to API
  Future<void> createOtherCaloriesData() async {
    List<String> mealDataList = (await SharedHelper().readStringList(CachingKey.OTHER_CALORIES_CREATION)) ?? [];

    for (String mealDataJson in mealDataList) {
      OtherMealData otherCaloriesData = OtherMealData.fromJson(jsonDecode(mealDataJson));

      if(otherCaloriesData.id ==null){
        await ApiProvider().addOtherCalories(
            title: otherCaloriesData.title,
            calPerUnti: otherCaloriesData.calPerUnit,
            unit: otherCaloriesData.unit,
            unitQuantity: otherCaloriesData.unitQuantity,
            unitName: otherCaloriesData.unitName,
            type: otherCaloriesData.type,
        );
      }
      else{
        await ApiProvider().updateOtherCalories(
          title: otherCaloriesData.title,
          calPerUnti: otherCaloriesData.calPerUnit,
          unit: otherCaloriesData.unit,
          unitQuantity: otherCaloriesData.unitQuantity,
          unitName: otherCaloriesData.unitName,
          type: otherCaloriesData.type,
          id: otherCaloriesData.id,
        );
      }
    }

    // Clear locally saved sleep time data after successfully sending to API
    await SharedHelper().removeData(CachingKey.OTHER_CALORIES_CREATION);
  }


  Future<GeneralResponse> updateOtherCalories(
      {required String? title,
      required String? calPerUnti,
      required int? unit,
      String? unitQuantity,
      String? unitName,
      int? type,
      int? id}) async {
    FormData body = FormData.fromMap({
      "title": title,
      "calorie_per_unit": calPerUnti,
      "unit": unit,
      "unit_qty": unitQuantity,
      "unit_name": unitName,
      "type": type,
    });
    Response response =
        await _utils.post("update_other_calories/$id", body: body);
    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
  }

  Future<SessionDetailsResponse> getSessionDetails(int? id) async {

    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      print("session/$id");
      Response response = await _utils.get("session/$id");
      if (response.data["success"] == true) {
        saveSessionDetailsLocally(SessionDetailsResponse.fromJson(response.data),id!.toString());
        return SessionDetailsResponse.fromJson(response.data);
      } else {
        saveSessionDetailsLocally(SessionDetailsResponse.fromJson(response.data),id!.toString());
        return SessionDetailsResponse.fromJson(response.data);
      }
    }else{
      print("idid$id");
      Map<String, dynamic> existingData = await readSessionDetailsLocally();
      SessionDetailsResponse? sessionDetails;
      if(existingData.containsKey(id.toString())){
        sessionDetails = SessionDetailsResponse.fromJson(existingData[id.toString()]);
      }

      return sessionDetails??SessionDetailsResponse();
    }
  }


  Future<void> saveSessionDetailsLocally(SessionDetailsResponse sessionDetailsResponse, String id) async {
    // Read existing data
    Map<String, dynamic> existingData =
    await readSessionDetailsLocally();

    // Check if the response date exists in the existing data
    if (existingData.containsKey(id)) {
      // Update existing entry for date4
      print("exist");
      existingData[id] = sessionDetailsResponse.toJson();
    } else {
      // If the response date does not exist, add it to the map
      print("Not exist");
      existingData[id] = sessionDetailsResponse.toJson();
    }

    // Save the updated map
    await SharedHelper().writeData(CachingKey.SESSIONS_DETAILS, jsonEncode(existingData));
  }

  Future<Map<String, dynamic>> readSessionDetailsLocally() async {
    String? details = await SharedHelper().readString(CachingKey.SESSIONS_DETAILS);
    if (details != null&&details!='') {
      print(details);
      print(jsonDecode(details));
      return jsonDecode(details);
    } else {
      return {};
    }
  }





  Future<UserResponse> editProfileApi({
    File? image,
    String? password,
    String? name,
    String? lastName,
    String? email,
    String? date,
    String? phone,
    String? password_confirmation,
    String? gender,
  }) async {
    FormData body = FormData.fromMap({
      "image": image == null
          ? null
          : await MultipartFile.fromFile('${image.path}',
              filename: '${image.path}.png'),
      "name": name,
      "last_name": lastName,
      "gender": gender,
      "email": email,
      "phone": phone,
      "date_of_birth": date,
      "password": password,
      "password_confirmation": password_confirmation
    });
    print(body.fields);
    Response response = await _utils.post("update_profile", body: body);
    if (response.data["success"] == true) {
      return UserResponse.fromJson(response.data);
    } else {
      return UserResponse.fromJson(response.data);
    }
  }

  Future<GeneralResponse> signUpApi(
      String id,
      String password,
      String name,
      String lastName,
      String email,
      String date,
      String phone,
      String gender,
      String password_confirmation) async {
    FormData body = FormData.fromMap({
      "patient_id": id,
      "name": name,
      "last_name": lastName,
      "email": email,
      "phone": phone,
      "date_of_birth": date,
      "gender": gender,
      "password": password,
      "password_confirmation": password_confirmation
    });
    print(body.fields);
    Response response = await _utils.post("register", body: body);
    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
  }

  Future<GeneralResponse> sendOrintaionData(
      {String? first_name,
      String? middle_name,
      String? last_name,
      String? mobile,
      String? age,
      String? country,
      String? whats,
      int? hear_from,
      int? target,
      int? package,
      int? id}) async {
    FormData body = FormData.fromMap({
      "first_name": first_name,
      "middle_name": middle_name,
      "last_name": last_name,
      "mobile": mobile,
      "age": age,
      "target": target,
      "country": country,
      "hear_from": hear_from,
      "package": package,
      "whatsapp": whats
    });
    Response response = await _utils.post(
      "orientation_registeration/$id",
      body: body,
    );

    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
  }

  Future<GeneralResponse> createDiaryData({
    required String date,
    String? water,
    int? foodProtine,
    double? qtyProtiene,
    int? workOut,
    String? workout_desc,
    int? randomId,
    String? foodName,
    dynamic caloriesPerUnit,
  }) async {
    print(date);

    FormData body = FormData.fromMap({
      if (water != null) "water": water,
      "date": date,
      if (foodProtine != null) "food": foodProtine,
      if (qtyProtiene != null) "qty": qtyProtiene,
      if (workOut != null) "workout": workOut,
      if (workout_desc != null) "workout_desc": workout_desc,
    });

    final result = await Connectivity().checkConnectivity();
    if (false) {
      Echo("api--> save_calories_details");
      Response response = await _utils.post(
        "save_calories_details",
        body: body,
      );

      if (response.data["success"] == true) {
        return GeneralResponse.fromJson(response.data);
      } else {
        return GeneralResponse.fromJson(response.data);
      }
    }else{
      await saveDiaryDataLocally(DiaryData(
        date: date,
        water: water,
        foodProtine: foodProtine,
        qtyProtiene: qtyProtiene,
        workOut: workOut,
        workoutDesc: workout_desc,
        foodName: foodName,
        caloriesPerUnit: caloriesPerUnit,
        randomId: randomId,
      ));
      return GeneralResponse();
    }
  }



// Function to save diary data locally
  Future<void> saveDiaryDataLocally(DiaryData data) async {
    List<String> dairyDataListJson = (await SharedHelper().readStringList(CachingKey.DAIRY_DATA_LIST)) ?? [];
    bool isExist = false;
    for (String diaryDataJson in dairyDataListJson) {
      DiaryData diaryData = DiaryData.fromJson(jsonDecode(diaryDataJson));
      if(diaryData.randomId==data.randomId){
        isExist = true;
        dairyDataListJson[dairyDataListJson.indexOf(diaryDataJson)] = jsonEncode(data.toJson());
      }

    }
    if(!isExist) {
      dairyDataListJson.add(jsonEncode(data.toJson()));
    }
    await SharedHelper().writeData(CachingKey.DAIRY_DATA_LIST, dairyDataListJson);
  }

// Function to send locally saved diary data to API
//   Future<void> sendSavedDiaryData() async {
//     List<String> diaryDataList = (await SharedHelper().readStringList(CachingKey.DAIRY_DATA_LIST)) ?? [];
//     DayDetailsResponse dayDetailsResponse = await ApiProvider().getDiaryView(DateTime.now().toString().substring(0, 10),true,true);
//
//     List<String> dairySent = [];
//
//     List<DiaryEntry> dairySendList= [];
//
//     for (String diaryDataJson in diaryDataList) {
//       DiaryData diaryData = DiaryData.fromJson(jsonDecode(diaryDataJson));
//
//
//       final result = await Connectivity().checkConnectivity();
//       if (result != ConnectivityResult.none) {
//         dairySent.add(diaryDataJson);
//         if (diaryData.id == null) {
//           if(!dairySendList.any((element) => element.date==diaryData.date)){
//             dairySendList.add(
//                 DiaryEntry(date: diaryData.date, water: '0', food: [], qty: [], createdAt: [])
//             );
//           }
//           if(diaryData.water!=null){
//             dairySendList.firstWhere((element) => element.date==diaryData.date).water = diaryData.water!;
//           }else
//           if(diaryData.workOut!=null){
//             dairySendList.firstWhere((element) => element.date==diaryData.date).workout = diaryData.workOut!;
//             dairySendList.firstWhere((element) => element.date==diaryData.date).workoutDesc = diaryData.workoutDesc??'';
//           }else
//           if(diaryData.foodProtine!=null){
//             if (diaryData.foodProtine != 9999) {
//               dairySendList
//                   .firstWhere((element) => element.date == diaryData.date)
//                   .food
//                   .add(diaryData.foodProtine!);
//
//               dairySendList.firstWhere((element) => element.date==diaryData.date).qty.add(diaryData.qtyProtiene!);
//               dairySendList.firstWhere((element) => element.date==diaryData.date).createdAt.add(diaryData.dateTime!);
//             }else{
//               if (dayDetailsResponse.data!.proteins!.food!.any((
//                   element) => element.title == diaryData.foodName)) {
//                 dairySendList
//                     .firstWhere((element) => element.date == diaryData.date)
//                     .food
//                     .add(dayDetailsResponse.data!.proteins!.food!
//                     .firstWhere((element) =>
//                 element.title == diaryData.foodName).id!);
//
//                 dairySendList.firstWhere((element) => element.date==diaryData.date).qty.add(diaryData.qtyProtiene!);
//                 dairySendList.firstWhere((element) => element.date==diaryData.date).createdAt.add(diaryData.dateTime!);
//
//               }
//               else
//               if (dayDetailsResponse.data!.carbs!.food!.any((element) => element
//                   .title == diaryData.foodName)) {
//                 dairySendList
//                     .firstWhere((element) => element.date == diaryData.date)
//                     .food
//                     .add(diaryData.foodProtine!);
//                 dairySendList
//                     .firstWhere((element) => element.date == diaryData.date)
//                     .food
//                     .add(dayDetailsResponse.data!.carbs!.food!.firstWhere((
//                     element) => element.title == diaryData.foodName).id!);
//
//                 dairySendList.firstWhere((element) => element.date==diaryData.date).qty.add(diaryData.qtyProtiene!);
//                 dairySendList.firstWhere((element) => element.date==diaryData.date).createdAt.add(diaryData.dateTime!);
//               }
//               else
//               if (dayDetailsResponse.data!.fats!.food!.any((element) => element
//                   .title == diaryData.foodName)) {
//                 dairySendList
//                     .firstWhere((element) => element.date == diaryData.date)
//                     .food
//                     .add(dayDetailsResponse.data!.fats!.food!.firstWhere((
//                     element) => element.title == diaryData.foodName).id!);
//
//                 dairySendList.firstWhere((element) => element.date==diaryData.date).qty.add(diaryData.qtyProtiene!);
//                 dairySendList.firstWhere((element) => element.date==diaryData.date).createdAt.add(diaryData.dateTime!);
//               }
//             }
//           }
//           // if (diaryData.foodProtine != 9999) {
//           //
//           //   await ApiProvider().createDiaryData(
//           //     date: diaryData.date,
//           //     water: diaryData.water,
//           //     foodProtine: diaryData.foodProtine,
//           //     qtyProtiene: diaryData.qtyProtiene,
//           //     workOut: diaryData.workOut,
//           //     workout_desc: diaryData.workoutDesc,
//           //   );
//           // }
//           // else {
//           //   if (dayDetailsResponse.data!.proteins!.food!.any((
//           //       element) => element.title == diaryData.foodName)) {
//           //     await ApiProvider().createDiaryData(
//           //       date: diaryData.date,
//           //       water: diaryData.water,
//           //       foodProtine: dayDetailsResponse.data!.proteins!.food!
//           //           .firstWhere((element) =>
//           //       element.title == diaryData.foodName).id,
//           //       qtyProtiene: diaryData.qtyProtiene,
//           //       workOut: diaryData.workOut,
//           //       workout_desc: diaryData.workoutDesc,
//           //     );
//           //   }
//           //   else
//           //   if (dayDetailsResponse.data!.carbs!.food!.any((element) => element
//           //       .title == diaryData.foodName)) {
//           //     await ApiProvider().createDiaryData(
//           //       date: diaryData.date,
//           //       water: diaryData.water,
//           //       foodProtine: dayDetailsResponse.data!.carbs!.food!.firstWhere((
//           //           element) => element.title == diaryData.foodName).id,
//           //       qtyProtiene: diaryData.qtyProtiene,
//           //       workOut: diaryData.workOut,
//           //       workout_desc: diaryData.workoutDesc,
//           //     );
//           //   }
//           //   else
//           //   if (dayDetailsResponse.data!.fats!.food!.any((element) => element
//           //       .title == diaryData.foodName)) {
//           //     await ApiProvider().createDiaryData(
//           //       date: diaryData.date,
//           //       water: diaryData.water,
//           //       foodProtine: dayDetailsResponse.data!.fats!.food!.firstWhere((
//           //           element) => element.title == diaryData.foodName).id,
//           //       qtyProtiene: diaryData.qtyProtiene,
//           //       workOut: diaryData.workOut,
//           //       workout_desc: diaryData.workoutDesc,
//           //     );
//           //   }
//           // }
//         }
//         else {
//           await ApiProvider().editDiaryData(
//             date: diaryData.date,
//             water: diaryData.water,
//             foodProtine: diaryData.foodProtine,
//             qtyProtiene: diaryData.qtyProtiene,
//             workOut: diaryData.workOut,
//             workout_desc: diaryData.workoutDesc,
//             id: diaryData.id,
//           );
//         }
//
//         if(dairySent.isNotEmpty){
//
//             for (DiaryEntry entry in dairySendList) {
//               var formData = FormData.fromMap({
//                 'date': entry.date,
//                 'water': entry.water,
//                 'food[]': entry.food,
//                 'qty[]': entry.qty,
//                 'created_at[]': entry.createdAt,
//                 if(entry.workout!=null)
//                 'workout': entry.workout??'',
//                 if(entry.workout!=null)
//                 'workout_desc': entry.workoutDesc??'',
//               });
//
//               try {
//                   Echo("api--> save_offline_diary");
//                   Response response = await _utils.post(
//                     "save_offline_diary",
//                     body: formData,
//                   );
//
//                   print(response.data);
//                 if (response.data["success"] == true) {
//                   // Remove the successfully sent entry from local storage
//                 }
//               } catch (e) {
//                 // Handle the error, maybe break the loop or log the error
//                 print("Error sending diary entry: $e");
//               }
//             }
//         }
//         // FormData body = FormData.fromMap({
//         //   if (water != null) "water": water,
//         //   "date": date,
//         //   if (foodProtine != null) "food": foodProtine,
//         //   if (qtyProtiene != null) "qty": qtyProtiene,
//         //   if (workOut != null) "workout": workOut,
//         //   if (workout_desc != null) "workout_desc": workout_desc,
//         // });
//         //
//         // final result = await Connectivity().checkConnectivity();
//         // if (result != ConnectivityResult.none) {
//         //   Echo("api--> save_offline_diary");
//         //   Response response = await _utils.post(
//         //     "save_offline_diary",
//         //     body: body,
//         //   );
//         //
//         //   if (response.data["success"] == true) {
//         //     return GeneralResponse.fromJson(response.data);
//         //   } else {
//         //     return GeneralResponse.fromJson(response.data);
//         //   }
//         // }
//
//       }else{
//
//       }
//     }
//
//     dairySent.forEach((element) {
//       if(diaryDataList.contains(element)){
//         diaryDataList.remove(element);
//       }
//     });
//
//     if(diaryDataList.isEmpty){
//       // Clear locally saved sleep time data after successfully sending to API
//       await SharedHelper().removeData(CachingKey.DAIRY_DATA_LIST);
//     }else{
//       await SharedHelper().writeData(CachingKey.DAIRY_DATA_LIST, diaryDataList);
//     }
//
//   }

  Future<void> sendSavedDiaryDataByDay() async {
    Map<String, dynamic> existingData = await readDairyToSendLocally();
    DayDetailsResponse dayDetailsResponse = await ApiProvider().getDiaryView(DateTime.now().toString().substring(0, 10),true,true,true);
    List<DiaryEntry> dairySendList= [];

    for (var key in existingData.keys) {
      print ("Sending local key $key");
      DayDetailsResponse dayDetailsToSend = DayDetailsResponse.fromJson(existingData[key]);
      dairySendList.add(
          DiaryEntry(date: key, water: dayDetailsToSend.data!.water??0, food: [], qty: [], createdAt: [])
      );
      if(dayDetailsToSend.data!.water!=null){
        dairySendList.firstWhere((element) => element.date==key).water = dayDetailsToSend.data!.water!;
      }
      if(dayDetailsToSend.data!.dayWorkouts!=null){
        dairySendList.firstWhere((element) => element.date==key).workout = dayDetailsToSend.data!.workouts!.firstWhere((wItem) => wItem.title==dayDetailsToSend.data!.dayWorkouts!.workoutType).id!;
        dairySendList.firstWhere((element) => element.date==key).workoutDesc = dayDetailsToSend.data!.dayWorkouts == null
            ? " "
            : dayDetailsToSend.data!.dayWorkouts!.workoutDesc!;
      }
      dayDetailsToSend.data!.proteins!.caloriesDetails!.forEach((item) {
        if (dayDetailsResponse.data!.proteins!.food!.any((element) =>
        element.title == item.quality)) {
          dairySendList
              .firstWhere((element) => element.date == key)
              .food
              .add(dayDetailsResponse.data!.proteins!.food!.firstWhere((
              element) => element.title == item.quality).id!);


          dairySendList
              .firstWhere((element) => element.date == key)
              .qty
              .add(item.qty!);
          dairySendList
              .firstWhere((element) => element.date == key)
              .createdAt
              .add(item.createdAt??DateTime.now().toString().substring(0,16));

        }

      });
      dayDetailsToSend.data!.carbs!.caloriesDetails!.forEach((item) {
        if (dayDetailsResponse.data!.carbs!.food!.any((element) =>
        element.title == item.quality)) {
          dairySendList
              .firstWhere((element) => element.date == key)
              .food
              .add(dayDetailsResponse.data!.carbs!.food!.firstWhere((
              element) => element.title == item.quality).id!);


          dairySendList
              .firstWhere((element) => element.date == key)
              .qty
              .add(item.qty!);
          dairySendList
              .firstWhere((element) => element.date == key)
              .createdAt
              .add(item.createdAt??DateTime.now().toString().substring(0,16));

        }

      });

      dayDetailsToSend.data!.fats!.caloriesDetails!.forEach((item) {
        if (dayDetailsResponse.data!.fats!.food!.any((element) =>
        element.title == item.quality)) {
          dairySendList
              .firstWhere((element) => element.date == key)
              .food
              .add(dayDetailsResponse.data!.fats!.food!.firstWhere((
              element) => element.title == item.quality).id!);


          dairySendList
              .firstWhere((element) => element.date == key)
              .qty
              .add(item.qty!);
          dairySendList
              .firstWhere((element) => element.date == key)
              .createdAt
              .add(item.createdAt??DateTime.now().toString().substring(0,16));

        }

      });

    }


    for (DiaryEntry entry in dairySendList) {
      var formData = FormData.fromMap({
        'date': entry.date,
        'water': entry.water,
        if(entry.workout!=null)
          'workout': entry.workout??'',
        if(entry.workout!=null)
          'workout_desc': entry.workoutDesc??'',
      });
      for(int i=0;i<entry.food.length;i++){
        formData.fields.add(MapEntry('food[$i]', entry.food[i].toString()));
        formData.fields.add(MapEntry('qty[$i]', entry.qty[i].toString()));
        formData.fields.add(MapEntry('created_at[$i]', entry.createdAt[i].toString()));
      }
      print('formData.fields');
      print(formData.fields);

      try {
        Echo("api--> save_offline_diary");
        Response response = await _utils.post(
          "save_offline_diary",
          body: formData,
        );

        print(response.data);
        if (response.data["success"] == true) {
          // Remove the successfully sent entry from local storage
        }
      } catch (e) {
        // Handle the error, maybe break the loop or log the error
        print("Error sending diary entry: $e");
      }
    }


    await SharedHelper().removeData(CachingKey.DAIRY_TO_SEND);

  }



  // Function to save diary data locally
  Future<void> removeCashedDiaryDataLocally(int randomId) async {
    int? index;
    List<String> dairyDataListJson = (await SharedHelper().readStringList(CachingKey.DAIRY_DATA_LIST)) ?? [];
    for (String diaryDataJson in dairyDataListJson) {
      DiaryData diaryData = DiaryData.fromJson(jsonDecode(diaryDataJson));
      print("DELETE >> ${diaryData.randomId} $randomId");
      if(diaryData.randomId==randomId){
        index = dairyDataListJson.indexOf(diaryDataJson);
      }

    }
    if(index!=null) {
      dairyDataListJson.removeAt(index);
    }
    await SharedHelper().writeData(CachingKey.DAIRY_DATA_LIST, dairyDataListJson);
  }

  Future<GeneralResponse> editDiaryData({
    required String date,
    String? water,
    int? foodProtine,
    double? qtyProtiene,
    int? workOut,
    String? workout_desc,
    int? id,
  }) async {
    print(date);
    FormData body = FormData.fromMap({
      "water": water,
      "date": date,
      "food": foodProtine,
      "qty": qtyProtiene,
      "workout": workOut,
      "workout_desc": workout_desc,
    });
    Echo("${body}");
    Echo("api--> update_calories_details/$id");

    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
    Response response = await _utils.post(
      "update_calories_details/$id",
      body: body,
    );

    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
    }else{
      await saveDiaryDataLocally(DiaryData(
        date: date,
        water: water,
        foodProtine: foodProtine,
        qtyProtiene: qtyProtiene,
        workOut: workOut,
        workoutDesc: workout_desc,
        id: id,
      ));
      return GeneralResponse();

    }
  }

  Future<MealFeatureHomeResponse> getMealFeaturesHome() async {
    Response response = await _utils.post(
      "meals_features_home",
    );
    if (response.statusCode == 200) {
      return MealFeatureHomeResponse.fromJson(response.data);
    } else {
      return MealFeatureHomeResponse.fromJson(response.data);
    }
  }

  Future<CheerFullResponse> getCheerFullStatus() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
    Response response = await _utils.post(
      "meals_features_status",
    );
    print("meals_features_status");
    if (response.statusCode == 200) {
      saveCheerFullLocally(CheerFullResponse.fromJson(response.data));
      return CheerFullResponse.fromJson(response.data);
    } else {
      saveCheerFullLocally(CheerFullResponse.fromJson(response.data));
      return CheerFullResponse.fromJson(response.data);
    }
    }else{
      CheerFullResponse? meals = await readCheerFullLocally();
      log('meals ${meals}');

      return meals??CheerFullResponse();
    }
  }
  // Function to save user data locally
  Future<void> saveCheerFullLocally(CheerFullResponse cheerFullResponse) async {
    await SharedHelper().writeData(CachingKey.CHEER_FULL, jsonEncode(cheerFullResponse.toJson()));
  }
  Future<CheerFullResponse?> readCheerFullLocally() async {
    String? meals = await SharedHelper().readString(CachingKey.CHEER_FULL);
    if(meals!=null){
      return CheerFullResponse.fromJson(jsonDecode(meals));
    }else{
      return null;
    }
  }

  Future<bool> getFaqStatus() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response =  await _utils.post(
        "faq_status",
      );
      if (response.statusCode == 200) {
        await SharedHelper().writeData(
            CachingKey.FAQ_STATUS, response.data['data']['show_faq_page']);

        return response.data['data']['show_faq_page'];
      } else {
        await SharedHelper().writeData(
            CachingKey.FAQ_STATUS, response.data['data']['show_faq_page']);
        return response.data['data']['show_faq_page'];
      }
    } else{
      bool? status = await SharedHelper().readBoolean(CachingKey.FAQ_STATUS);

      return status??false;
  }
  }

  Future<MealFeatureStatusResponse> getMealFeaturesStatus() async {
    Response response = await _utils.post(
      "meals_features_status",
    );
    if (response.statusCode == 200) {

      return MealFeatureStatusResponse.fromJson(response.data);
    } else {
      return MealFeatureStatusResponse.fromJson(response.data);
    }
  }

  Future<bool> getOrientationVideosStatusStatus() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response = await _utils.post(
        "orientation_videos_status",
      );
      if (response.statusCode == 200) {
        await SharedHelper().writeData(
            CachingKey.ORIENTATION_VIDEOS_STATUS, response.data['data']['orientation_videos_status']);
        return response.data['data']['orientation_videos_status'];
      } else {
        await SharedHelper().writeData(
            CachingKey.ORIENTATION_VIDEOS_STATUS, response.data['data']['orientation_videos_status']);
        return response.data['data']['orientation_videos_status'];
      }
    }else{
      bool? status = await SharedHelper().readBoolean(CachingKey.ORIENTATION_VIDEOS_STATUS);
      return status??false;
    }
  }

  Future<MealFoodListResponse> getMealFoodList() async {
    Response response = await _utils.post(
      "meals_food_list",
    );
    Echo(response.data.toString());
    if (response.statusCode == 200) {
      return MealFoodListResponse.fromJson(response.data);
    } else {
      return MealFoodListResponse.fromJson(response.data);
    }
  }

  Future<bool> createNewMeal({
    required String name,
    required String foodIds,
    required String amountsId,
    required String note,
  }) async {
    String deviceId = await kDeviceInfo();
    FormData body = FormData.fromMap({
      "name": name,
      "food": foodIds,
      "amount": amountsId,
      "note": note,
      'device_id': deviceId,
    });
    Response response = await _utils.post("new_meal", body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateNewMeal({
    required String id,
    required String name,
    required String foodIds,
    required String amountsId,
    required String note,
  }) async {
    String deviceId = await kDeviceInfo();
    FormData body = FormData.fromMap({
      "name": name,
      "food": foodIds,
      "amount": amountsId,
      "note": note,
      'device_id': deviceId,
    });

    Response response = await _utils.post("update_meal/$id", body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<BasicResponse> deleteMeal({
    required String id,
  }) async {
    String deviceId = await kDeviceInfo();
    FormData body = FormData.fromMap({
      'device_id': deviceId,
    });
    Response response = await _utils.post("delete_meal/$id", body: body);
    if (response.statusCode == 200) {
      return BasicResponse.fromJson(response.data);
    } else {
      return BasicResponse.fromJson(response.data);
    }
  }

  Future<MyMealResponse> getMyMeals() async {
    String deviceId = await kDeviceInfo();
    FormData body = FormData.fromMap({
      'device_id': deviceId,
    });
    Response response = await _utils.post("my_meals", body: body);
    print('-------> ${response.data}');
    if (response.statusCode == 200 && response.data['success'] == true) {
      return MyMealResponse.fromJson(response.data);
    } else {
      return Future.error(response.data['message']);
    }
  }

  Future<MealDetailsResponse> getMealDetails({
    required String id,
  }) async {
    String deviceId = await kDeviceInfo();
    FormData body = FormData.fromMap({
      'device_id': deviceId,
    });
    Response response = await _utils.post("meal_details/$id", body: body);
    if (response.statusCode == 200) {
      return MealDetailsResponse.fromJson(response.data);
    } else {
      return MealDetailsResponse.fromJson(response.data);
    }
  }

  Future<String> createShoppingCart({
    required String name,
    required String lastName,
    required String phone,
    required String email,
    required String address,
    required String latitude,
    required String longitude,
    required String meals,
    required String deliveryMethod,
    required String payMethod,
    required String qtys,
  }) async {
    Echo("meals $meals");
    try {
      String deviceId = await kDeviceInfo();
      FormData body = FormData.fromMap({
        'name': name,
        'last_name': lastName,
        'phone': phone,
        'email': email,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'meals': meals,
        'device_id': deviceId,
        'qtys': qtys,
      });
      Response response = await _utils.post("create_shopping_cart", body: body);
      if (response.statusCode == 200) {
        if (response.data['success'] == false) {
          Get.snackbar(Strings().notification, response.data['message']);
        }
        String id = '${response.data['data']['cart']['id']}';
        FormData body2 = FormData.fromMap({
          'delivery_method': deliveryMethod,
          'device_id': deviceId,
          'pay_method': payMethod,
        });
        Response checkOutResponse =
            await _utils.post("checkout/$id", body: body2);
        if (checkOutResponse.statusCode == 200) {
          return payMethod == "visa"
              ? checkOutResponse.data['payment_url']
              : "";
        } else {
          print("Error Checkout!!");
          return "";
        }
      } else
        return response.data;
    } catch (e) {
      Echo('error $e');
      return Future.error(e);
    }
  }

  Future<MyOrdersResponse> myOrders() async {
    String deviceId = await kDeviceInfo();
    try {
      Response response = await _utils.post(
        "my_orders?device_id=$deviceId ",
      );
      if (response.statusCode == 200) {
        return MyOrdersResponse.fromJson(response.data);
      } else
        return Future.error("server");
    } catch (e) {
      Echo('error $e');
      return Future.error(e);
    }
  }

  Future<String> kDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String userId = "";
    String phone = "";
    userId = await SharedHelper().readString(CachingKey.USER_ID);
    bool isGuestLogin = false;
    bool isGuest = false;
    isGuestLogin = await SharedHelper().readBoolean(CachingKey.IS_GUEST_SAVED);
    isGuest = await SharedHelper().readBoolean(CachingKey.IS_GUEST);
    phone = await SharedHelper().readString(CachingKey.PHONE);
    String deviceId = "";
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (isGuest) {
        deviceId = isGuestLogin
            ? '${androidInfo.id}${androidInfo.brand} ${androidInfo.device} ${androidInfo.model}${phone}'
            : "";
      } else if (!isGuest) {
        deviceId =
            '${androidInfo.id}${androidInfo.brand} ${androidInfo.device} ${androidInfo.model}${userId}';
      }
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if (isGuest) {
        deviceId =
            isGuestLogin ? '${iosInfo.name}${iosInfo.model}${phone}' : '';
      } else if (!isGuest) {
        deviceId = '${iosInfo.name}${iosInfo.model}${userId}';
      }
    }
    isGuest
        ? Echo('Guest deviceId = ${deviceId.replaceAll(' ', '')}')
        : Echo('User deviceId = ${deviceId.replaceAll(' ', '')}');
    print("1 user id $userId");
    print("2 is guest $isGuest");
    print(
        "3 is guest saved? $isGuestLogin + ${await SharedHelper().readString(CachingKey.PHONE)}");
    print("3 is guest saved? $isGuestLogin + ${phone}");
    return deviceId.replaceAll(' ', '');
  }

  Future<String> kDeviceToken() async {
    String? token;
    token = await FirebaseMessaging.instance.getToken();
    return token ?? "";
  }

  Future<VersionResponse> kAppVersion() async {
    FormData body = FormData.fromMap({
      'type': 'production',
      'platform': Platform.isAndroid ? 'android' : 'ios',
      'version': Platform.isAndroid
          ? StringConst.APP_Android_VERSION
          : StringConst.APP_IOS_VERSION,
    });
    Response response = await _utils.post("api_version", body: body);
    if (response.data["success"] == true) {
      return VersionResponse.fromJson(response.data);
    } else {
      return VersionResponse.fromJson(response.data);
    }
  }

  Future<CheerfulSocialsResponse> getCheerfulSocialsResponse() async {
    Response response = await _utils.get("cheerful_social");
    if (response.statusCode == 200) {
      return CheerfulSocialsResponse.fromJson(response.data);
    } else {
      return CheerfulSocialsResponse.fromJson(response.data);
    }
  }

  Future<PackagePaymentResponse> packagePayment({
    required String name,
    required String lastName,
    required String phone,
    required String email,
    required int packageId,
    required String payMethod,
    required bool isGuest,
  }) async {
    if (isGuest == true)
      await SharedHelper().writeData(CachingKey.PHONE, phone);
    if (isGuest == true)
      await SharedHelper().writeData(CachingKey.IS_GUEST_SAVED, true);
    if (isGuest == true)
      await SharedHelper().writeData(CachingKey.USER_LAST_NAME, lastName);
    if (isGuest == true)
      await SharedHelper().writeData(CachingKey.EMAIL, email);
    if (isGuest == true)
      await SharedHelper().writeData(CachingKey.USER_NAME, name);
    String deviceId = await kDeviceInfo();
    FormData body = FormData.fromMap({
      "name": name,
      "last_name": lastName,
      "phone": phone,
      "email": email,
      "device_id": deviceId,
      "pay_method": payMethod,
    });
    Response response =
        await _utils.post("book-service-package/$packageId", body: body);
    if (response.data["success"] == true) {
      return PackagePaymentResponse.fromJson(response.data);
    } else {
      return PackagePaymentResponse.fromJson(response.data);
    }
  }

  Future<PackageDetailsResponse> paymentPackageDetails({
    required int packageId,
  }) async {
    String deviceId = await kDeviceInfo();
    Response response = await _utils.get(
      "service-package-order/$packageId?device_id=$deviceId",
    );
    print("Device id =>>$packageId");
    print("Device id =>>$deviceId");

    if (response.data["success"] == true) {
      return PackageDetailsResponse.fromJson(response.data);
    } else {
      return PackageDetailsResponse.fromJson(response.data);
    }
  }

  Future<MyPackagesResponse> myPackagesResponse() async {
    String deviceId = await kDeviceInfo();
    try {
      Response response = await _utils.get(
        "service-package-orders?device_id=$deviceId",
      );
      if (response.statusCode == 200) {
        MyPackagesResponse myPackagesResponse =
            MyPackagesResponse.fromJson(response.data);
        return myPackagesResponse;
      } else
        return Future.error("server");
    } catch (e) {
      Echo('error $e');
      return Future.error(e);
    }
  }

  Future<OrientationVideosResponse> getOrientationVideos() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response = await _utils.get("orientation_videos");
      if (response.statusCode == 200) {
        saveOrientationVideosLocally(OrientationVideosResponse.fromJson(response.data));
        return OrientationVideosResponse.fromJson(response.data);
      } else {
        saveOrientationVideosLocally(OrientationVideosResponse.fromJson(response.data));
        return OrientationVideosResponse.fromJson(response.data);
      }
    }else{

      OrientationVideosResponse? orientationVideosResponse = await readOrientationVideosLocally();

      return orientationVideosResponse??OrientationVideosResponse();
    }
  }

  // Function to save About data locally
  Future<void> saveOrientationVideosLocally(OrientationVideosResponse orientationVideosResponse) async {
    await SharedHelper().writeData(CachingKey.ORIENTATION_VIDEOS, jsonEncode(orientationVideosResponse.toJson()));
  }
  Future<OrientationVideosResponse?> readOrientationVideosLocally() async {
    String? home = await SharedHelper().readString(CachingKey.ORIENTATION_VIDEOS);
    if(home!=null){
      return OrientationVideosResponse.fromJson(jsonDecode(home));
    }else{
      return null;
    }
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



class DiaryData {
  final String date;
  final String? water;
  final int? foodProtine;
  final double? qtyProtiene;
  final int? workOut;
  final String? workoutDesc;
  final int? randomId;
  final int? id;
  final String? foodName;
  final String? dateTime;
  dynamic caloriesPerUnit;

  DiaryData({
    required this.date,
    this.water,
    this.foodProtine,
    this.qtyProtiene,
    this.workOut,
    this.workoutDesc,
    this.randomId,
    this.id,
    this.foodName,
    this.dateTime,
    this.caloriesPerUnit,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'water': water,
      'foodProtine': foodProtine,
      'qtyProtiene': qtyProtiene,
      'workOut': workOut,
      'workoutDesc': workoutDesc,
      'randomId': randomId,
      'id': id,
      'foodName': foodName,
      'caloriesPerUnit': caloriesPerUnit,
      'dateTime': DateTime.now().toString().substring(0,16),
    };
  }

  factory DiaryData.fromJson(Map<String, dynamic> json) {
    return DiaryData(
      date: json['date'],
      water: json['water'],
      foodProtine: json['foodProtine'],
      qtyProtiene: json['qtyProtiene'],
      workOut: json['workOut'],
      workoutDesc: json['workoutDesc'],
      randomId: json['randomId'],
      id: json['id'],
      foodName: json['foodName'],
      dateTime: json['dateTime'],
      caloriesPerUnit: json['caloriesPerUnit'],
    );
  }
}

class UsualMealData {
  final String name;
  final String? foodId;
  final String? qty;
  final int? id;

  UsualMealData({
    required this.name,
    this.foodId,
    this.qty,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'food_id': foodId,
      'qty': qty,
      'id': id,
    };
  }

  factory UsualMealData.fromJson(Map<String, dynamic> json) {
    return UsualMealData(
      name: json['name'],
      foodId: json['food_id'],
      qty: json['qty'],
      id: json['id'],
    );
  }
}

class OtherMealData {
  final String? title;
  final String? calPerUnit;
  final int? unit;
  final String? unitQuantity;
  final String? unitName;
  final int? type;
  final int? id;

  OtherMealData({
    required this.title,
    required this.calPerUnit,
    required this.unit,
    this.unitQuantity,
    this.unitName,
    this.type,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'calPerUnti': calPerUnit,
      'unit': unit,
      'unitQuantity': unitQuantity,
      'unitName': unitName,
      'type': type,
      'id': id,
    };
  }

  factory OtherMealData.fromJson(Map<String, dynamic> json) {
    return OtherMealData(
      title: json['title'],
      calPerUnit: json['calPerUnti'],
      unit: json['unit'],
      unitQuantity: json['unitQuantity'],
      unitName: json['unitName'],
      type: json['type'],
      id: json['id'],
    );
  }


}

class DiaryEntry {
  String date;
  int water;
  List<int> food;
  List<double> qty;
  List<String> createdAt;
  int? workout;
  String? workoutDesc;

  DiaryEntry({
    required this.date,
    required this.water,
    required this.food,
    required this.qty,
    required this.createdAt,
    this.workout,
    this.workoutDesc,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'water': water,
      'food': food,
      'qty': qty,
      'created_at': createdAt,
      'workout': workout,
      'workout_desc': workoutDesc,
    };
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      date: json['date'],
      water: json['water'],
      food: List<int>.from(json['food']),
      qty: List<double>.from(json['qty']),
      createdAt: List<String>.from(json['created_at']),
      workout: json['workout'],
      workoutDesc: json['workout_desc'],
    );
  }
}