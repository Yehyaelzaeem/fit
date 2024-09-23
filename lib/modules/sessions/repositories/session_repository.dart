
import 'dart:convert';

import 'package:app/core/services/local/storage_keys.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/base/repositories/base_repository.dart';
import '../../../core/models/home_page_response.dart';
import '../../../core/models/session_response.dart';
import '../../../core/models/sessions_details_response.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/local/cache_client.dart';
import '../../../core/services/network/api_client.dart';
import '../../../core/services/network/endpoints.dart';
import '../../../core/utils/shared_helper.dart';


class SessionRepository extends BaseRepository {
  final ApiClient _apiClient;
  final CacheClient _cacheClient;

  SessionRepository(this._apiClient, this._cacheClient, super.networkInfo);
  Future<Either<Failure, SessionResponse>> getSessions() async {
    return super.call<SessionResponse>(
      httpRequest: ()async{
        final result = await Connectivity().checkConnectivity();
        if (result != ConnectivityResult.none) {
          Response response = await _apiClient.get(url: EndPoints.getSessions,requestBody: {});

          return response; // Return the Response object here
        } else {
          SessionResponse? cachedSession = await readSessionsLocally();
          if (cachedSession != null) {
            return Response(requestOptions: RequestOptions(path: ''), data: cachedSession.toJson());
          } else {
            return Response(requestOptions: RequestOptions(path: ''), data: {});
          }
        }
      },
      successReturn: (data) => SessionResponse.fromJson(data),
    );
  }


  Future<dynamic> saveSessionsLocally(SessionResponse sessionResponse) async {
    _cacheClient.save(StorageKeys.sessions, jsonEncode(sessionResponse.toJson()));
  }

  Future<SessionResponse?> readSessionsLocally() async {
    String? cachedData = await _cacheClient.get(StorageKeys.sessions);

    if (cachedData != null) {
      return SessionResponse.fromJson(jsonDecode(cachedData));
    }
    return null;

  }

  Future<Either<Failure, SessionDetailsResponse>> getSessionDetails(int id) async {
    return super.call<SessionDetailsResponse>(
      httpRequest: () async {
        final result = await Connectivity().checkConnectivity();
        if (result != ConnectivityResult.none) {
          Response response = await _apiClient.get(url: '/session/$id');
          if (response.data["success"] == true) {
            await saveSessionDetailsLocally(SessionDetailsResponse.fromJson(response.data), id.toString());
            return response;
          } else {
            await saveSessionDetailsLocally(SessionDetailsResponse.fromJson(response.data), id.toString());
            return response;
          }
        } else {
          Map<String, dynamic> existingData = await readSessionDetailsLocally();
          if (existingData.containsKey(id.toString())) {
            return Response(requestOptions: RequestOptions(path: ''), data: existingData[id.toString()]);
          } else {
            return Response(requestOptions: RequestOptions(path: ''), data: {});
          }
        }
      },
      successReturn: (data) => SessionDetailsResponse.fromJson(data),
    );
  }

  Future<void> saveSessionDetailsLocally(SessionDetailsResponse response, String id) async {
    Map<String, dynamic> existingData = await readSessionDetailsLocally();
    existingData[id] = response.toJson();
    await _cacheClient.save('SESSIONS_DETAILS', jsonEncode(existingData));
  }

  Future<Map<String, dynamic>> readSessionDetailsLocally() async {
    String? details = await _cacheClient.get('SESSIONS_DETAILS');
    return details != null ? jsonDecode(details) : {};
  }


}
