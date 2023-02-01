import 'dart:developer';
import 'dart:io';

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
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/const_strings.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:app/app/widgets/app_dialog.dart';
import 'package:app/globale_controller.dart';
// import 'package:dio/dio.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;

class ApiProvider {
  NetworkUtil _utils = new NetworkUtil();

  Future<HomePageResponse> getHomeData() async {
    Response response = await _utils.get("home");
    if (response.statusCode == 200) {
      return HomePageResponse.fromJson(response.data);
    } else {
      return HomePageResponse.fromJson(response.data);
    }
  }

  Future<MessagesResponse> getMessagesData() async {
    Response response = await _utils.get("messages");
    if (response.statusCode == 200) {
      return MessagesResponse.fromJson(response.data);
    } else {
      return MessagesResponse.fromJson(response.data);
    }
  }

  Future<TransformationsResponse> getTransformationData() async {
    Response response = await _utils.get("transformations");
    if (response.statusCode == 200) {
      return TransformationsResponse.fromJson(response.data);
    } else {
      return TransformationsResponse.fromJson(response.data);
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

  Future<AboutResponse> getAboutData() async {
    Response response = await _utils.get("about");
    if (response.statusCode == 200) {
      return AboutResponse.fromJson(response.data);
    } else {
      return AboutResponse.fromJson(response.data);
    }
  }

  Future<ContactResponse> getContactData() async {
    Response response = await _utils.get("contact");
    if (response.statusCode == 200) {
      return ContactResponse.fromJson(response.data);
    } else {
      return ContactResponse.fromJson(response.data);
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
    print("FCM Token  =$deviceToken");
    FormData body = FormData.fromMap({
      'patient_id': id,
      'password': password,
      'device_id': deviceId,
      'fcm_token': deviceToken,
    });
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

  Future<UserResponse> getProfile() async {
    String deviceId = await kDeviceInfo();
    String deviceToken = await kDeviceToken();
    print("FCM Token  =$deviceToken");
    final GlobalController globalController =
        getx.Get.find<GlobalController>(tag: 'global');
    Echo('getProfile getProfile');
    Response response =
        await _utils.get("profile?device_id==$deviceId&fcm_token=$deviceToken");
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
              globalController.removeNotificaitonCount.value = true;
              getx.Get.back();
              getx.Get.toNamed(Routes.NOTIFICATIONS);
            },
            cancelText: '',
            confirmText: 'Check it',
          );
        }
      }

      return ur;
    } else {
      UserResponse ur = UserResponse.fromJson(response.data);
      if (globalController.shoNewMessage.value) {
        if (ur.data != null &&
            ur.data!.newMessages != null &&
            ur.data!.newMessages! > 0) {
          globalController.shoNewMessage.value = false;
        }
      }

      return ur;
    }
  }

  Future<SessionResponse> getSessions() async {
    Response response = await _utils.get("sessions");
    if (response.data["success"] == true) {
      return SessionResponse.fromJson(response.data);
    } else {
      return SessionResponse.fromJson(response.data);
    }
  }

  Future<ServicesResponse> getServices() async {
    Response response = await _utils.get("services");
    if (response.data["success"] == true) {
      return ServicesResponse.fromJson(response.data);
    } else {
      return ServicesResponse.fromJson(response.data);
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

  Future<DayDetailsResponse> getDiaryView(String? date) async {
    print('date ====>$date');
    Response response = await _utils.get("calories_day_details?date=$date");
    log('api->calories_day_details?date=$date');
    log('response ${response.data}');
    if (response.data["success"] == true) {
      return DayDetailsResponse.fromJson(response.data);
    } else {
      return DayDetailsResponse.fromJson(response.data);
    }
  }

  Future<MyOtherCaloriesResponse> getOtherCaloreis() async {
    Response response = await _utils.get("other_calories");
    if (response.data["success"] == true) {
      return MyOtherCaloriesResponse.fromJson(response.data);
    } else {
      return MyOtherCaloriesResponse.fromJson(response.data);
    }
  }

  Future<MyOtherCaloriesUnitsResponse> getOtherCaloriesUnit() async {
    Response response = await _utils.get("other_calories_units");
    if (response.data["success"] == true) {
      return MyOtherCaloriesUnitsResponse.fromJson(response.data);
    } else {
      return MyOtherCaloriesUnitsResponse.fromJson(response.data);
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

  Future<GeneralResponse> addOtherCalories(
      {required String? title,
      required String? calPerUnti,
      required int? unit,
      String? unitQuantity,
      String? unitName,
      int? type}) async {
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
    print("session/$id");
    Response response = await _utils.get("session/$id");
    if (response.data["success"] == true) {
      return SessionDetailsResponse.fromJson(response.data);
    } else {
      return SessionDetailsResponse.fromJson(response.data);
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
      String password_confirmation) async {
    FormData body = FormData.fromMap({
      "patient_id": id,
      "name": name,
      "last_name": lastName,
      "email": email,
      "phone": phone,
      "date_of_birth": date,
      "password": password,
      "password_confirmation": password_confirmation
    });
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

    Response response = await _utils.post(
      "update_calories_details/$id",
      body: body,
    );

    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
  }

  Future<MealFeatureHomeResponse> getMealFeaturesHome() async {
    String deviceId = await kDeviceInfo();
    FormData body = FormData.fromMap({
      'device_id': deviceId,
    });
    Response response = await _utils.post("meals_features_home", body: body);
    if (response.statusCode == 200) {
      return MealFeatureHomeResponse.fromJson(response.data);
    } else {
      return MealFeatureHomeResponse.fromJson(response.data);
    }
  }

  Future<CheerFullResponse> getCheerFullStatus() async {
    String deviceId = await kDeviceInfo();
    FormData body = FormData.fromMap({
      'device_id': deviceId,
    });
    Response response = await _utils.post("meals_features_status", body: body);
    if (response.statusCode == 200) {
      return CheerFullResponse.fromJson(response.data);
    } else {
      return CheerFullResponse.fromJson(response.data);
    }
  }

  Future<CheerFullResponse> getFaqStatus() async {
    String deviceId = await kDeviceInfo();
    FormData body = FormData.fromMap({
      'device_id': deviceId,
    });
    Response response = await _utils.post("faq_status", body: body);
    if (response.statusCode == 200) {
      return CheerFullResponse.fromJson(response.data);
    } else {
      return CheerFullResponse.fromJson(response.data);
    }
  }

  Future<MealFeatureStatusResponse> getMealFeaturesStatus() async {
    String deviceId = await kDeviceInfo();
    FormData body = FormData.fromMap({
      'device_id': deviceId,
    });
    Response response = await _utils.post("meals_features_status", body: body);
    if (response.statusCode == 200) {
      return MealFeatureStatusResponse.fromJson(response.data);
    } else {
      return MealFeatureStatusResponse.fromJson(response.data);
    }
  }

  Future<MealFoodListResponse> getMealFoodList() async {
    String deviceId = await kDeviceInfo();
    FormData body = FormData.fromMap({
      'device_id': deviceId,
    });
    Response response = await _utils.post("meals_food_list", body: body);
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

    Echo("createNewMeal name $name");
    Echo("createNewMeal food $foodIds");
    Echo("createNewMeal amount $amountsId");
    Echo("createNewMeal note $note");
    Echo("createNewMeal device_id $deviceId");

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
    print('-------> my_meals');
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
        "my_orders?device_id=$deviceId",
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
    String deviceId = "";
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId =
          '${androidInfo.id}${androidInfo.brand} ${androidInfo.device} ${androidInfo.model}';
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId =
          '${iosInfo.identifierForVendor}${iosInfo.utsname.machine}${iosInfo.utsname.version}${iosInfo.utsname.sysname}';
    }
    print("deviceId $deviceId");
    Echo('deviceId = ${deviceId.replaceAll(' ', '')}');
    return deviceId.replaceAll(' ', '');
  }

  Future<String> kDeviceToken() async {
    String? token;
    token = await FirebaseMessaging.instance.getToken();
    return token??"";
  }

  Future<VersionResponse> kAppVersion() async {
    FormData body = FormData.fromMap({
      'type': 'production',
      'platform': Platform.isAndroid ? 'android' : 'ios',
      'version': Platform.isAndroid
          ? StringConst.APP_Android_VERSION
          : StringConst.APP_IOS_VERSION, //Updated 09/10/2022
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
  }) async {
    String deviceId = await kDeviceInfo();

    FormData body = FormData.fromMap({
      "name": name,
      "last_name": lastName,
      "phone": phone,
      "email": email,
      "device_id": deviceId,
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
    Response response = await _utils.get("orientation_videos");
    if (response.statusCode == 200) {
      return OrientationVideosResponse.fromJson(response.data);
    } else {
      return OrientationVideosResponse.fromJson(response.data);
    }
  }
}
