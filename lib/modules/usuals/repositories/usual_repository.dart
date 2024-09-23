
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/base/repositories/base_repository.dart';
import '../../../core/models/general_response.dart';
import '../../../core/models/usual_meals_data_reposne.dart';
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
          Response response = await _apiClient.get(url: "diary-meals/food-calories");
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
          Response response = await _apiClient.post(url: "diary-meals/new_diary_meal", requestBody: body);
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
    List<String> mealDataListJson = (await _cacheClient.get(StorageKeys.MealsCreationList)) ?? [];
    mealDataListJson.add(jsonEncode(data.toJson()));
    await _cacheClient.save(StorageKeys.MealsCreationList, mealDataListJson);
  }

  Future<void> sendLocallySavedUsualMeals() async {
    List<String> mealDataList = (await _cacheClient.get(StorageKeys.MealsCreationList)) ?? [];
    for (String mealDataJson in mealDataList) {
      UsualMealData mealData = UsualMealData.fromJson(jsonDecode(mealDataJson));

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
        url:"diary-meals/update_diary_meal/${mealParameters['id']}",
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
    Response response = await _apiClient.post(url:"diary-meals/delete_diary_meal/$mealId");
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
}
