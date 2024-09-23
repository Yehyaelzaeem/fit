
import 'dart:convert';

import 'package:app/core/services/local/storage_keys.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../core/base/repositories/base_repository.dart';
import '../../../core/models/day_details_reposne.dart';
import '../../../core/models/general_response.dart';
import '../../../core/models/my_other_calories_response.dart';
import '../../../core/models/other_calories_units_repose.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/local/cache_client.dart';
import '../../../core/services/network/api_client.dart';
import '../../../core/services/network/endpoints.dart';
import '../../../core/utils/shared_helper.dart';
import '../models/diary_data.dart';


class DiaryRepository extends BaseRepository {
  final ApiClient _apiClient;
  final CacheClient _cacheClient;

  DiaryRepository(this._apiClient, this._cacheClient, super.networkInfo);


  Future<Either<Failure, DayDetailsResponse>> getDiaryView(String date, bool isNotSending, bool notSave, bool isLive) async {
    return super.call<DayDetailsResponse>(
      httpRequest: () async {
        final result = await Connectivity().checkConnectivity();

        // If the device is connected and the data is live, make an API call
        if (result != ConnectivityResult.none && isNotSending && isLive) {
          final response = await _apiClient.get(url: "${EndPoints.caloriesDayDetails}?date=$date", requestBody: {});

          // Save locally if applicable
          if (!notSave) {
            await saveDairyTempLocally(DayDetailsResponse.fromJson(response.data));
          }

          return response; // Returning API response
        } else {
          // If offline or data not live, return cached data
          final DayDetailsResponse? cachedData = await readDairyTempLocally();

          if (cachedData != null) {
            return Response(data: cachedData.toJson(), statusCode: 200, requestOptions: RequestOptions(path: 'diary'));
          }

          return Response(data: {}, statusCode: 500, requestOptions: RequestOptions(path: 'diary'));
        }
      },
      successReturn: (data) => DayDetailsResponse.fromJson(data),
    );
  }

  Future<void> saveDairyLocally(DayDetailsResponse dayDetailsResponse, String date) async {
    Map<String, dynamic> existingData = await readDairyLocally();
    existingData[date] = dayDetailsResponse.toJson();
    await _cacheClient.save(StorageKeys.DIARY, jsonEncode(existingData));
  }


  Future<void> saveDairyToSendLocally(DayDetailsResponse dayDetailsResponse, String date) async {
    // Read existing data
    print('DAIRY_TO_SEND saving');
    Map<String, dynamic> existingData = await readDairyToSendLocally();

    // Check if the response date exists in the existing data
    if (existingData.containsKey(date)) {
      // Update existing entry for date4
      print("exist");
      existingData[date] = dayDetailsResponse.toJson();
    } else {
      // If the response date does not exist, add it to the map
      print("Not exist");
      existingData[date] = dayDetailsResponse.toJson();
    }

    // Save the updated map
    await _cacheClient.save(StorageKeys.DAIRY_TO_SEND, jsonEncode(existingData));
  }

  Future<void> saveDairyTempLocally(DayDetailsResponse dayDetailsResponse) async {
    await _cacheClient.save(StorageKeys.DAIRY_TEMP, jsonEncode(dayDetailsResponse.toJson()));
  }

  Future<Map<String, dynamic>> readDairyLocally() async {
    String? dairy = await SharedHelper().readString(CachingKey.DAIRY);
    return dairy != null && dairy.isNotEmpty ? jsonDecode(dairy) : {};
  }

  Future<DayDetailsResponse?> readDairyTempLocally() async {
    String? dairyTemp = await SharedHelper().readString(CachingKey.DAIRY_TEMP);
    return dairyTemp != null && dairyTemp.isNotEmpty ? DayDetailsResponse.fromJson(jsonDecode(dairyTemp)) : null;
  }

