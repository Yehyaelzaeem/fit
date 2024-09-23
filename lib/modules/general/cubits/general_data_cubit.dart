import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/meal_features_status_response.dart';
import '../../../core/models/meal_food_list_response.dart';
import '../../../core/services/error/failure.dart';
import '../repositories/general_data_repository.dart';

part 'general_data_states.dart';

class GeneralDataCubit extends Cubit<GeneralDataStates> {
  final GeneralDataRepository _generalDataRepository;

  GeneralDataCubit(this._generalDataRepository) : super(GeneralDataInitialState(null));

  MealFoodListResponse response = MealFoodListResponse(data: []);
  MealFeatureHomeResponse mealFeatureHomeResponse = MealFeatureHomeResponse();
  bool delivery_option = false;
  bool pickup_option = false;
  bool shoNewMessage = true;
  bool canDismissNewMessageDialog = false;
  bool removeNotificationsCount = false;
  bool iosInReview = false;
  String avatar = '';
  String? lastSelectedDate;
}
