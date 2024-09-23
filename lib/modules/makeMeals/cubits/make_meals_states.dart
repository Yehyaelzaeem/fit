
part of 'make_meals_cubit.dart';

abstract class MakeMealsStates {

  MakeMealsStates();
}

class MakeMealsInitialState extends MakeMealsStates {
  MakeMealsInitialState();
}

class GetMakeMealsLoadingState extends MakeMealsStates {
  GetMakeMealsLoadingState();
}

class GetMakeMealsSuccessState extends MakeMealsStates {
  GetMakeMealsSuccessState();
}

class GetMakeMealsFailureState extends MakeMealsStates {
  final Failure failure;

  GetMakeMealsFailureState(this.failure);
}

class GetProductLoadingState extends MakeMealsStates {
  GetProductLoadingState();
}

class GetProductSuccessState extends MakeMealsStates {
  GetProductSuccessState();
}

class GetProductFailureState extends MakeMealsStates {
  final Failure failure;

  GetProductFailureState(this.failure);
}
