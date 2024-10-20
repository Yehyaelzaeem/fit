
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/models/meal_food_list_response.dart';
import '../../../core/models/mymeals_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../core/services/api_provider.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/utils/globals.dart';
import '../../../core/utils/shared_helper.dart';
import '../repositories/my_meals_repository.dart';

part 'my_meals_states.dart';

class MyMealsCubit extends Cubit<MyMealsStates> {
  final MyMealsRepository _myMealsRepository;

  MyMealsCubit(this._myMealsRepository) : super(MyMealsInitialState());
  MyMealResponse response = MyMealResponse();
  final error = ''.obs;
  final loading = false.obs;
  final viewOnly = false.obs;
  final requiredAuth = false.obs;
  final getMyMealsLoading = false.obs;
  bool isGuest = false;
  bool isGuestSaved = false;
  String userId = "";
  changeValue(value) {
    value = !value;
    emit(state);
  }

  void onInit() async {
    userId = await SharedHelper().readString(CachingKey.USER_ID);
    isGuest = await SharedHelper().readBoolean(CachingKey.IS_GUEST);
    isGuestSaved = await SharedHelper().readBoolean(CachingKey.IS_GUEST_SAVED);
    if(userId.isNotEmpty){
      // getNetworkData();
    }else if(isGuestSaved){
      // getNetworkData();
    }
  }



  void deleteMeals() async {
    response.data!.forEach((element) async {
      if (element.selected) {
        await networkDeleteMeal(element.id.toString());
      }
    });
emit(state);
  }

  networkDeleteMeal(String id) async {
    getMyMealsLoading.value = true;
    try {
      await ApiProvider().deleteMeal(id: id);
      response.data!
          .removeWhere((element) => element.id == int.parse(id));
    } catch (e) {
      Get.snackbar('Error', '$e');
    }
    getMyMealsLoading.value = false;
    emit(state);
  }

  void add({
    required SingleMyMeal meal,
  }) {
    meal.qty = meal.qty! + 1;
    meal.qty! * (double.tryParse('${meal.price}')?.floor() ?? 0);
    emit(state);
  }

  void minus({
    required SingleMyMeal meal,
  }) {
    if (meal.qty == 1) {
      Fluttertoast.showToast(msg: "Quantity can't be less than 1");
    } else
      meal.qty = meal.qty! - 1;
    meal.qty!  * (double.tryParse('${meal.price}')?.floor() ?? 0);
    emit(state);
  }

  int totalPrice({
    required SingleMyMeal meal,
  }) {
    // int sum = int.parse(meal.price!);
    // if (meal.qty != 1) {
    //   sum = int.parse(meal.price!) * meal.qty!;
    // }
    // return sum;
    int sum = double.tryParse('${meal.price}')?.floor() ?? 0;
    if (meal.qty != 1) {
      sum = (double.tryParse('${meal.price}')?.floor() ?? 0) * meal.qty!;
    }
    return sum;
  }


  // Fetch My Meals
  Future<void> fetchMyMeals() async {
    try {
      emit(MyMealsLoading());
      final myMeals = await _myMealsRepository.getMyMeals();
      response = myMeals;
      emit(MyMealsLoaded(myMeals));
    } catch (error) {
      emit(MyMealsError(error.toString()));
    }
  }

  // Fetch Meal Details
  Future<void> fetchMealDetails(String id) async {
    try {
      emit(MealDetailsLoading());
      final mealDetails = await _myMealsRepository.getMealDetails(id);
      emit(MealDetailsLoaded());
    } catch (error) {
      emit(MealDetailsError(error.toString()));
    }
  }
}
