
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../../../core/models/cheer_full_response.dart';
import '../../../core/models/cheerful_response.dart';
import '../../../core/models/meal_features_status_response.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/utils/globals.dart';
import '../../../core/utils/shared_helper.dart';
import '../repositories/cheerfull_repository.dart';

part 'cheerfull_states.dart';

class CheerFullCubit extends Cubit<CheerFullStates> {
  final CheerFullRepository _cheerFullRepository;

  CheerFullCubit(this._cheerFullRepository) : super(CheerFullInitialState());
  MealFeatureHomeResponse response = MealFeatureHomeResponse();
  CheerfulSocialsResponse cheerfulSocialsResponse = CheerfulSocialsResponse();
  CheerFullResponse cheerFullResponse = CheerFullResponse();
  // Fetch meal features home
  Future<void> fetchMealFeaturesHome() async {
    try {
      emit(MealLoading());

      final mealFeatures = await _cheerFullRepository.getMealFeaturesHome();
      response = mealFeatures;
      emit(MealFeaturesLoaded(mealFeatures: mealFeatures));
    } catch (e) {
      emit(MealError(message: "Failed to load meal features"));
    }
  }

  // Fetch cheerful status
  Future<void> fetchCheerFullStatus() async {
    try {
      emit(MealLoading());

      final cheerFullStatus = await _cheerFullRepository.getCheerFullStatus();
      cheerFullResponse = cheerFullStatus;
      emit(CheerFullStatusLoaded(cheerFullStatus: cheerFullStatus));
    } catch (e) {
      emit(MealError(message: "Failed to load cheer full status"));
    }
  }
}
