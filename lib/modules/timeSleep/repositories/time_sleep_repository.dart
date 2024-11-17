
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
    await _cacheClient.save(StorageKeys.SLEEP_TIME, jsonEncode(data));
  }

  Future<void> sendSavedSleepTimes() async {
    try {
      // Retrieve locally saved sleep times from cache
      final savedData = await _cacheClient.get(StorageKeys.SLEEP_TIME);

      if (savedData != null) {
        // Decode the stored JSON data into a SleepTime object
        final sleepTime = SleepTime.fromJson(jsonDecode(savedData));

        // Call the addSleepTime method to send the data to the API
        final result = await addSleepTime(
          sleepTimeFrom: sleepTime.sleepTimeFrom,
          sleepTimeTo: sleepTime.sleepTimeTo,
          date: sleepTime.date,
        );

        result.fold(
              (failure) {
            print("Failed to send saved sleep time: ${failure.message}");
            // Handle the failure if needed
          },
              (response) {
            print("Successfully sent saved sleep time.");
            // You can remove the cached data after successful send, if needed
            _cacheClient.delete(StorageKeys.SLEEP_TIME);
          },
        );
      }
    } catch (e) {
      print("Error sending saved sleep time: $e");
    }
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
         print('cachedResponse?.toJson() ');
         print(cachedResponse?.toJson() );
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
