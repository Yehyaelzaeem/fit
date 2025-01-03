import 'package:dio/dio.dart';

import '../utils/shared_helper.dart';
// import 'package:dio/dio.dart';

class NetworkUtil {
  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();

  String base_url = "https://fofclinic.com/api/";
  // String base_url = "https://dev02.matrix-clouds.com/fofclinic/public/api/";
  Dio dio = Dio();

  factory NetworkUtil() => _instance;

  Future<Response> get(String url) async {
    var _token = await SharedHelper().readString(CachingKey.TOKEN);
    print('Token >>> $_token');

    Map<String, dynamic> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "x-api-key": "FitoverfaT_clinic_api_key",
      'Authorization': 'Bearer $_token',
    };

    var response;
    try {
      dio.options.baseUrl = base_url;
      response = await dio.get(url, options: Options(headers: headers));
    } on DioError catch (e) {
      if (e.response != null) {
        response = e.response;
        print("RESS" + e.response.toString());
      } else {
        print("Error " + e.stackTrace.toString());
      }
    }
    return handleResponse(response);
  }

  Future<Response> post(String url, {FormData? body, encoding}) async {
    var _token = await SharedHelper().readString(CachingKey.TOKEN);
    print('Token >>> $_token');

    Map<String, dynamic> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "x-api-key": "FitoverfaT_clinic_api_key",
      'Authorization': 'Bearer $_token',
    };

    var response;
    dio.options.baseUrl = base_url;
    try {
      response = await dio.post(url,
          data: body,
          options: Options(headers: headers, requestEncoder: encoding));
    } on DioError catch (e) {
      if (e.response != null) {
        response = e.response;
        print("RESS" + e.response.toString());
      } else {
//        print("LAAAAAA " + e.stackTrace.toString());
      }
      return handleResponse(e.response);
    }

    return handleResponse(response);
  }

  Future<Response> delete(String url) {
    Map<String, dynamic> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    return dio
        .delete(
      url,
      options: Options(headers: headers),
    )
        .then((Response response) {
      return handleResponse(response);
    });
  }

  Future<Response> put(String url, {body, encoding}) {
    Map<String, dynamic> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    return dio
        .put(url,
            data: body,
            options: Options(headers: headers, requestEncoder: encoding))
        .then((Response response) {
      return handleResponse(response);
    });
  }

  Response handleResponse(var response) {
    int? statusCode = response.statusCode;
    print("RESPONSE : " + response.toString());
    if (statusCode == 401) {
      SharedHelper helper = SharedHelper();
      // helper.logout();
      throw new Exception("Unauthorized");
    } else if (statusCode != 200) {
//      throw new Exception("Error while fetching data");
    }

    if (statusCode! >= 200 && statusCode < 300) {
      return response;
    } else {
      return response;
    }
  }
}
