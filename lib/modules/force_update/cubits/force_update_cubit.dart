

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/version_response.dart';
import '../../../core/services/error/failure.dart';
import '../repositories/force_update_repository.dart';
part 'force_update_states.dart';

class ForceUpdateCubit extends Cubit<ForceUpdateState> {
  final AppUpdateRepository _appUpdateRepository;

  ForceUpdateCubit(this._appUpdateRepository) : super(ForceUpdateInitialState());

  Future<void> getAppVersion() async {
    emit(ForceUpdateLoadingState());

    final result = await _appUpdateRepository.fetchAppVersion();

    result.fold(
          (failure) {
        emit(ForceUpdateFailureState(failure));
      },
          (versionResponse) {
        if (versionResponse.forceUpdate) {
          emit(HomeForceUpdate(versionResponse));
        } else {
          emit(HomeVersionFetched(versionResponse));
        }
      },
    );
  }

}