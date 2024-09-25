
part of 'diary_cubit.dart';

abstract class DiaryState {}

class DiaryInitial extends DiaryState {}

class DiaryLoading extends DiaryState {}

class DiarySuccess extends DiaryState {
  DiarySuccess();
}

class DiaryFailure extends DiaryState {
  final Failure failure;

  DiaryFailure(this.failure);
}


class DiaryLoaded extends DiaryState {}

class DiaryError extends DiaryState {
  final String message;
  DiaryError(this.message);
}


class DiaryLoadedOtherCalories extends DiaryState {
  DiaryLoadedOtherCalories();
}

class DiaryLoadedOtherCaloriesUnits extends DiaryState {
  final MyOtherCaloriesUnitsResponse response;
  DiaryLoadedOtherCaloriesUnits(this.response);
}
