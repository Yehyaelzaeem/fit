import 'package:app/app/models/meal_features_status_response.dart';
import 'package:app/app/models/meal_food_list_response.dart';
import 'package:get/get.dart';

class GlobalController extends GetxController {
  final response = MealFoodListResponse(data: []).obs;
  final mealFeatureHomeResponse = MealFeatureHomeResponse().obs;
  final delivery_option = false.obs;
  final pickup_option = false.obs;
  final shoNewMessage = true.obs;
  final canDismissNewMessageDialog = false.obs;
}
