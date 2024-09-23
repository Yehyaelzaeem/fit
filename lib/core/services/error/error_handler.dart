import 'package:dio/dio.dart';

import 'failure.dart';

class ErrorHandler {
  late Failure failure;

  ErrorHandler.handle(Exception error) {
    if (error is DioError) {
      failure = _handleDioError(error);
    } else {
      failure = Failure(ResponseCode.unKnown, error.toString().substring(11));
    }
  }

  Failure _handleDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.connectionTimeout:
        return ErrorType.connectionTimeout.getFailure();
      case DioErrorType.sendTimeout:
        return ErrorType.sendTimeOut.getFailure();
      case DioErrorType.receiveTimeout:
        return ErrorType.receiveTimeOut.getFailure();
      case DioErrorType.badCertificate:
        return ErrorType.badCertificate.getFailure();
      case DioErrorType.cancel:
        return ErrorType.cancel.getFailure();
      case DioErrorType.badResponse:
        {
          if (dioError.response?.statusMessage != null && dioError.response?.statusCode != null) {
            return Failure(dioError.response!.statusCode!, dioError.response!.data["message"]);
          } else {
            return ErrorType.unKnown.getFailure();
          }
        }
      case DioErrorType.connectionError:
        return ErrorType.noInternetConnection.getFailure();
      case DioErrorType.unknown:
        return ErrorType.unKnown.getFailure();
      default:
        return ErrorType.unKnown.getFailure();
    }
  }
}

enum ErrorType {
  cancel,
  connectionTimeout,
  receiveTimeOut,
  sendTimeOut,
  noInternetConnection,
  badCertificate,
  unKnown,
}

extension ErrorTypeException on ErrorType {
  Failure getFailure() {
    switch (this) {
      case ErrorType.connectionTimeout:
        return Failure(ResponseCode.connectTimeOut, ResponseMessage.connectTimeOut);
      case ErrorType.cancel:
        return Failure(ResponseCode.cancel, ResponseMessage.cancel);
      case ErrorType.receiveTimeOut:
        return Failure(ResponseCode.receiveTimeOut, ResponseMessage.receiveTimeOut);
      case ErrorType.sendTimeOut:
        return Failure(ResponseCode.sendTimeOut, ResponseMessage.sendTimeOut);
      case ErrorType.noInternetConnection:
        return Failure(ResponseCode.noInternetConnection, ResponseMessage.noInternetConnection);
      case ErrorType.badCertificate:
        return Failure(ResponseCode.noInternetConnection, ResponseMessage.noInternetConnection);
      case ErrorType.unKnown:
        return Failure(ResponseCode.unKnown, ResponseMessage.unKnown);
    }
  }
}

class ResponseCode {
  static const int cancel = -1;
  static const int connectTimeOut = -2;
  static const int receiveTimeOut = -3;
  static const int sendTimeOut = -4;
  static const int noInternetConnection = -5;
  static const int badCertificate = -6;
  static const int unKnown = -7;
}

class ResponseMessage {
  static const String cancel = "Request was cancelled, try again.";
  static const String connectTimeOut = "Time out error, try again.";
  static const String receiveTimeOut = "Receive time error, try again.";
  static const String sendTimeOut = "Time out error, try again.";
  static const String noInternetConnection = "Please check your internet connection.";
  static const String badCertificate = "Error validating certificate, try again later.";
  static const String unKnown = "Something went wrong, try again.";
}
