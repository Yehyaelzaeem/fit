
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
