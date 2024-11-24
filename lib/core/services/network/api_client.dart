import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../resources/resources.dart';
import '../../utils/constants.dart';
import '../local/cache_client.dart';
import '../local/storage_keys.dart';

// const String _baseURL = "https://fofclinic.com/api";
const String _baseURL = "https://dev02.matrix-clouds.com/fofclinic/public/api";
const String _xApiKey = "FitoverfaT_clinic_api_key";
const String _apiKey = "";
const String _contentType = "Content-Type";
const String _accept = "accept";
const String _applicationJson = "application/json";
const String _contentLanguage = "Accept-Language";
const String _authorization = "Authorization";

class ApiClient {
  final Dio _dio;
  final CacheClient _cacheClient;
  final Interceptor _prettyDioLogger;

  ApiClient(this._dio, this._cacheClient, this._prettyDioLogger) {
    final BaseOptions baseOptions = BaseOptions(
      baseUrl: _baseURL,
      receiveDataWhenStatusError: true,
      connectTimeout: Time.t30s,
      receiveTimeout: Time.t30s,
      sendTimeout: Time.t30s,
      headers: {
        _contentType: _applicationJson,
        _accept: _applicationJson,
        _contentLanguage: _cacheClient.get(StorageKeys.appLocale) ?? 'ar',
        _xApiKey: _xApiKey,
      },
    );

    _dio.options = baseOptions;

    if (kDebugMode) _dio.interceptors.add(_prettyDioLogger);
  }

  void changeLocale(String languageCode) => _dio.options.headers[_contentLanguage] = languageCode;

  Future<Response> get({
    required String url,
    Map<String, dynamic>? queryParameters, requestBody,
  }) async {
    final String? token = await _cacheClient.get(StorageKeys.token);
    return await _dio.get(
      url,
      queryParameters: queryParameters,
      options: Options(
        headers: {
          "x-api-key": "FitoverfaT_clinic_api_key",
          _authorization: token != null ? "Bearer $token" : Constants.empty,
        },
      ),
    );
  }

  Future<Response> post({
    required String url,
     var requestBody,
    Map<String, dynamic>? queryParameters,
  }) async {
    final String? token = await _cacheClient.get(StorageKeys.token);

    return await _dio.post(
      url,
      queryParameters: queryParameters,
      data: requestBody,
      options: Options(
        headers: {
          "x-api-key": "FitoverfaT_clinic_api_key",
          _authorization: token != null ? "Bearer $token" : Constants.empty,
        },
      ),
    );
  }

  Future<Response> update({
    required String url,
    required var requestBody,
    Map<String, dynamic>? queryParameters,
  }) async {
    final String? token = await _cacheClient.get(StorageKeys.token);
    return await _dio.put(
      url,
      queryParameters: queryParameters,
      data: requestBody,
      options: Options(
        headers: {
          "x-api-key": "FitoverfaT_clinic_api_key",
          _authorization: token != null ? "Bearer $token" : Constants.empty,
        },
      ),
    );
  }

  Future<Response> delete({
    required String url,
    var requestBody,
    Map<String, dynamic>? queryParameters,
  }) async {
    final String? token = await _cacheClient.get(StorageKeys.token);
    return await _dio.delete(
      url,
      queryParameters: queryParameters,
      data: requestBody,
      options: Options(
        headers: {
          "x-api-key": "FitoverfaT_clinic_api_key",
          _authorization: token != null ? "Bearer $token" : Constants.empty,
        },
      ),
    );
  }
}
