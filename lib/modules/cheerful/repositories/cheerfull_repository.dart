
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/base/repositories/base_repository.dart';
import '../../../core/models/cheer_full_response.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/local/cache_client.dart';
import '../../../core/services/local/storage_keys.dart';
import '../../../core/services/network/api_client.dart';
import '../../../core/utils/shared_helper.dart';


class CheerFullRepository extends BaseRepository {
  final ApiClient _apiClient;
  final CacheClient _cacheClient;

  CheerFullRepository(this._apiClient, this._cacheClient, super.networkInfo);


  Future<Either<Failure, CheerFullResponse>> getCheerFullStatus() async {
    return super.call<CheerFullResponse>(
      httpRequest: () async {
        final result = await Connectivity().checkConnectivity();
        if (result != ConnectivityResult.none) {
          Response response = await _apiClient.post(url: "meals_features_status");
          if (response.statusCode == 200) {
            await saveCheerFullLocally(CheerFullResponse.fromJson(response.data));
            return response;
          } else {
            await saveCheerFullLocally(CheerFullResponse.fromJson(response.data));
            return response;
          }
        } else {
          CheerFullResponse? cachedResponse = await readCheerFullLocally();
          return Response(
            requestOptions: RequestOptions(path: ''),
            data: cachedResponse?.toJson() ?? {},
          );
        }
      },
      successReturn: (data) => CheerFullResponse.fromJson(data),
    );
  }


  Future<void> saveCheerFullLocally(CheerFullResponse response) async {
    await _cacheClient.save(StorageKeys.CheerFull, jsonEncode(response.toJson()));

  }

  Future<CheerFullResponse?> readCheerFullLocally() async {
    String? units = await _cacheClient.get(StorageKeys.CheerFull);
    return units != null ? CheerFullResponse.fromJson(jsonDecode(units)) : null;
  }

  Future<Either<Failure, bool>> getFaqStatus() async {
    return super.call<bool>(
      httpRequest: () async {
        final result = await Connectivity().checkConnectivity();
        if (result != ConnectivityResult.none) {
          Response response = await _apiClient.post(url: "faq_status");
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
