import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';

import '../../../core/models/my_packages_response.dart';
import '../../../core/models/package_details_response.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/services/network/api_client.dart';
import '../../../core/utils/shared_helper.dart';

class PackagesRepository {
  final ApiClient _apiClient;

  PackagesRepository(this._apiClient);

  Future<MyPackagesResponse> fetchMyPackagesResponse() async {
    String deviceId = await _getDeviceInfo();
    try {
      Response response = await _apiClient.get(
        url: "/service-package-orders?device_id=$deviceId",
      );

      if (response.statusCode == 200) {
        return MyPackagesResponse.fromJson(response.data);
      } else {
        return Future.error("Error: Server returned ${response.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
      return Future.error(e);
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

  Future<PackageDetailsResponse> fetchPackageDetails({
    required int packageId,
  }) async {
    String deviceId = await _getDeviceInfo();
    try {
      Response response = await _apiClient.get(
        url: "/service-package-order/$packageId?device_id=$deviceId",
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        return PackageDetailsResponse.fromJson(response.data);
      } else {
        return Future.error("Error: ${response.data["message"] ?? "Unknown error"}");
      }
    } catch (e) {
      print('Error: $e');
      return Future.error(e);
    }
  }

}