  Future<DayDetailsResponse> _getCachedDiaryData(String? date, DayDetailsResponse? dayDetailsResponseTemp) async {
    Map<String, dynamic> dairy = await readDairyLocally();
    dynamic data = dairy[date];
    if (data != null) {
      return DayDetailsResponse.fromJson(data);
    } else {
      if (dayDetailsResponseTemp != null) {
        dayDetailsResponseTemp.data?.days = List.generate(3, (index) {
          if (index == 0) {
            return Days(date: date, dateFormat: DateFormat('EEEE, d MMMM y').format(DateTime.parse(date!)), active: true);
          } else if (index == 1) {
            return Days(
              date: DateTime.parse(date!).subtract(Duration(days: 1)).toString().substring(0, 10),
              dateFormat: DateFormat('EEEE, d MMMM y').format(DateTime.parse(date!).subtract(Duration(days: 1))),
              active: false,
            );
          } else {
            return Days(
              date: DateTime.parse(date!).add(Duration(days: 1)).toString().substring(0, 10),
              dateFormat: DateFormat('EEEE, d MMMM y').format(DateTime.parse(date!).add(Duration(days: 1))),
              active: false,
            );
          }
        });
        await saveDairyLocally(dayDetailsResponseTemp, date!);
      }
      return dayDetailsResponseTemp ?? DayDetailsResponse();
    }
  }

