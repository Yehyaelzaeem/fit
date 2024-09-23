part of 'social_auth_cubit.dart';

enum SocialAuthRequestType { none, googleSignIn, facebookSignIn, appleSignIn }

class SocialAuthState {
  final HttpRequestState httpRequestState;
  final SocialAuthRequestType socialAuthRequestType;
  final Failure? failure;
  final String? message;
  final UserModel? user;

  SocialAuthState({
    this.httpRequestState = HttpRequestState.none,
    this.socialAuthRequestType = SocialAuthRequestType.none,
    this.failure,
    this.message,
    this.user,
  });

  SocialAuthState copyWith({
    HttpRequestState? httpRequestState,
    SocialAuthRequestType? socialAuthRequestType,
    Failure? failure,
    String? message,
    UserModel? user,
  }) =>
      SocialAuthState(
        httpRequestState: httpRequestState ?? this.httpRequestState,
        socialAuthRequestType: socialAuthRequestType ?? this.socialAuthRequestType,
        failure: failure,
        user: user ?? this.user,
        message: message ?? this.message,
      );
}
