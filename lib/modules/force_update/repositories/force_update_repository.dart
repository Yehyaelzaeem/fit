import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/base/repositories/base_repository.dart';
import '../../../core/models/version_response.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/network/api_client.dart';

import 'package:dartz/dartz.dart';
import '../../../core/utils/const_strings.dart';
class AppUpdateRepository extends BaseRepository {
  final ApiClient _apiClient;

  AppUpdateRepository(this._apiClient, super.networkInfo);


  Future<Either<Failure, VersionResponse>> fetchAppVersion() async {
    FormData body = FormData.fromMap({
      'type': 'production',
      'platform': Platform.isAndroid ? 'android' : 'ios',
      'version': Platform.isAndroid
          ? StringConst.APP_Android_VERSION
          : StringConst.APP_IOS_VERSION,
    });

    return super.call<VersionResponse>(
      httpRequest: () async {
        final response = await _apiClient.post(url:"/api_version", requestBody: body);

        if (response.data["success"] == true) {
          return response;
        } else {
          throw Failure(500, response.data["message"] ?? "Failed to fetch version");
        }
      },
      successReturn: (data) => VersionResponse.fromJson(data),
    );
  }


}