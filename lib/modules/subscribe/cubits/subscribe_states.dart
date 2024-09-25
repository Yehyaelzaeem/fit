
part of 'subscribe_cubit.dart';
abstract class SubscribeState {}

class SubscribeInitial extends SubscribeState {}

class ServicesLoading extends SubscribeState {}

class ServicesLoaded extends SubscribeState {
  final ServicesResponse servicesResponse;

  ServicesLoaded({required this.servicesResponse});
}

class ServicesError extends SubscribeState {
  final String message;

  ServicesError({required this.message});
}

class PaymentLoading extends SubscribeState {}

class PaymentSuccess extends SubscribeState {
  final PackagePaymentResponse paymentResponse;

  PaymentSuccess({required this.paymentResponse});
}

class PaymentError extends SubscribeState {
  final String message;

  PaymentError({required this.message});
}