  Future<MyOtherCaloriesResponse> getOtherCalories() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response = await _apiClient.get(url: "other_calories",requestBody: {});
      if (response.data["success"] == true) {
        await saveMyOtherCaloriesLocally(MyOtherCaloriesResponse.fromJson(response.data));
        return MyOtherCaloriesResponse.fromJson(response.data);
      } else {
        await saveMyOtherCaloriesLocally(MyOtherCaloriesResponse.fromJson(response.data));
        return MyOtherCaloriesResponse.fromJson(response.data);
      }
    } else {
      MyOtherCaloriesResponse? calories = await readMyOtherCaloriesLocally();
      return calories ?? MyOtherCaloriesResponse();
    }
  }

  Future<void> saveMyOtherCaloriesLocally(MyOtherCaloriesResponse response) async {
    await _cacheClient.save('MY_OTHER_CALORIES', jsonEncode(response.toJson()));
  }

  Future<MyOtherCaloriesResponse?> readMyOtherCaloriesLocally() async {
    String? calories = await _cacheClient.get('MY_OTHER_CALORIES');
    return calories != null ? MyOtherCaloriesResponse.fromJson(jsonDecode(calories)) : null;
  }

  Future<MyOtherCaloriesUnitsResponse> getOtherCaloriesUnit() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response = await _apiClient.get(url: "other_calories_units",requestBody: {});
      if (response.data["success"] == true) {
        await saveMyOtherCaloriesUnitsLocally(MyOtherCaloriesUnitsResponse.fromJson(response.data));
        return MyOtherCaloriesUnitsResponse.fromJson(response.data);
      } else {
        await saveMyOtherCaloriesUnitsLocally(MyOtherCaloriesUnitsResponse.fromJson(response.data));
        return MyOtherCaloriesUnitsResponse.fromJson(response.data);
      }
    } else {
      MyOtherCaloriesUnitsResponse? units = await readMyOtherCaloriesUnitsLocally();
      return units ?? MyOtherCaloriesUnitsResponse();
    }
  }

  Future<void> saveMyOtherCaloriesUnitsLocally(MyOtherCaloriesUnitsResponse response) async {
    await _cacheClient.save('OTHER_CALORIES_UNITS', jsonEncode(response.toJson()));
  }

  Future<MyOtherCaloriesUnitsResponse?> readMyOtherCaloriesUnitsLocally() async {
    String? units = await _cacheClient.get('OTHER_CALORIES_UNITS');
    return units != null ? MyOtherCaloriesUnitsResponse.fromJson(jsonDecode(units)) : null;
  }


  bool sendingOffline = false;

  // Function to send saved diary data
  Future<void> sendSavedDiaryDataByDay() async {
    print("sendSavedDiaryDataByDay AA");
    if (!sendingOffline) {
      sendingOffline = true;

      Map<String, dynamic> existingData = await readDairyToSendLocally();
      print("await readDairyToSendLocally");

      final eitherResult = await getDiaryView(getEgyptTime().toString().substring(0, 10), true, true, true);
      print("eitherResult");

      eitherResult.fold(
              (failure) {
            // Handle failure (e.g., no network, API error)
            print("Failed to fetch day details: $failure");
          },
              (dayDetailsResponse) async {
                print("savingsaving");
            // Proceed with the day details response
            List<DiaryEntry> diarySendList = _prepareDiarySendList(existingData, dayDetailsResponse);

            // The rest of your send logic goes here...
            for (DiaryEntry entry in diarySendList) {
              var formData = _prepareFormData(entry);

              try {
                Response response = await _apiClient.post(url: "/save_offline_diary", requestBody: formData);

                if (response.data["success"] == true) {
                  await _cacheClient.delete(entry.date);
                }
              } catch (e) {
                print("Error sending diary entry: $e");
              }
            }

            sendingOffline = false;
            await _cacheClient.delete(StorageKeys.DAIRY_TO_SEND);
          }
      );
    }
  }

  // Function to remove cached diary data
  Future<void> removeCachedDiaryDataLocally(int randomId) async {
    List<String> diaryDataListJson = (await _cacheClient.get(StorageKeys.DAIRY_DATA_LIST)) ?? [];

    int? index;
    for (int i = 0; i < diaryDataListJson.length; i++) {
      DiaryData diaryData = DiaryData.fromJson(jsonDecode(diaryDataListJson[i]));
      if (diaryData.randomId == randomId) {
        index = i;
        break;
      }
    }

    if (index != null) {
      diaryDataListJson.removeAt(index);
      await _cacheClient.save(StorageKeys.DAIRY_DATA_LIST, diaryDataListJson);
    }
  }

  Future<Map<String, dynamic>> readDairyToSendLocally() async {
    String? dairy = await _cacheClient.get(StorageKeys.DAIRY_TO_SEND);
    print('dairy$dairy');
    if (dairy != null&&dairy!='') {
      print(dairy);
      print(jsonDecode(dairy));
      return jsonDecode(dairy);
    } else {
      return {};
    }
  }


  List<DiaryEntry> _prepareDiarySendList(Map<String, dynamic> existingData, DayDetailsResponse dayDetailsResponse) {
    List<DiaryEntry> diarySendList = [];

    // Populate the diarySendList based on existingData and dayDetailsResponse
    // (similar to the logic you already have)

    return diarySendList;
  }

  FormData _prepareFormData(DiaryEntry entry) {
    FormData formData = FormData.fromMap({
      'date': entry.date,
      'water': entry.water,
      if (entry.workout != null) 'workout': entry.workout ?? '',
      if (entry.workoutDesc != null) 'workout_desc': entry.workoutDesc ?? '',
    });

    for (int i = 0; i < entry.food.length; i++) {
      formData.fields.add(MapEntry('food[$i]', entry.food[i].toString()));
      formData.fields.add(MapEntry('qty[$i]', entry.qty[i].toString()));
      formData.fields.add(MapEntry('created_at[$i]', entry.createdAt[i].toString()));
    }

    return formData;
  }


  // Save the last loading time
  Future<void> saveLastLoadingTime(DateTime time) async {
    await _cacheClient.save(StorageKeys.LAST_LOADING_TIME, time.millisecondsSinceEpoch);
  }

  // Get the last loading time
  Future<DateTime?> getLastLoadingTime() async {
    int? millisecondsSinceEpoch = await _cacheClient.get(StorageKeys.LAST_LOADING_TIME);
    return millisecondsSinceEpoch != null
        ? DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch)
        : null;
  }

  // Method to delete a calorie entry via API
  Future<Either<Failure, GeneralResponse>> deleteCalorie(String endPoint, int id) async {
    return super.call<GeneralResponse>(
      httpRequest: () async {
        FormData body = FormData.fromMap({"id": id});
        Response response = await _apiClient.post(url: endPoint, requestBody: body);
        return response;
      },
      successReturn: (data) => GeneralResponse.fromJson(data),
    );
  }

  // Save calorie deletion data locally
  Future<void> deleteCalorieLocally(int id) async {
    List<String> calorieDataListJson = (await _cacheClient.get(StorageKeys.DeleteCalorie)) ?? [];
    calorieDataListJson.add(id.toString());
    await _cacheClient.save(StorageKeys.DeleteCalorie, calorieDataListJson);
  }

  // Send locally saved deletion data to API
  Future<void> sendDeleteCalorie() async {
    List<String> deletedCalorieDataList = (await _cacheClient.get(StorageKeys.DeleteCalorie)) ?? [];
    for (String id in deletedCalorieDataList) {
      await deleteCalorie("delete_calories_details", int.parse(id));
    }
    // Clear local cache after successful deletion
    await _cacheClient.delete(StorageKeys.DeleteCalorie);
  }

  Future<Either<Failure, GeneralResponse>> createDiaryData({
    required String date,
    String? water,
    int? foodProtine,
    double? qtyProtiene,
    int? workOut,
    String? workoutDesc,
    int? randomId,
    String? foodName,
    dynamic caloriesPerUnit,
  }) async {
    // Build the request body
    FormData body = FormData.fromMap({
      if (water != null) "water": water,
      "date": date,
      if (foodProtine != null) "food": foodProtine,
      if (qtyProtiene != null) "qty": qtyProtiene,
      if (workOut != null) "workout": workOut,
      if (workoutDesc != null) "workout_desc": workoutDesc,
    });

    return super.call<GeneralResponse>(
      httpRequest: () async {
        // Check connectivity
        final connectivityResult = await Connectivity().checkConnectivity();
        if (false) {
        // if (connectivityResult != ConnectivityResult.none) {
          // Online: Send API request
          Response response = await _apiClient.post(url: "/save_calories_details", requestBody: body);

          if (response.statusCode == 200 && response.data["success"] == true) {
            return response;
          } else {
            return response;
          }
        } else {
          // Offline: Save to local cache
          await saveDiaryDataLocally(
            DiaryData(
              date: date,
              water: water,
              foodProtine: foodProtine,
              qtyProtiene: qtyProtiene,
              workOut: workOut,
              workoutDesc: workoutDesc,
              foodName: foodName,
              caloriesPerUnit: caloriesPerUnit,
              randomId: randomId,
            ),
          );

          // Return a generic response
          return Response(
            requestOptions: RequestOptions(path: ''),
            data: GeneralResponse(success: true).toJson(),
          );
        }
      },
      successReturn: (data) => GeneralResponse.fromJson(data),
    );
  }



  // Function to save diary data locally
  Future<void> saveDiaryDataLocally(DiaryData data) async {
    // final List<String> diaryDataListJson = (await _cacheClient.get(StorageKeys.DAIRY_DATA_LIST)) ?? [];
    final List<dynamic> rawDiaryDataList = (await _cacheClient.get(StorageKeys.DAIRY_DATA_LIST)) ?? [];
    final List<String> diaryDataListJson = rawDiaryDataList.map((e) => e.toString()).toList();

    bool isExist = false;

    // Check if the diary entry exists in the cache
    for (int i = 0; i < diaryDataListJson.length; i++) {
      DiaryData existingData = DiaryData.fromJson(jsonDecode(diaryDataListJson[i]));
      if (existingData.randomId == data.randomId) {
        isExist = true;
        diaryDataListJson[i] = jsonEncode(data.toJson());
        break;
      }
    }

    // Add new entry if it doesn't exist
    if (!isExist) {
      diaryDataListJson.add(jsonEncode(data.toJson()));
    }

    // Write the updated list back to the cache
    await _cacheClient.save(StorageKeys.DAIRY_DATA_LIST, diaryDataListJson);
  }

}
