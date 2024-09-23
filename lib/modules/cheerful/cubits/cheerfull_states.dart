
part of 'cheerfull_cubit.dart';

abstract class CheerFullStates {

  CheerFullStates();
}

class CheerFullInitialState extends CheerFullStates {
  CheerFullInitialState();
}

class GetCheerFullLoadingState extends CheerFullStates {
  GetCheerFullLoadingState();
}

class GetCheerFullSuccessState extends CheerFullStates {
  GetCheerFullSuccessState();
}

class GetCheerFullFailureState extends CheerFullStates {
  final Failure failure;

  GetCheerFullFailureState(this.failure);
}

class GetProductLoadingState extends CheerFullStates {
  GetProductLoadingState();
}

class GetProductSuccessState extends CheerFullStates {
  GetProductSuccessState();
}

class GetProductFailureState extends CheerFullStates {
  final Failure failure;

  GetProductFailureState(this.failure);
}
