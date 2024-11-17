
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/base/repositories/base_repository.dart';
import '../../../core/models/general_response.dart';
import '../../../core/models/usual_meals_data_reposne.dart';
import '../../../core/models/usual_meals_reposne.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/local/cache_client.dart';
import '../../../core/services/local/storage_keys.dart';
import '../../../core/services/network/api_client.dart';
import '../../diary/models/diary_data.dart';


class UsualRepository extends BaseRepository {
  final ApiClient _apiClient;
  final CacheClient _cacheClient;

  UsualRepository(this._apiClient, this._cacheClient, super.networkInfo);


  Future<Either<Failure, UsualMealsDataResponse>> getUsualMealsData() async {
    return super.call<UsualMealsDataResponse>(
      httpRequest: () async {
        final result = await Connectivity().checkConnectivity();
        if (result != ConnectivityResult.none) {
          Response response = await _apiClient.get(url: "/diary-meals/food-calories");
          if (response.statusCode == 200) {
            await saveUsualMealsLocally(UsualMealsDataResponse.fromJson(response.data));
            return response;
          } else {
            return response;
          }
        } else {
          UsualMealsDataResponse? cachedResponse = await readUsualMealsLocally();
          return Response(
            requestOptions: RequestOptions(path: ''),
            data: cachedResponse?.toJson() ?? {},
          );
        }
      },
      successReturn: (data) => UsualMealsDataResponse.fromJson(data),
    );
  }

  Future<void> saveUsualMealsLocally(UsualMealsDataResponse response) async {
    await _cacheClient.save(StorageKeys.UsualMeals, jsonEncode(response.toJson()));
  }

  Future<UsualMealsDataResponse?> readUsualMealsLocally() async {
    String? meals = await _cacheClient.get(StorageKeys.UsualMeals);
    return meals != null ? UsualMealsDataResponse.fromJson(jsonDecode(meals)) : null;
  }

  Future<Either<Failure, GeneralResponse>> createUsualMeal(Map<String, dynamic> mealParameters) async {
    return super.call<GeneralResponse>(
      httpRequest: () async {
        final result = await Connectivity().checkConnectivity();
        if (result != ConnectivityResult.none) {
          FormData body = FormData.fromMap(mealParameters);
          Response response = await _apiClient.post(url: "/diary-meals/new_diary_meal", requestBody: body);
          return response;
        } else {
          await createUsualMealLocally(UsualMealData(
            name: mealParameters["name"],
            foodId: mealParameters["food_id"],
            qty: mealParameters["qty"],
          ));
          return Response(
            requestOptions: RequestOptions(path: ''),
            data: GeneralResponse(success: false, message: 'Offline, saved locally').toJson(),
          );
        }
      },
      successReturn: (data) => GeneralResponse.fromJson(data),
    );
  }

  Future<void> createUsualMealLocally(UsualMealData data) async {
    List<Map<String, dynamic>> mealDataListJson = [];

    // Retrieve the data from storage
    final rawJson = await _cacheClient.get(StorageKeys.MealsCreationList);

    if (rawJson != null) {
      try {
        // Check if rawJson is already a List
        if (rawJson is String) {
          mealDataListJson = List<Map<String, dynamic>>.from(jsonDecode(rawJson));
        } else if (rawJson is List) {
          // If it's already a list, make sure to map it correctly
          mealDataListJson = List<Map<String, dynamic>>.from(rawJson);
        } else {
          print('Unexpected data format');
        }
      } catch (e) {
        print('Error parsing stored data: $e');
      }
    }

    // Add the new meal data and save it back as a JSON string
    mealDataListJson.add(data.toJson());
    await _cacheClient.save(StorageKeys.MealsCreationList, jsonEncode(mealDataListJson));
  }

