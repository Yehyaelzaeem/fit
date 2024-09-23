import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enums/http_request_state.dart';
import '../../../core/models/user_response.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/utils/globals.dart';
import '../models/requests/update_profile_body.dart';
import '../repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(ProfileState());


  UserResponse ress = UserResponse();
  late int newMessage = 0;
  var isPortrait;


  Future<void> getProfile() async {
    emit(state.copyWith(
      profileRequestType: ProfileRequestType.getCurrentUser,
      httpRequestState: HttpRequestState.loading,
    ));

    final result = await _profileRepository.getCurrentUser();
    result.fold(
          (failure) => emit(state.copyWith(failure: failure, httpRequestState: HttpRequestState.failure)),
          (userModel) {
        currentUser = userModel;
        emit(state.copyWith(user: userModel, httpRequestState: HttpRequestState.success));
      },
    );
  }

  // Future<void> getProfile() async {
  //   emit(state.copyWith(
  //     profileRequestType: ProfileRequestType.getCurrentUser,
  //     httpRequestState: HttpRequestState.loading,
  //   ));
  //   final result = await _profileRepository.getCurrentUser();
  //   result.fold(
  //     (failure) => emit(state.copyWith(failure: failure, httpRequestState: HttpRequestState.failure)),
  //     (userModel) {
  //       currentUser = userModel;
  //
  //       emit(state.copyWith(user: userModel, httpRequestState: HttpRequestState.success));
  //     },
  //   );
  // }

  Future<void> updateProfile(UpdateProfileBody updateProfileBody) async {
    emit(state.copyWith(
      profileRequestType: ProfileRequestType.updateProfile,
      httpRequestState: HttpRequestState.loading,
    ));
    final result = await _profileRepository.updateProfile(updateProfileBody);
    result.fold(
          (failure) => emit(state.copyWith(failure: failure, httpRequestState: HttpRequestState.failure)),
          (userModel) {
            currentUser = userModel;
            emit(state.copyWith(
            user: userModel, httpRequestState: HttpRequestState.success));
      },
    );
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(profileRequestType: ProfileRequestType.deleteAccount, httpRequestState: HttpRequestState.loading));
    final result = await _profileRepository.deleteAccount();
    result.fold(
          (failure) => emit(state.copyWith(failure: failure, httpRequestState: HttpRequestState.failure)),
          (message) {
            currentUser = null;
            emit(state.copyWith(message: message, httpRequestState: HttpRequestState.success));
          },
    );
  }


}
