
part of 'shipping_details_cubit.dart';

abstract class ShippingDetailsStates {

  ShippingDetailsStates();
}

class ShippingDetailsInitialState extends ShippingDetailsStates {
  ShippingDetailsInitialState();
}

class GetShippingDetailsLoadingState extends ShippingDetailsStates {
  GetShippingDetailsLoadingState();
}

class GetShippingDetailsSuccessState extends ShippingDetailsStates {
  GetShippingDetailsSuccessState();
}

class GetShippingDetailsFailureState extends ShippingDetailsStates {
  final Failure failure;

  GetShippingDetailsFailureState(this.failure);
}

class GetProductLoadingState extends ShippingDetailsStates {
  GetProductLoadingState();
}

class GetProductSuccessState extends ShippingDetailsStates {
  GetProductSuccessState();
}

class GetProductFailureState extends ShippingDetailsStates {
  final Failure failure;

  GetProductFailureState(this.failure);
}
