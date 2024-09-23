
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/base/repositories/base_repository.dart';
import '../../../core/models/home_page_response.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/local/cache_client.dart';
import '../../../core/services/network/api_client.dart';
import '../../../core/services/network/endpoints.dart';
import '../../../core/utils/shared_helper.dart';


class HomeRepository extends BaseRepository {
  final ApiClient _apiClient;
  final CacheClient _cacheClient;

  HomeRepository(this._apiClient, this._cacheClient, super.networkInfo);

  Future<Either<Failure, HomePageResponse>> getHomePageData({bool notLogged = false}) async {
    return super.call<HomePageResponse>(
      httpRequest: () async {
        final result = await Connectivity().checkConnectivity();
        if (result != ConnectivityResult.none && ((loadingHome == null || loadingHome!.isBefore(getEgyptTime().subtract(Duration(minutes: 6)))) || !notLogged)) {
          final response = await _apiClient.get(url: EndPoints.home,requestBody: {});
          loadingHome = getEgyptTime();
          await saveHomeDataLocally(HomePageResponse.fromJson(response.data));
          return response;
        } else {
          final cachedData = await readHomeDataLocally();
          if (cachedData != null) {
            final response = Response(
              data: cachedData.toJson(),
              statusCode: 200,
              requestOptions: RequestOptions(path: EndPoints.home),
            );
            return response;
          } else {
            throw Exception("No cached data available");
          }
        }
      },
      successReturn: (data) => HomePageResponse.fromJson(data),
    );
  }

  Future<void> saveHomeDataLocally(HomePageResponse homePageResponse) async {
    await SharedHelper().writeData(CachingKey.HOME, jsonEncode(homePageResponse.toJson()));
  }

  Future<HomePageResponse?> readHomeDataLocally() async {
    String? home = await SharedHelper().readString(CachingKey.HOME);
    if (home != null && home != '') {
      return HomePageResponse.fromJson(jsonDecode(home));
    } else {
      return null;
    }
  }

}
