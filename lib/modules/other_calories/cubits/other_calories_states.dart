part of 'other_calories_cubit.dart';

abstract class OtherCaloriesStates {}

class DiaryInitial extends OtherCaloriesStates {}

class OtherCaloriesLoading extends OtherCaloriesStates {}

class DiarySuccess extends OtherCaloriesStates {
  final String message;

  DiarySuccess(this.message);
}

class OtherCaloriesError extends OtherCaloriesStates {
  final String message;

  OtherCaloriesError(this.message);
}
