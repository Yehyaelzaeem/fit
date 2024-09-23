part of 'notifications_cubit.dart';

abstract class NotificationsStates {}

class NotificationsInitialState extends NotificationsStates {}

class GetNotificationsLoadingState extends NotificationsStates {}

class GetNotificationsSuccessState extends NotificationsStates {

}

class GetNotificationsFailureState extends NotificationsStates {
  final Failure failure;

  GetNotificationsFailureState(this.failure);
}

