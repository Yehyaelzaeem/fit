
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
  final UsualMealsDataResponse data;
  UsualLoaded(this.data);
}

class UsualError extends UsualStates {
  final String message;
  UsualError(this.message);
}

class UsualMealCreating extends UsualStates {}