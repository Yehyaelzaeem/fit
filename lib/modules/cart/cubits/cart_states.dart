
part of 'cart_cubit.dart';

abstract class CartStates {

  CartStates();
}

class CartInitialState extends CartStates {
  CartInitialState();
}

class GetCartLoadingState extends CartStates {
  GetCartLoadingState();
}

class GetCartSuccessState extends CartStates {
  GetCartSuccessState();
}

class GetCartFailureState extends CartStates {
  final Failure failure;

  GetCartFailureState(this.failure);
}

class GetProductLoadingState extends CartStates {
  GetProductLoadingState();
}

class GetProductSuccessState extends CartStates {
  GetProductSuccessState();
}

class GetProductFailureState extends CartStates {
  final Failure failure;

  GetProductFailureState(this.failure);
}
