
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/base/repositories/base_repository.dart';
import '../../../core/models/cheer_full_response.dart';
import '../../../core/models/meal_features_status_response.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/local/cache_client.dart';
import '../../../core/services/local/storage_keys.dart';
import '../../../core/services/network/api_client.dart';
import '../../../core/utils/shared_helper.dart';


class CheerFullRepository extends BaseRepository {
  final ApiClient _apiClient;
  final CacheClient _cacheClient;

  CheerFullRepository(this._apiClient, this._cacheClient, super.networkInfo);

  // Get meal features home from API
  Future<MealFeatureHomeResponse> getMealFeaturesHome() async {
    Response response = await _apiClient.post(url:"/meals_features_home");

    if (response.statusCode == 200) {
      return MealFeatureHomeResponse.fromJson(response.data);
    } else {
      throw Exception("Error fetching meal features home");
    }
  }

  // Get cheerful status from API or local cache
  Future<CheerFullResponse> getCheerFullStatus() async {
    final result = await Connectivity().checkConnectivity();

    if (result != ConnectivityResult.none) {
      Response response = await _apiClient.post(url:"/meals_features_status");

      if (response.statusCode == 200) {
        final cheerFullResponse = CheerFullResponse.fromJson(response.data);
        await saveCheerFullLocally(cheerFullResponse);
        return cheerFullResponse;
      } else {
        throw Exception("Error fetching cheer full status from API");
      }
    } else {
      // Fetch from local cache if offline
      CheerFullResponse? cachedCheerFull = await readCheerFullLocally();
      if (cachedCheerFull != null) {
        return cachedCheerFull;
      } else {
        throw Exception("No cheer full data available offline");
      }
    }
  }

  // Save cheerful status locally
  Future<void> saveCheerFullLocally(CheerFullResponse cheerFullResponse) async {
    await _cacheClient.save(StorageKeys.CHEER_FULL, jsonEncode(cheerFullResponse.toJson()));
  }

  // Read cheerful status from local cache
  Future<CheerFullResponse?> readCheerFullLocally() async {
    String? cachedData = await _cacheClient.get(StorageKeys.CHEER_FULL);
    if (cachedData != null && cachedData.isNotEmpty) {
      return CheerFullResponse.fromJson(jsonDecode(cachedData));
    }
    return null;
  }

  Future<Either<Failure, bool>> getFaqStatus() async {
    return super.call<bool>(
      httpRequest: () async {
        final result = await Connectivity().checkConnectivity();
        if (result != ConnectivityResult.none) {
          Response response = await _apiClient.post(url: "/faq_status");
          if (response.statusCode == 200) {
            bool status = response.data['data']['show_faq_page'];
            await SharedHelper().writeData(CachingKey.FAQ_STATUS, status);
            return Response(
              requestOptions: RequestOptions(path: ''),
              data: status,
            );
          } else {
            bool status = response.data['data']['show_faq_page'];
            await _cacheClient.save(StorageKeys.FAQ_STATUS, status);
            return Response(
              requestOptions: RequestOptions(path: ''),
              data: status,
            );
          }
        } else {
          bool? cachedStatus = await _cacheClient.get(StorageKeys.FAQ_STATUS);
          return Response(
            requestOptions: RequestOptions(path: ''),
            data: cachedStatus ?? false,
          );
        }
      },
      successReturn: (data) => data as bool,
    );
  }


}
