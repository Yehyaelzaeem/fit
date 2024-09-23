import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../core/base/repositories/base_repository.dart';
import '../../../core/models/user_response.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/local/cache_client.dart';
import '../../../core/services/local/storage_keys.dart';
import '../../../core/services/network/api_client.dart';
import '../../../core/services/network/endpoints.dart';
import '../../../core/utils/shared_helper.dart';
import '../models/requests/update_profile_body.dart';
import '../models/responses/user_model.dart';

class ProfileRepository extends BaseRepository {
  final ApiClient _apiClient;
  final CacheClient _cacheClient;

  ProfileRepository(this._apiClient, this._cacheClient, super.networkInfo);
  //
  // Future<Either<Failure, UserResponse>> getCurrentUser() async {
  //   return super.call<UserResponse>(
  //     httpRequest: () => _apiClient.get(url: EndPoints.getCurrentUser),
  //     successReturn: (data) => UserResponse.fromJson(data),
  //   );
  // }

  Future<Either<Failure, UserResponse>> getCurrentUser() async {
    return super.call<UserResponse>(
      httpRequest: () async {
        String deviceId = await _getDeviceInfo();
        String deviceToken = await _getDeviceToken();
        await _cacheClient.save(StorageKeys.isAuthed, true);
        bool isGuestLogin = await  await _cacheClient.get(StorageKeys.IS_GUEST_SAVED)??false;

        final result = await Connectivity().checkConnectivity();
        print('profileget');

        if (result != ConnectivityResult.none) {
          final url = isGuestLogin
              ? "/profile?device_id=$deviceId&fcm_token=$deviceToken"
              : "/profile?fcm_token=$deviceToken";
          Response response = await _apiClient.get(url: url,requestBody: {});
          _saveUserLocally(UserResponse.fromJson(response.data));

          return response; // Return the Response object here
        } else {
          UserResponse? cachedUser = await _readUserLocally();
          print('cachedUser.data?.toJson()');
          print(cachedUser?.data?.toJson());
          if (cachedUser != null) {
            return Response(requestOptions: RequestOptions(path: ''), data: cachedUser.toJson());
          } else {
            return Response(requestOptions: RequestOptions(path: ''), data: {});
          }
        }

      },
      successReturn: (data) => UserResponse.fromJson(data),
    );
  }

  Future<void> _saveUserLocally(UserResponse userResponse) async {
    print("Saving");
    await _cacheClient.save(StorageKeys.USER, jsonEncode(userResponse.toJson()));

  }

  Future<UserResponse?> _readUserLocally() async {

    String? cachedData = await _cacheClient.get(StorageKeys.USER);

    if (cachedData != null) {
      return UserResponse.fromJson(jsonDecode(cachedData));
    }
    return null;
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


  Future<Either<Failure, UserResponse>> updateProfile(UpdateProfileBody updateProfileBody) async {

    FormData formData = FormData.fromMap({
      "name": updateProfileBody.name,
      "phone": updateProfileBody.phone,
      "email": updateProfileBody.email,
    });
    if(updateProfileBody.avatar!=null)
      formData.files.add(
        MapEntry(
          'avatar',
          await MultipartFile.fromFile(updateProfileBody.avatar!.path, filename: 'avatar.png'),
        ),
      );

    return super.call<UserResponse>(
      httpRequest: () => _apiClient.post(url: EndPoints.updateProfile, requestBody: formData),
      successReturn: (data) => UserResponse.fromJson(data),
    );
  }

  Future<Either<Failure, String>> deleteAccount() async {
    return super.call<String>(
      httpRequest: () => _apiClient.post(url: EndPoints.deleteAccount, requestBody: {}),
      successReturn: (data)=> "success",
    );
  }

}
