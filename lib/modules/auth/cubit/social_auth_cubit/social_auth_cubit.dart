import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/http_request_state.dart';
import '../../../../core/utils/globals.dart';
import '../../../../core/services/error/failure.dart';
import '../../../profile/models/responses/user_model.dart';
import '../../repositories/social_auth_repository.dart';

part 'social_auth_state.dart';

class SocialAuthCubit extends Cubit<SocialAuthState> {
  final SocialAuthRepository _socialAuthRepository;

  SocialAuthCubit(this._socialAuthRepository) : super(SocialAuthState());

  // Future<void> googleSignIn() async {
  //   final account = await _socialAuthRepository.getGoogleAccount();
  //   if (account == null) return;
  //   emit(SocialAuthState(httpRequestState: HttpRequestState.loading,socialAuthRequestType: SocialAuthRequestType.googleSignIn));
  //   final result = await _socialAuthRepository.googleSignIn(account);
  //   result.fold(
  //     (failure) => emit(state.copyWith(failure: failure, httpRequestState: HttpRequestState.failure)),
  //     (userModel) {
  //       currentUser = userModel;
  //       emit(state.copyWith(user: userModel, httpRequestState: HttpRequestState.success));
  //     },
  //   );
  // }
  //
  // Future<void> facebookSignIn() async {
  //   final userData = await _socialAuthRepository.getFacebookAccount();
  //   emit(SocialAuthState(httpRequestState: HttpRequestState.loading,socialAuthRequestType: SocialAuthRequestType.facebookSignIn));
  //   final result = await _socialAuthRepository.facebookSignIn(userData);
  //   result.fold(
  //     (failure) => emit(state.copyWith(failure: failure, httpRequestState: HttpRequestState.failure)),
  //     (user) {
  //       currentUser = user;
  //       emit(state.copyWith(user: user, httpRequestState: HttpRequestState.success));
  //     },
  //   );
  // }

  // Future<void> appleSignIn() async {
  //   final credentials = await _socialAuthRepository.getAppleCredentials();
  //   emit(AppleAuthLoadingState());
  //   final result = await _socialAuthRepository.appleSignIn(credentials);
  //   result.fold(
  //     (failure) => emit(AppleAuthFailureState(failure)),
  //     (user) {
  //       currentUser = user;
  //       emit(AppleAuthSuccessState());
  //     },
  //   );
  // }
}
