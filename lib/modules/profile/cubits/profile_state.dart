part of 'profile_cubit.dart';

enum ProfileRequestType { none, getCurrentUser, forgetPassword, deleteAccount, getProfile, updateProfile }

class ProfileState {
  final HttpRequestState httpRequestState;
  final ProfileRequestType profileRequestType;
  final Failure? failure;
  final String? message;
  final UserResponse? user;

  ProfileState({
    this.httpRequestState = HttpRequestState.none,
    this.profileRequestType = ProfileRequestType.none,
    this.failure,
    this.message,
    this.user,
  });

  ProfileState copyWith({
    HttpRequestState? httpRequestState,
    ProfileRequestType? profileRequestType,
    Failure? failure,
    String? message,
    UserResponse? user,
  }) =>
      ProfileState(
        httpRequestState: httpRequestState ?? this.httpRequestState,
        profileRequestType: profileRequestType ?? this.profileRequestType,
        failure: failure,
        message: message,
        user: user ?? this.user,
      );
}


