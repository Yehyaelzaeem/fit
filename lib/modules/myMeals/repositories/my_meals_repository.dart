

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';

import '../../../core/base/repositories/base_repository.dart';
import '../../../core/models/meal_details_response.dart';
import '../../../core/models/mymeals_response.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/services/local/cache_client.dart';
import '../../../core/services/network/api_client.dart';
import '../../../core/utils/shared_helper.dart';


class MyMealsRepository extends BaseRepository {
  final ApiClient _apiClient;
  final CacheClient _cacheClient;

  MyMealsRepository(this._apiClient, this._cacheClient, super.networkInfo);


  // Fetch My Meals
  Future<MyMealResponse> getMyMeals() async {
    String deviceId = await _getDeviceInfo();
    FormData body = FormData.fromMap({
      'device_id': deviceId,
    });

    try {
      Response response = await _apiClient.post(url: "/my_meals", requestBody: body);
      if (response.statusCode == 200 && response.data['success'] == true) {
        return MyMealResponse.fromJson(response.data);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

  // Fetch Meal Details
  Future<MealDetailsResponse> getMealDetails(String id) async {
    String deviceId = await _getDeviceInfo();
    FormData body = FormData.fromMap({
      'device_id': deviceId,
    });

    try {
      Response response = await _apiClient.post(url: "/meal_details/$id", requestBody: body);
      if (response.statusCode == 200) {
        return MealDetailsResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch meal details");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<String> _getDeviceInfo() async {
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

    return deviceId.replaceAll(' ', '');
  }


}
