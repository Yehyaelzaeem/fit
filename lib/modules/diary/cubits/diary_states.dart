
part of 'diary_cubit.dart';

abstract class DiaryState {}

class DiaryInitial extends DiaryState {}

class DiaryLoading extends DiaryState {}
class DiaryCachingLoading extends DiaryState {}

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


class CalorieLoading extends DiaryState {}

class CalorieDeletedSuccess extends DiaryState {
  final String message;

  CalorieDeletedSuccess(this.message);
}

class CalorieDeletedFailure extends DiaryState {
  final String errorMessage;

  CalorieDeletedFailure(this.errorMessage);
}
class FavoriteCalorieDeleted extends DiaryState {
  final String errorMessage;

  FavoriteCalorieDeleted(this.errorMessage);
}


// Adding Favorite Calorie States
class FavoriteCalorieAdding extends DiaryState {} // When adding a favorite is in progress
class FavoriteCalorieAdded extends DiaryState {} // When a favorite is added successfully online
class FavoriteCalorieAddedOffline extends DiaryState {} // When a favorite is added successfully offline

// Deleting Favorite Calorie States
class FavoriteCalorieDeleting extends DiaryState {} // When deleting a favorite is in progress
class FavoriteCalorieDeletedOffline extends DiaryState {} // When a favorite is deleted successfully offline

// Syncing Favorite Actions States
class FavoriteActionsSyncing extends DiaryState {} // When syncing favorite actions is in progress
class FavoriteActionsSynced extends DiaryState {} // When syncing favorite actions is completed successfully
class FavoriteActionsSyncFailed extends DiaryState {} // When syncing favorite actions fails

