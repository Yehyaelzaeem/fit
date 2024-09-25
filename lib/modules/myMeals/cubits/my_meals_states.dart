
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

class MyMealsInitial extends MyMealsStates {}

class MyMealsLoading extends MyMealsStates {}

class MyMealsLoaded extends MyMealsStates {
  final MyMealResponse myMeals;
  MyMealsLoaded(this.myMeals);
}

class MyMealsError extends MyMealsStates {
  final String error;

  MyMealsError(this.error);
}
// Meal Details States
  class MealDetailsLoading extends MyMealsStates {}

  class MealDetailsLoaded extends MyMealsStates {
  MealDetailsLoaded();
  }

  class MealDetailsError extends MyMealsStates {
  final String error;
  MealDetailsError(this.error);
  }