
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/base/repositories/base_repository.dart';
import '../../../core/models/sleep_time_response.dart';
import '../../../core/models/sleeping_time_response.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/local/cache_client.dart';
import '../../../core/services/local/storage_keys.dart';
import '../../../core/services/network/api_client.dart';
import '../../../core/services/network/endpoints.dart';
import '../cubits/time_sleep_cubit.dart';


class TimeSleepRepository extends BaseRepository {
  final ApiClient _apiClient;
  final CacheClient _cacheClient;

  TimeSleepRepository(this._apiClient, this._cacheClient, super.networkInfo);



  // Add sleep time through API
  Future<Either<Failure, SleepTimeResponse>> addSleepTime({
    required String sleepTimeFrom,
    required String sleepTimeTo,
    required String date,
  }) async {
    FormData body = FormData.fromMap({
      'sleeping_from': sleepTimeFrom,
      'sleeping_to': sleepTimeTo,
      'date': date,
    });

    return super.call<SleepTimeResponse>(
      httpRequest: () async {
        final response = await _apiClient.post(url: EndPoints.setSleepTime, requestBody: body);
        return response;
      },
      successReturn: (data) => SleepTimeResponse.fromJson(data),
    );
  }

  // Save sleep time locally
  Future<void> saveSleepTimeLocally(SleepTime sleepTime) async {
    final data = sleepTime.toJson();
    await _cacheClient.save(StorageKeys.SLEEP_TIME, data);
  }


  Future<Either<Failure, SleepingTimesResponse>> getSleepingTimesData() async {
    return super.call<SleepingTimesResponse>(
      httpRequest: () async {
        final result = await Connectivity().checkConnectivity();
        if (result != ConnectivityResult.none) {
          Response response = await _apiClient.get(url: EndPoints.sleepingTimes);
          if (response.statusCode == 200) {
            await saveSleepingTimesLocally(SleepingTimesResponse.fromJson(response.data));
            return response;
          } else {
            await saveSleepingTimesLocally(SleepingTimesResponse.fromJson(response.data));
            return response;
          }
        } else {
          SleepingTimesResponse? cachedResponse = await readSleepingTimesLocally();
          return Response(
            requestOptions: RequestOptions(path: ''),
            data: cachedResponse?.toJson() ?? {},
          );
        }
      },
      successReturn: (data) => SleepingTimesResponse.fromJson(data),
    );
  }

  // Save Sleeping Times data locally
  Future<void> saveSleepingTimesLocally(SleepingTimesResponse sleepingTimesResponse) async {
    await _cacheClient.save(StorageKeys.SleepingTimes, jsonEncode(sleepingTimesResponse.toJson()));
  }

  // Read Sleeping Times data locally
  Future<SleepingTimesResponse?> readSleepingTimesLocally() async {
    String? cachedData = await _cacheClient.get(StorageKeys.SleepingTimes);
    return cachedData != null ? SleepingTimesResponse.fromJson(jsonDecode(cachedData)) : null;
  }

}
