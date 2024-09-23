
part of 'my_meals_cubit.dart';

abstract class MyMealsStates {

  MyMealsStates();
}

class MyMealsInitialState extends MyMealsStates {
  MyMealsInitialState();
}

class GetMyMealsLoadingState extends MyMealsStates {
  GetMyMealsLoadingState();
}

class GetMyMealsSuccessState extends MyMealsStates {
  GetMyMealsSuccessState();
}

class GetMyMealsFailureState extends MyMealsStates {
  final Failure failure;

  GetMyMealsFailureState(this.failure);
}

class GetProductLoadingState extends MyMealsStates {
  GetProductLoadingState();
}

class GetProductSuccessState extends MyMealsStates {
  GetProductSuccessState();
}

class GetProductFailureState extends MyMealsStates {
  final Failure failure;

  GetProductFailureState(this.failure);
}
