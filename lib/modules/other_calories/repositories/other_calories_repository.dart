import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/base/repositories/base_repository.dart';
import '../../../core/models/general_response.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/local/cache_client.dart';
import '../../../core/services/local/storage_keys.dart';
import '../../../core/services/network/api_client.dart';
import '../../diary/models/diary_data.dart';

class OtherCaloriesRepository extends BaseRepository {
  final ApiClient _apiClient;
  final CacheClient _cacheClient;

  OtherCaloriesRepository(this._apiClient, this._cacheClient, super.networkInfo);

  // Adding other calories
  Future<Either<Failure, GeneralResponse>> addOtherCalories({
    required String? title,
    required String? calPerUnit,
    required int? unit,
    String? unitQuantity,
    String? unitName,
    int? type,
  }) async {
    return super.call<GeneralResponse>(
      httpRequest: () async {
        final result = await Connectivity().checkConnectivity();
        if (result != ConnectivityResult.none) {
          FormData body = FormData.fromMap({
            "title": title,
            "calorie_per_unit": calPerUnit,
            "unit": unit,
            "unit_qty": unitQuantity,
            "unit_name": unitName,
            "type": type,
          });

          Response response = await _apiClient.post(url: "/new_other_calories", requestBody: body);
          if (response.statusCode == 200) {
            await saveOtherCaloriesLocally(OtherMealData(
              title: title,
              calPerUnit: calPerUnit,
              unit: unit,
              unitQuantity: unitQuantity,
              unitName: unitName,
              type: type,
            ));
            return response;
          } else {
            return response;
          }
        } else {
          // If offline, save locally
          await saveOtherCaloriesLocally(OtherMealData(
            title: title,
            calPerUnit: calPerUnit,
            unit: unit,
            unitQuantity: unitQuantity,
            unitName: unitName,
            type: type,
          ));
          return Response(
            requestOptions: RequestOptions(path: ''),
            data: {}, // Mock an empty response for offline case
          );
        }
      },
      successReturn: (data) => GeneralResponse.fromJson(data),
    );
  }

  // Updating other calories
  Future<Either<Failure, GeneralResponse>> updateOtherCalories({
    required String? title,
    required String? calPerUnit,
    required int? unit,
    String? unitQuantity,
    String? unitName,
    int? type,
    required int? id,
  }) async {
    return super.call<GeneralResponse>(
      httpRequest: () async {
        FormData body = FormData.fromMap({
          "title": title,
          "calorie_per_unit": calPerUnit,
          "unit": unit,
          "unit_qty": unitQuantity,
          "unit_name": unitName,
          "type": type,
        });

        Response response = await _apiClient.post(url: "update_other_calories/$id", requestBody: body);
        if (response.statusCode == 200) {
          return response;
        } else {
          return response;
        }
      },
      successReturn: (data) => GeneralResponse.fromJson(data),
    );
  }

  Future<void> saveOtherCaloriesLocally(OtherMealData data) async {
    final cachedData = await _cacheClient.get(StorageKeys.OTHER_CALORIES_CREATION);

    List<String> mealDataListJson = [];

    // Ensure the cached data is a List and contains Strings, otherwise handle it
    if (cachedData != null && cachedData is List) {
      try {
        // Try casting each item in the list to String
        mealDataListJson = cachedData.map((item) => item.toString()).toList();
      } catch (e) {
        // If casting fails, handle the error gracefully
        print("Error casting cached data to List<String>: $e");
      }
    }
    mealDataListJson.add(jsonEncode(data.toJson()));
    await _cacheClient.save(StorageKeys.OTHER_CALORIES_CREATION, mealDataListJson);
  }

  Future<void> createOtherCaloriesData() async {
    final cachedData = await _cacheClient.get(StorageKeys.OTHER_CALORIES_CREATION);

    List<String> mealDataList = [];

    // Ensure the cached data is a List and contains Strings, otherwise handle it
    if (cachedData != null && cachedData is List) {
      try {
        // Try casting each item in the list to String
        mealDataList = cachedData.map((item) => item.toString()).toList();
      } catch (e) {
        // If casting fails, handle the error gracefully
        print("Error casting cached data to List<String>: $e");
      }
    }
    // List<String> mealDataList = (await _cacheClient.get(StorageKeys.OTHER_CALORIES_CREATION))?? [];

    for (String mealDataJson in mealDataList) {
      OtherMealData otherCaloriesData = OtherMealData.fromJson(jsonDecode(mealDataJson));

      if (otherCaloriesData.id == null) {
        await addOtherCalories(
          title: otherCaloriesData.title,
          calPerUnit: otherCaloriesData.calPerUnit,
          unit: otherCaloriesData.unit,
          unitQuantity: otherCaloriesData.unitQuantity,
          unitName: otherCaloriesData.unitName,
          type: otherCaloriesData.type,
        );
      } else {
        await updateOtherCalories(
          title: otherCaloriesData.title,
          calPerUnit: otherCaloriesData.calPerUnit,
          unit: otherCaloriesData.unit,
          unitQuantity: otherCaloriesData.unitQuantity,
          unitName: otherCaloriesData.unitName,
          type: otherCaloriesData.type,
          id: otherCaloriesData.id,
        );
      }
    }

    // Clear cached data after syncing
    await _cacheClient.delete(StorageKeys.OTHER_CALORIES_CREATION);
  }


}