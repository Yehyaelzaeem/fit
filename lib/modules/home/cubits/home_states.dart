
part of 'home_cubit.dart';

abstract class HomeStates {

  HomeStates();
}

class HomeInitialState extends HomeStates {
  HomeInitialState();
}

class GetHomeLoadingState extends HomeStates {
  GetHomeLoadingState();
}

class GetHomeSuccessState extends HomeStates {
  GetHomeSuccessState();
}

class GetHomeFailureState extends HomeStates {
  final Failure failure;

  GetHomeFailureState(this.failure);
}

class HomePageLoadingState extends HomeStates {
  HomePageLoadingState();
}

class HomePageSuccessState extends HomeStates {
  HomePageSuccessState();
}

class HomePageFailureState extends HomeStates {
  final Failure failure;

  HomePageFailureState(this.failure);
}

class GetProductDetailsLoadingState extends HomeStates {
  GetProductDetailsLoadingState();
}

class GetProductDetailsSuccessState extends HomeStates {
  GetProductDetailsSuccessState();
}

class GetProductDetailsFailureState extends HomeStates {
  final Failure failure;

  GetProductDetailsFailureState(this.failure);
}

class GetSubLoadingState extends HomeStates {
  GetSubLoadingState();
}

class GetSubSuccessState extends HomeStates {
  GetSubSuccessState();
}

class GetSubFailureState extends HomeStates {
  final Failure failure;

  GetSubFailureState(this.failure);
}
class SendReportLoadingState extends HomeStates {
  SendReportLoadingState();
}

class SendReportSuccessState extends HomeStates {
  SendReportSuccessState();
}

class SendReportFailureState extends HomeStates {
  final Failure failure;

  SendReportFailureState(this.failure);
}

class FaqLoading extends HomeStates {
  FaqLoading();
}

class FaqLoaded extends HomeStates {
  FaqLoaded();
}

class FaqError extends HomeStates {
  final Failure failure;

  FaqError(this.failure);
}


class OrientationLoading extends HomeStates {}

class OrientationLoaded extends HomeStates {
  final OrientationVideosResponse orientationVideosResponse;
  OrientationLoaded(this.orientationVideosResponse);
}

class OrientationError extends HomeStates {
  final String message;
  OrientationError(this.message);
}
class MessagesLoading extends HomeStates {}

class MessagesLoaded extends HomeStates {
  MessagesLoaded();
}

class MessagesError extends HomeStates {
  final String message;
  MessagesError(this.message);
}


class MessageDetailsLoading extends HomeStates {}

class MessageDetailsLoaded extends HomeStates {}

class MessageDetailsError extends HomeStates {
  final String errorMessage;
  MessageDetailsError(this.errorMessage);
}

class MessagesDeleting extends HomeStates {}

class MessagesDeleted extends HomeStates {
  MessagesDeleted();
}

class MessagesDeleteError extends HomeStates {
  final String message;
  MessagesDeleteError(this.message);
}