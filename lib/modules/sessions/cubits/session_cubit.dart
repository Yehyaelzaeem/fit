import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/cheer_full_response.dart';
import '../../../core/models/home_page_response.dart';
import '../../../core/models/session_response.dart';
import '../../../core/models/sessions_details_response.dart';
import '../../../core/models/user_response.dart';
import '../../../core/models/version_response.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/utils/shared_helper.dart';
import '../../diary/cubits/diary_cubit.dart';
import '../repositories/session_repository.dart';

part 'session_states.dart';

class SessionCubit extends Cubit<SessionStates> {
  final SessionRepository _sessionRepository;

  SessionCubit(this._sessionRepository) : super(SessionInitialState());

  SessionResponse? sessionResponse;
  SessionDetailsResponse? sessionDetailsResponse;
  Future<void> getSessions() async {
    emit(GetSessionLoadingState());

    final result = await _sessionRepository.getSessions();

    result.fold(
          (failure) => emit(GetSessionFailureState(failure)),
          (session) {
            sessionResponse = session;
        emit(GetSessionSuccessState());
      },
    );
  }

  Future<void> getSessionsAll() async {

    final result = await _sessionRepository.getSessions();

    result.fold(
          (failure) => emit(GetSessionFailureState(failure)),
          (session) {
            sessionResponse = session;
            sessionResponse!.data!.forEach((element) {
              fetchSessionDetails(element.id);
            }); 
      },
    );
  }

  Future<void> fetchSessionDetails(int? id) async {
    emit(GetSessionDetailsLoadingState());

      final result = await _sessionRepository.getSessionDetails(id!);
      result.fold(
            (failure) => emit(GetSessionDetailsFailureState(failure)),
            (sessionDetails) {
          sessionDetailsResponse = sessionDetails;
          emit(GetSessionDetailsSuccessState());
        },
      );

  }

}
