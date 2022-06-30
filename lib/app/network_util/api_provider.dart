import 'dart:io';

import 'package:app/app/models/about_response.dart';
import 'package:app/app/models/basic_response.dart';
import 'package:app/app/models/cheer_full_response.dart';
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
import 'package:app/app/models/mymeals_response.dart';
import 'package:app/app/models/orintation_response.dart';
import 'package:app/app/models/other_calories_units_repose.dart';
import 'package:app/app/models/session_response.dart';
import 'package:app/app/models/sessions_details_response.dart';
import 'package:app/app/models/transformation_response.dart';
import 'package:app/app/models/user_response.dart';
import 'package:app/app/models/version_response.dart';
import 'package:app/app/network_util/network.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/globale_controller.dart';
// import 'package:dio/dio.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:google_fonts/google_fonts.dart';
import 'package:yaml/yaml.dart';

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

  Future<GeneralResponse> sendContactData(String name, String email, String phone, String subject, String message) async {
    FormData body = FormData.fromMap({'name': name, 'email': email, 'phone': phone, 'subject': subject, 'message': message});
    Response response = await _utils.post("contact_form", body: body);
    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
  }

  Future<UserResponse> login(String id, String password) async {
    FormData body = FormData.fromMap({'patient_id': id, 'password': password});
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
    FormData body = FormData.fromMap({'password': password, 'password_confirmation': confirmPassword});
    Response response = await _utils.post("change_password", body: body);
    if (response.data["success"] == true) {
      return UserResponse.fromJson(response.data);
    } else {
      return UserResponse.fromJson(response.data);
    }
  }

  Future<UserResponse> getProfile() async {
    final GlobalController globalController = getx.Get.find<GlobalController>(tag: 'global');
    Echo('getProfile getProfile');
    Response response = await _utils.get("profile");
    if (response.data["success"] == true) {
      UserResponse ur = UserResponse.fromJson(response.data);
      if (globalController.shoNewMessage.value) {
        if (ur.data != null && ur.data!.newMessages != null && ur.data!.newMessages! > 0) {
          globalController.shoNewMessage.value = false;

          getx.Get.dialog(WillPopScope(
            onWillPop: () async {
              return globalController.canDismissNewMessageDialog.value;
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 16),
                      kTextHeader("Notification"),
                      SizedBox(height: 6),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          color: Color(0xffF6F6F6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300]!,
                              blurRadius: 3,
                              spreadRadius: 1,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                        child: Text('You have a new message from Dr/ Ramy Mansour'),
                      ),
                      SizedBox(height: 14),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            globalController.canDismissNewMessageDialog.value = true;
                            getx.Get.back();
                            getx.Get.toNamed(Routes.NOTIFICATIONS);
                          },
                          child: Container(
                            width: getx.Get.width / 1.6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: kColorPrimary),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Check it',
                                  style: GoogleFonts.cairo(
                                    fontSize: 14.0,
                                    color: const Color(0xFF7FC902),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ));
        }
      }

      return ur;
    } else {
      UserResponse ur = UserResponse.fromJson(response.data);
      if (globalController.shoNewMessage.value) {
        if (ur.data != null && ur.data!.newMessages != null && ur.data!.newMessages! > 0) {
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

  Future<DayDetailsResponse> getDiaryView(String? date) async {
    Response response = await _utils.get("calories_day_details?date=$date");
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

  Future<GeneralResponse> addOtherCalories({required String? title, required String? calPerUnti, required int? unit, String? unitQuantity, String? unitName, int? type}) async {
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

  Future<GeneralResponse> updateOtherCalories({required String? title, required String? calPerUnti, required int? unit, String? unitQuantity, String? unitName, int? type, int? id}) async {
    FormData body = FormData.fromMap({
      "title": title,
      "calorie_per_unit": calPerUnti,
      "unit": unit,
      "unit_qty": unitQuantity,
      "unit_name": unitName,
      "type": type,
    });
    Response response = await _utils.post("update_other_calories/$id", body: body);
    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
  }

  Future<SessionDetailsResponse> getSessionDetails(int? id) async {
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
    String? email,
    String? date,
    String? phone,
    String? password_confirmation,
    String? gender,
  }) async {
    FormData body = FormData.fromMap({"image": image == null ? null : await MultipartFile.fromFile('${image.path}', filename: '${image.path}.png'), "name": name, "gender": gender, "email": email, "phone": phone, "date_of_birth": date, "password": password, "password_confirmation": password_confirmation});
    Response response = await _utils.post("update_profile", body: body);
    if (response.data["success"] == true) {
      return UserResponse.fromJson(response.data);
    } else {
      return UserResponse.fromJson(response.data);
    }
  }

  Future<GeneralResponse> signUpApi(String id, String password, String name, String email, String date, String phone, String password_confirmation) async {
    FormData body = FormData.fromMap({"patient_id": id, "name": name, "email": email, "phone": phone, "date_of_birth": date, "password": password, "password_confirmation": password_confirmation});
    Response response = await _utils.post("register", body: body);
    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
  }

  Future<GeneralResponse> sendOrintaionData({String? first_name, String? middle_name, String? last_name, String? mobile, String? age, String? country, String? whats, int? hear_from, int? target, int? package, int? id}) async {
    FormData body = FormData.fromMap({"first_name": first_name, "middle_name": middle_name, "last_name": last_name, "mobile": mobile, "age": age, "target": target, "country": country, "hear_from": hear_from, "package": package, "whatsapp": whats});
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

  Future<GeneralResponse> updateDiaryData({required String date, String? water, int? foodProtine, double? qtyProtiene, int? workOut, String? workout_desc}) async {
    print(date);
    FormData body = FormData.fromMap({
      "water": water,
      "date": date,
      "food": foodProtine,
      "qty": qtyProtiene,
      "workout": workOut,
      "workout_desc": workout_desc,
    });
    print("${body}");

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

  Future<GeneralResponse> editDiaryData({required String date, String? water, int? foodProtine, double? qtyProtiene, int? workOut, String? workout_desc, int? id}) async {
    print(date);
    FormData body = FormData.fromMap({
      "water": water,
      "date": date,
      "food": foodProtine,
      "qty": qtyProtiene,
      "workout": workOut,
      "workout_desc": workout_desc,
    });
    print("${body}");

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

  Future<bool> createShoppingCart({
    required String name,
    required String phone,
    required String email,
    required String address,
    required String latitude,
    required String longitude,
    required String meals,
    required String deliveryMethod,
  }) async {
    Echo("meals $meals");
    try {
      String deviceId = await kDeviceInfo();
      FormData body = FormData.fromMap({
        'name': name,
        'phone': phone,
        'email': email,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'meals': meals,
        'device_id': deviceId,
      });
      Response response = await _utils.post("create_shopping_cart", body: body);
      if (response.statusCode == 200) {
        String id = '${response.data['data']['cart']['id']}';
        FormData body2 = FormData.fromMap({
          'delivery_method': deliveryMethod,
          'device_id': deviceId,
        });
        await _utils.post("checkout/$id", body: body2);
        return true;
      } else
        return false;
    } catch (e) {
      Echo('error $e');
      return Future.error(e);
    }
  }

  Future<MyOrdersResponse> myOrders() async {
    String deviceId = await kDeviceInfo();
    try {
      FormData body = FormData.fromMap({
        'device_id': deviceId,
      });
      Response response = await _utils.post("my_orders", body: body);
      if (response.statusCode == 200) {
        MyOrdersResponse myOrdersResponse = MyOrdersResponse.fromJson(response.data);
        return myOrdersResponse;
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
    // if (kDebugMode) return 'testDeviceId';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = '${androidInfo.id}${androidInfo.brand} ${androidInfo.device} ${androidInfo.model}';
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = '${iosInfo.identifierForVendor}${iosInfo.utsname.machine}${iosInfo.utsname.version}${iosInfo.utsname.sysname}';
    }
    Echo('deviceId = ${deviceId.replaceAll(' ', '')}');
    return deviceId.replaceAll(' ', '');
  }

  Future<VersionResponse> kAppVersion() async {
    String pubVersion = "";
    try {
      File f = new File("../pubspec.yaml");
      f.readAsString().then((String text) {
        Map yaml = loadYaml(text);
        pubVersion = yaml['version'];
      });
    } catch (e) {}

    FormData body = FormData.fromMap({
      'type': 'production',
      'platform': Platform.isAndroid ? 'android' : 'ios',
      'version': '1.0.0',
      'pubVersion': pubVersion,
    });
    Response response = await _utils.post("api_version", body: body);
    if (response.data["success"] == true) {
      return VersionResponse.fromJson(response.data);
    } else {
      return VersionResponse.fromJson(response.data);
    }
  }
}
