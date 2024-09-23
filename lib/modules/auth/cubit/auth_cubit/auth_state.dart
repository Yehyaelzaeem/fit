part of 'auth_cubit.dart';

enum AuthRequestType { none, login, registration, forgetPassword, updateFCM, sendOtp, verifyOtp, logout }

class AuthState {
  final HttpRequestState httpRequestState;
  final AuthRequestType authRequestType;
  final Failure? failure;
  final String? message;
  final UserResponse? user;
  final GeneralResponse? response;
  final String? otp;

  AuthState({
    this.httpRequestState = HttpRequestState.none,
    this.authRequestType = AuthRequestType.none,
    this.failure,
    this.message,
    this.user,
    this.response,
    this.otp,
  });

  AuthState copyWith({
    HttpRequestState? httpRequestState,
    AuthRequestType? authRequestType,
    Failure? failure,
    String? message,
    UserResponse? user,
    GeneralResponse? generalResponse,
    String? otp,
  }) =>
      AuthState(
        httpRequestState: httpRequestState ?? this.httpRequestState,
        authRequestType: authRequestType ?? this.authRequestType,
        failure: failure,
        user: user ?? this.user,
        message: message ?? this.message,
        response: generalResponse ?? this.response,
        otp: otp ?? this.otp,
      );
}
