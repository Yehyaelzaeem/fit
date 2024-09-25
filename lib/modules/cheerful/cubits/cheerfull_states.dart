
part of 'cheerfull_cubit.dart';

abstract class CheerFullStates {

  CheerFullStates();
}

class CheerFullInitialState extends CheerFullStates {
  CheerFullInitialState();
}
class MealLoading extends CheerFullStates {}

class MealFeaturesLoaded extends CheerFullStates {
  final MealFeatureHomeResponse mealFeatures;

  MealFeaturesLoaded({required this.mealFeatures});
}

class CheerFullStatusLoaded extends CheerFullStates {
  final CheerFullResponse cheerFullStatus;

  CheerFullStatusLoaded({required this.cheerFullStatus});
}

class MealError extends CheerFullStates {
  final String message;

  MealError({required this.message});
}