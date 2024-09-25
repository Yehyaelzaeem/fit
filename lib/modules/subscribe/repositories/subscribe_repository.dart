import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';

import '../../../core/models/payment_package_response.dart';
import '../../../core/models/services_response.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/services/network/api_client.dart';
import '../../../core/utils/shared_helper.dart';

class SubscribeRepository {
  final ApiClient _apiClient;

  SubscribeRepository(this._apiClient) ;

  Future<ServicesResponse> getServices() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response = await _apiClient.get(url: "/services");
      if (response.data["success"] == true) {
        saveServicesLocally(ServicesResponse.fromJson(response.data));
        return ServicesResponse.fromJson(response.data);
      } else {
        saveServicesLocally(ServicesResponse.fromJson(response.data));
        return ServicesResponse.fromJson(response.data);
      }
    } else {
      ServicesResponse? cachedServices = await readServicesLocally();
      return cachedServices ?? ServicesResponse();
    }
  }

  Future<void> saveServicesLocally(ServicesResponse servicesResponse) async {
    await SharedHelper().writeData(CachingKey.SERVICES, jsonEncode(servicesResponse.toJson()));
  }

  Future<ServicesResponse?> readServicesLocally() async {
    String? data = await SharedHelper().readString(CachingKey.SERVICES);
    return data != null ? ServicesResponse.fromJson(jsonDecode(data)) : null;
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
    // Save guest information if applicable
    if (isGuest) {
      await SharedHelper().writeData(CachingKey.PHONE, phone);
      await SharedHelper().writeData(CachingKey.IS_GUEST_SAVED, true);
      await SharedHelper().writeData(CachingKey.USER_LAST_NAME, lastName);
      await SharedHelper().writeData(CachingKey.EMAIL, email);
      await SharedHelper().writeData(CachingKey.USER_NAME, name);
    }

    String deviceId = await _getDeviceInfo();
    FormData body = FormData.fromMap({
      "name": name,
      "last_name": lastName,
      "phone": phone,
      "email": email,
      "device_id": deviceId,
      "pay_method": payMethod,
    });

    Response response = await _apiClient.post(url: "/book-service-package/$packageId", requestBody: body);
    return PackagePaymentResponse.fromJson(response.data);
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

}