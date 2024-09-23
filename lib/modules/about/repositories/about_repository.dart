import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../../../core/models/about_response.dart';
import '../../../core/services/local/cache_client.dart';
import '../../../core/services/local/storage_keys.dart';
import '../../../core/services/network/api_client.dart';

class AboutRepository {
  final CacheClient _cacheClient;  // Assuming you're using a cache client.
  final ApiClient _apiClient;      // Assuming this is your API client utility.

  AboutRepository({required CacheClient cacheClient, required ApiClient apiClient})
      : _cacheClient = cacheClient,
        _apiClient = apiClient;

  Future<AboutResponse> getAboutData() async {
    final result = await Connectivity().checkConnectivity();

    if (result != ConnectivityResult.none) {
      Response response = await _apiClient.get(url: "/about");

      if (response.statusCode == 200) {
        final aboutData = AboutResponse.fromJson(response.data);
        await saveAboutLocally(aboutData);
        return aboutData;
      } else {
        throw Exception("Error fetching about data from API");
      }
    } else {
      // Fetch from cache if offline
      AboutResponse? cachedAbout = await readAboutLocally();
      return cachedAbout ?? AboutResponse();  // Return default if no cached data.
    }
  }

  // Function to save about data locally
  Future<void> saveAboutLocally(AboutResponse aboutResponse) async {
    await _cacheClient.save(StorageKeys.ABOUT, jsonEncode(aboutResponse.toJson()));
  }

  // Function to read about data locally
  Future<AboutResponse?> readAboutLocally() async {
    String? cachedData = await _cacheClient.get(StorageKeys.ABOUT);
    if (cachedData != null) {
      return AboutResponse.fromJson(jsonDecode(cachedData));
    }
    return null;
  }
}