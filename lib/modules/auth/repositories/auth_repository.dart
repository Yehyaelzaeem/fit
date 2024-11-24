import 'dart:io';

import 'package:app/core/utils/alerts.dart';
import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../config/localization/l10n/l10n.dart';
import '../../../config/navigation/navigation.dart';
import '../../../core/base/repositories/base_repository.dart';
import '../../../core/models/general_response.dart';
import '../../../core/models/user_response.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/services/error/error_handler.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/local/cache_client.dart';
import '../../../core/services/local/storage_keys.dart';
import '../../../core/services/network/api_client.dart';
import '../../../core/services/network/endpoints.dart';
import '../../../core/utils/globals.dart';
import '../../../core/utils/shared_helper.dart';
import '../../profile/models/responses/user_model.dart';
import '../models/requests/login_body.dart';
import '../models/requests/registration_body.dart';

class AuthRepository extends BaseRepository {
  final ApiClient _apiClient;
  final CacheClient _cacheClient;

  AuthRepository(this._apiClient, this._cacheClient, super.networkInfo);

  bool get isAuthed => _cacheClient.get(StorageKeys.isAuthed) ?? false;


  saveAuth(String token) async{
    await _cacheClient.save(
        StorageKeys.token, token);
    await _cacheClient.save(StorageKeys.isAuthed, true);
    print("saved");
  }
  Future<Either<Failure, UserResponse>> login(String id, String password) async {
    String deviceId = await _getDeviceInfo();
    String deviceToken = await _getDeviceToken();
    FormData body = FormData.fromMap({
      'patient_id': id,
      'password': password,
      'device_id': deviceId + id,
      'fcm_token': deviceToken,
    });
    return super.call<UserResponse>(
      httpRequest: () async {
        final response = await _apiClient.post(url: EndPoints.login, requestBody: body);

        print(response.data);
        if(response.data["data"]!=null) {
          await _cacheClient.save(
              StorageKeys.token, response.data["data"]["access_token"]);
          await _cacheClient.save(StorageKeys.isAuthed, true);
          return response;
        }
          // else{
          // Alerts.showToast(response.data["message"]);
          // final failureMessage = response.data["message"] ?? "An error occurred";
          //
          // throw
          // return Left(Failure(message: failureMessage));
        // }
        // Alerts.showToast(response.data["message"]);

        return response;
      },
      successReturn: (data) => UserResponse.fromJson(data),
    );
  }



  Future<Either<Failure, GeneralResponse>> register(String id,
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
    return super.call<GeneralResponse>(
      httpRequest: () => _apiClient.post(url: EndPoints.register, requestBody: body),
      successReturn: (data) => GeneralResponse.fromJson(data),
    );
  }



  Future<String> _getDeviceToken() async {
    String? _deviceToken;
    if (Platform.isIOS) {
      _deviceToken = await FirebaseMessaging.instance.getAPNSToken();
    } else {
      _deviceToken = await FirebaseMessaging.instance.getToken();
    }
    return _deviceToken??'';
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


  Future<Either<Failure, String>> sendOtp(String phone) async {
    return super.call<String>(
      httpRequest: () => _apiClient.post(url: EndPoints.sendOtp, requestBody: {"phone": phone}),
      successReturn: (data)=> data["otp"].toString(),
    );
  }

  Future<Either<Failure, String>> forgetPassword(String email) async {
    return super.call<String>(
      httpRequest: () => _apiClient.post(url: EndPoints.forgetPassword, requestBody: {"email": email}),
      successReturn: (data)=> "success",
    );
  }


  // Future<Either<Failure, String>> verifyOtp(String phone, String otp) async {
  //   return super.call<String>(
  //     httpRequest: () => _apiClient.post(url: EndPoints.verifyOtp, requestBody: {"phone": phone, "otp": otp}),
  //     successReturn: (data) => data,
  //   );
  // }

  Future<Either<Failure, String>> logout() async {
    try {
      await clearCache(); 
      return Right(L10n.tr(NavigationService.navigationKey.currentContext!).logoutSuccess);
    } on Exception catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  Future<void> clearCache() async {
    await _cacheClient.delete(StorageKeys.isAuthed);
    await _cacheClient.delete(StorageKeys.USER);
    // await _cacheClient.deleteSecuredData();
    currentUser = null;
  }


}
