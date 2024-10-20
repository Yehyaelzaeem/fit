
part of 'usual_cubit.dart';

abstract class UsualStates {

  UsualStates();
}

class UsualInitialState extends UsualStates {
  UsualInitialState();
}

class GetUsualLoadingState extends UsualStates {
  GetUsualLoadingState();
}

class GetUsualSuccessState extends UsualStates {
  GetUsualSuccessState();
}

class GetUsualFailureState extends UsualStates {
  final Failure failure;

  GetUsualFailureState(this.failure);
}
class UsualInitial extends UsualStates {}

class UsualLoading extends UsualStates {}

class UsualLoaded extends UsualStates {
  UsualLoaded();
}

class UsualError extends UsualStates {
  final String message;
  UsualError(this.message);
}

class UsualMealCreating extends UsualStates {}


class MealsLoading extends UsualStates {}

class MealsLoaded extends UsualStates {
  final UsualMealsResponse mealsResponse;

  MealsLoaded(this.mealsResponse);
}

class MealsError extends UsualStates {
  final String message;

  MealsError(this.message);
}