
import 'dart:convert';

import 'package:app/core/services/local/storage_keys.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/base/repositories/base_repository.dart';
import '../../../core/models/cheer_full_response.dart';
import '../../../core/models/faq_response.dart';
import '../../../core/models/general_response.dart';
import '../../../core/models/home_page_response.dart';
import '../../../core/models/messages_response.dart';
import '../../../core/models/orientation_videos_response.dart';
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


  Future<bool> getFaqStatus() async {
    // Check if device is online
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      try {
        final response = await _apiClient.post(url:"/faq_status");
        if (response.statusCode == 200) {
          // Extract the status from the response
          bool faqStatus = response.data['data']['show_faq_page'];
          // Cache the result
          await _cacheClient.save(StorageKeys.FAQ_STATUS, faqStatus);
          return faqStatus;
        } else {
          throw Exception("Failed to fetch FAQ status");
        }
      } catch (e) {
        // Handle error if necessary
        throw Exception(e.toString());
      }
    } else {
      // Offline mode: read from cache
      bool? cachedFaqStatus = await _cacheClient.get(StorageKeys.FAQ_STATUS);
      return cachedFaqStatus ?? false;
    }
  }

  Future<bool> getOrientationVideosStatus() async {
    // Check if device is online
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      try {
        final response = await _apiClient.post(url:"/orientation_videos_status");
        if (response.statusCode == 200) {
          // Extract the status from the response
          bool videoStatus = response.data['data']['orientation_videos_status'];
          // Cache the result
          await _cacheClient.save(StorageKeys.ORIENTATION_VIDEOS_STATUS, videoStatus);
          return videoStatus;
        } else {
          throw Exception("Failed to fetch orientation video status");
        }
      } catch (e) {
        // Handle error if necessary
        throw Exception(e.toString());
      }
    } else {
      // Offline mode: read from cache
      bool? cachedVideoStatus = await _cacheClient.get(StorageKeys.ORIENTATION_VIDEOS_STATUS);
      return cachedVideoStatus ?? false;
    }
  }

  // Fetch CheerFull status, handling online and offline scenarios
  Future<CheerFullResponse> getCheerFullStatus() async {

    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      try {
        final response = await _apiClient.post(url:"/meals_features_status");

        if (response.statusCode == 200) {
          CheerFullResponse cheerFullStatus = CheerFullResponse.fromJson(response.data);
          await saveCheerFullLocally(cheerFullStatus);
          return cheerFullStatus;
        } else {
          throw Exception('Failed to fetch CheerFull status');
        }
      } catch (e) {
        throw Exception('Error fetching CheerFull status: $e');
      }
    } else {
      CheerFullResponse? cachedStatus = await readCheerFullLocally();
      return cachedStatus ?? CheerFullResponse();
    }
  }

  // Save CheerFull data locally
  Future<void> saveCheerFullLocally(CheerFullResponse cheerFullResponse) async {
    await _cacheClient.save(StorageKeys.CHEER_FULL, jsonEncode(cheerFullResponse.toJson()));
  }

  // Read CheerFull data from cache
  Future<CheerFullResponse?> readCheerFullLocally() async {
    String? cachedData = await _cacheClient.get(StorageKeys.CHEER_FULL);
    if (cachedData != null && cachedData.isNotEmpty) {
      return CheerFullResponse.fromJson(jsonDecode(cachedData));
    } else {
      return null;
    }
  }

  // Method to get FAQ data
  Future<FaqResponse> getFaqData() async {
    try {
      // Check network connection first
      final result = await Connectivity().checkConnectivity();
      if (result != ConnectivityResult.none) {
        // Fetch from API
        final response = await _apiClient.get(url:"/faq");

        if (response.statusCode == 200) {
          // Return the parsed response
          return FaqResponse.fromJson(response.data);
        } else {
          throw Exception('Failed to fetch FAQ data');
        }
      } else {
        // Optionally, handle offline cases (e.g., from cache)
        throw Exception('No internet connection');
      }
    } catch (e) {
      throw Exception('Error fetching FAQ data: $e');
    }
  }

  Future<OrientationVideosResponse> getOrientationVideos() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      final response = await _apiClient.get(url:'/orientation_videos');
      if (response.statusCode == 200) {
        final orientationVideosResponse = OrientationVideosResponse.fromJson(response.data);
        await saveOrientationVideosLocally(orientationVideosResponse);
        return orientationVideosResponse;
      } else {
        return OrientationVideosResponse(); // Handle error appropriately
      }
    } else {
      return await readOrientationVideosLocally() ?? OrientationVideosResponse();
    }
  }

  Future<void> saveOrientationVideosLocally(OrientationVideosResponse orientationVideosResponse) async {
    await _cacheClient.save(StorageKeys.ORIENTATION_VIDEOS, jsonEncode(orientationVideosResponse.toJson()));
  }

  Future<OrientationVideosResponse?> readOrientationVideosLocally() async {
    final cachedData = await _cacheClient.get(StorageKeys.ORIENTATION_VIDEOS);
    if (cachedData != null) {
      return OrientationVideosResponse.fromJson(jsonDecode(cachedData));
    }
    return null;
  }


  Future<Either<Failure, MessagesResponse>> getMessagesData() async {
    return super.call<MessagesResponse>(
      httpRequest: () async {
        final result = await Connectivity().checkConnectivity();
        if (result != ConnectivityResult.none) {
          // Fetch messages from API
          Response response = await _apiClient.get(url: "/messages");
          if (response.statusCode == 200) {
            // Save messages locally
            await saveMessagesLocally(MessagesResponse.fromJson(response.data));
            return response;
          } else {
            return response; // Handle error response
          }
        } else {
          // Fetch messages from local storage
          MessagesResponse? cachedResponse = await readMessagesLocally();
          return Response(
            requestOptions: RequestOptions(path: ''),
            data: cachedResponse?.toJson() ?? {},
          );
        }
      },
      successReturn: (data) => MessagesResponse.fromJson(data),
    );
  }

  Future<void> saveMessagesLocally(MessagesResponse messagesResponse) async {
    await _cacheClient.save(
      StorageKeys.MESSAGES,
       jsonEncode(messagesResponse.toJson()),
    );
  }

  Future<MessagesResponse?> readMessagesLocally() async {
    String? messages = await _cacheClient.get(StorageKeys.MESSAGES);
    if (messages != null && messages.isNotEmpty) {
      return MessagesResponse.fromJson(jsonDecode(messages));
    } else {
      return null;
    }
  }

  Future<Either<Failure, GeneralResponse>> deleteMessage(int id) async {
    return super.call<GeneralResponse>(
      httpRequest: () async {
        // Create form data for the request body
        FormData body = FormData.fromMap({'id': id});
        // Send POST request to delete the message
        Response response = await _apiClient.post(url: "/delete_message", requestBody: body);

        return response;
      },
      successReturn: (data) => GeneralResponse.fromJson(data),
    );
  }

}
