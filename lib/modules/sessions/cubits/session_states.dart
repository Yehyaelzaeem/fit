
part of 'session_cubit.dart';

abstract class SessionStates {

  SessionStates();
}

class SessionInitialState extends SessionStates {
  SessionInitialState();
}

class GetSessionLoadingState extends SessionStates {
  GetSessionLoadingState();
}

class GetSessionSuccessState extends SessionStates {
  GetSessionSuccessState();
}

class GetSessionFailureState extends SessionStates {
  final Failure failure;

  GetSessionFailureState(this.failure);
}

class GetSessionDetailsLoadingState extends SessionStates {
  GetSessionDetailsLoadingState();
}

class GetSessionDetailsSuccessState extends SessionStates {
  GetSessionDetailsSuccessState();
}

class GetSessionDetailsFailureState extends SessionStates {
  final Failure failure;

  GetSessionDetailsFailureState(this.failure);
}
