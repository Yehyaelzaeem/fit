
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../repositories/other_calories_repository.dart';
part 'other_calories_states.dart';

class OtherCaloriesCubit  extends Cubit<OtherCaloriesStates> {

  final OtherCaloriesRepository _otherCaloriesRepository;

  OtherCaloriesCubit(this._otherCaloriesRepository,) : super(DiaryInitial());

  Future<void> addOtherCalories({
    required String? title,
    required String? calPerUnit,
    required int? unit,
    String? unitQuantity,
    String? unitName,
    int? type,
  }) async {
    emit(OtherCaloriesLoading());

    final result = await _otherCaloriesRepository.addOtherCalories(
      title: title,
      calPerUnit: calPerUnit,
      unit: unit,
      unitQuantity: unitQuantity,
      unitName: unitName,
      type: type,
    );

    result.fold(
          (failure) {
        // Handle failure case, emit failure state
        emit(OtherCaloriesError("Failed to add other calories."));
      },
          (response) {
        // Handle success case, emit success state
            Fluttertoast.showToast(msg: "Other calories added successfully.");

            emit(DiarySuccess("Other calories added successfully."));
      },
    );
  }

  Future<void> updateOtherCalories({
    required String? title,
    required String? calPerUnit,
    required int? unit,
    String? unitQuantity,
    String? unitName,
    int? type,
    required int? id,
  }) async {
    emit(OtherCaloriesLoading());

    final result = await _otherCaloriesRepository.updateOtherCalories(
      title: title,
      calPerUnit: calPerUnit,
      unit: unit,
      unitQuantity: unitQuantity,
      unitName: unitName,
      type: type,
      id: id,
    );

    result.fold(
          (failure) {
        // Handle failure case, emit failure state
        emit(OtherCaloriesError("Failed to update other calories."));
      },
          (response) {
        // Handle success case, emit success state
        emit(DiarySuccess("Other calories updated successfully."));
      },
    );
  }
}