  Future<void> sendLocallySavedUsualMeals() async {
    List<Map<String, dynamic>> mealDataList = [];
    final rawJson = await _cacheClient.get(StorageKeys.MealsCreationList);

    if (rawJson != null) {
      try {
        mealDataList = List<Map<String, dynamic>>.from(jsonDecode(rawJson));
      } catch (e) {
        print('Error parsing stored data: $e');
      }
    }
    for (Map<String, dynamic> mealDataJson in mealDataList) {
      UsualMealData mealData = UsualMealData.fromJson(mealDataJson);

      if (mealData.id == null) {
        await createUsualMeal( mealData.toJson());
      } else {
        await updateUsualMeal(mealParameters: mealData.toJson());
      }
    }

    await _cacheClient.delete(StorageKeys.MealsCreationList); // Clear local cache after syncing
  }

  Future<GeneralResponse> updateUsualMeal({
    required Map<String, dynamic> mealParameters,
  }) async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      FormData body = FormData.fromMap(mealParameters);
      Response response = await _apiClient.post(
        url:"/diary-meals/update_diary_meal/${mealParameters['id']}",
        requestBody: body,
      );
      if (response.data["success"] == true) {
        return GeneralResponse.fromJson(response.data);
      } else {
        return GeneralResponse.fromJson(response.data);
      }
    } else {
      await createUsualMealLocally(UsualMealData(
        name: mealParameters["name"],
        foodId: mealParameters["food_id"],
        qty: mealParameters["qty"],
        id: mealParameters['id'],
      ));
      return GeneralResponse();
    }
  }
  Future<GeneralResponse> deleteUsualMeal({required int mealId}) async {
    Response response = await _apiClient.post(url:"/diary-meals/delete_diary_meal/$mealId");
    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
  }

  Future<void> deleteUsualMealLocally(int id) async {
    List<String> deletedMealsList = (await _cacheClient.get(StorageKeys.DELETE_USUAL_MEAL)) ?? [];
    deletedMealsList.add(id.toString());
    await _cacheClient.save(StorageKeys.DELETE_USUAL_MEAL, deletedMealsList);
  }
  Future<void> sendDeleteUsualMeal() async {
    List<String> deletedMealList = (await _cacheClient.get(StorageKeys.DELETE_USUAL_MEAL)) ?? [];

    for (String id in deletedMealList) {
      await deleteUsualMeal(mealId: int.parse(id));
    }

    // Clear locally saved deleted meals after successfully sending to API
    await _cacheClient.delete(StorageKeys.DELETE_USUAL_MEAL);
  }

  Future<Either<Failure, UsualMealsResponse>> getMyUsualMeals() async {
    return super.call<UsualMealsResponse>(
      httpRequest: () async {
        final result = await Connectivity().checkConnectivity();

        if (result != ConnectivityResult.none) {
          // Fetch from API when online
          Response response = await _apiClient.get(url: "/diary-meals");

          if (response.statusCode == 200) {
            // Save locally for offline use
            await saveMyUsualMealsLocally(UsualMealsResponse.fromJson(response.data));
          }

          // Return the response, whether successful or not
          return response;
        } else {
          // When offline, fetch from local cache
          UsualMealsResponse? cachedResponse = await readMyUsualMealsLocally();

          // Simulate a Response object with cached data
          return Response(
            requestOptions: RequestOptions(path: ''),
            data: cachedResponse?.toJson() ?? {},
          );
        }
      },
      successReturn: (data) => UsualMealsResponse.fromJson(data),
    );
  }

  Future<void> saveMyUsualMealsLocally(UsualMealsResponse usualMealsResponse) async {
    await _cacheClient.save(StorageKeys.MY_USUAL_MEALS, jsonEncode(usualMealsResponse.toJson()));
  }

  Future<UsualMealsResponse?> readMyUsualMealsLocally() async {
    String? meals = await _cacheClient.get(StorageKeys.MY_USUAL_MEALS);
    if (meals != null) {
      return UsualMealsResponse.fromJson(jsonDecode(meals));
    } else {
      return null;
    }
  }



}
