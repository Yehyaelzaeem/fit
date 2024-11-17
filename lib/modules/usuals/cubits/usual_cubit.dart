
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../../../core/models/day_details_reposne.dart';

import '../../../core/models/usual_meals_data_reposne.dart';
import '../../../core/models/usual_meals_reposne.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/services/error/failure.dart';
import '../../diary/controllers/diary_controller.dart';
import '../../diary/cubits/diary_cubit.dart';
import '../controllers/usual_controller.dart';
import '../repositories/usual_repository.dart';

part 'usual_states.dart';

class UsualCubit extends Cubit<UsualStates> {
  final UsualRepository _usualRepository;

  UsualCubit(this._usualRepository) : super(UsualInitialState());
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController textEditController = TextEditingController();
  RxList<FoodDataItem> caloriesDetails = RxList();
  RxList<FoodDataItem> carbsDetails = RxList();
  RxList<FoodDataItem> fatsDetails = RxList();
  UsualMealsDataResponse response = UsualMealsDataResponse();
  UsualMealsResponse mealsResponse = UsualMealsResponse();
  FocusNode workoutTitleDescFocus = FocusNode();
  final isLoading = false.obs;
  final deleteLoading = false.obs;
  final addLoading = false.obs;
  final refreshLoadingProtine = false.obs;
  final refreshLoadingCarbs = false.obs;
  final refreshLoadingFats = false.obs;
  final lastSelectedDate = ''.obs;
  final kUpdate = 1.obs;

  void onInit() async {
    await fetchUsualMealsData();
  }

  Future<void> fetchUsualMealsData() async {
    emit(UsualLoading());  // Emits loading state

    final result = await _usualRepository.getUsualMealsData();

    result.fold(
          (failure) => emit(UsualError(failure.message)),  // Emits error state if failed
          (data){
            response = data;
            emit(UsualLoaded());
          },  // Emits loaded state with data if successful
    );
  }

  Future<void> createUsualMeal({
    required Map<String, dynamic> mealParameters,required DiaryCubit diaryCubit
  }) async {
    emit(UsualMealCreating());

    final result = await _usualRepository.createUsualMeal( mealParameters);

    result.fold(
          (failure) => emit(UsualError(failure.message)),  // Handle error
          (success) async {
        // If successful, update UsualMealsData
        await getMyUsualMeals();
        Fluttertoast.showToast(fontSize: 10, msg: "${success.message}");

        // Update DiaryCubit with the new meal data
        _updateDiaryWithMealData(mealParameters,diaryCubit);
      },
    );
  }

  Future<void> sendCachedUsualMeals() async {
    // emit(UsualSyncLoading()); // Emit loading state
    await _usualRepository.sendLocallySavedUsualMeals();


  }

  Future<void> _updateDiaryWithMealData(Map<String, dynamic> mealParameters, DiaryCubit _diaryCubit) async {
    emit(UsualLoading());  // Emits loading state
    // Assuming similar logic to what you have in your provided code for meal data update
    List<int> foodIds = mealParameters["food_id"].toString().split(',').map((value) => int.parse(value.trim())).toList();
    List<double> qtys = mealParameters["qty"].toString().split(',').map((value) => double.parse(value.trim())).toList();
    double totalCalories = 0;

    MealData mealData = MealData(
      id: 0,
      name: mealParameters["name"],
      totalCalories: 0,
      proteins: UsualProteins(items: []),
      carbs: UsualProteins(items: []),
      fats: UsualProteins(items: []),
    );

    // Updating the DiaryCubit data
    _diaryCubit.dayDetailsResponse!.data!.proteins!.food!.forEach((element) {
      if (foodIds.contains(element.id)) {
        mealData.proteins?.items?.add(Items(
          food: FoodDataItem.fromJson(element.toJson()),
          qty: qtys[foodIds.indexOf(element.id!)],
        ));
        totalCalories += (element.caloriePerUnit * qtys[foodIds.indexOf(element.id!)]);
      }
    });

    _diaryCubit.dayDetailsResponse!.data!.carbs!.food!.forEach((element) {
      if (foodIds.contains(element.id)) {
        mealData.carbs?.items?.add(Items(
          food: FoodDataItem.fromJson(element.toJson()),
          qty: qtys[foodIds.indexOf(element.id!)],
        ));
        totalCalories += (element.caloriePerUnit * qtys[foodIds.indexOf(element.id!)]);
      }
    });

    _diaryCubit.dayDetailsResponse!.data!.fats!.food!.forEach((element) {
      if (foodIds.contains(element.id)) {
        mealData.fats?.items?.add(Items(
          food: FoodDataItem.fromJson(element.toJson()),
          qty: qtys[foodIds.indexOf(element.id!)],
        ));
        totalCalories += (element.caloriePerUnit * qtys[foodIds.indexOf(element.id!)]);
      }
    });

    mealData.totalCalories = totalCalories;
    // Optionally save locally or update Cubit state with the new meal data.
    emit(UsualLoaded());


  }



  // Future usualMealsData() async {
  //   isLoading.value = true;
  //
  //   await ApiProvider().getUsualMealsData().then((value) {
  //     if (value.data != null) {
  //       response.value = value;
  //     }
  //   });
  //   isLoading.value = false;
  // }

  List<FoodItem> foodItems = [];
  sendJsonData(FoodDataItem myFood) {
    FoodItem item = FoodItem(
        foodId: myFood.id!,
        quantity: myFood.qty!,
        mealName: myFood.title ?? "");
    foodItems.add(item);
  }
  //
  // Future<void> createUsualMeal(
  //     {required Map<String, dynamic> mealParameters,required DiaryCubit diaryCubit}) async {
  //
  //   final result = await Connectivity().checkConnectivity();
  //   if (result != ConnectivityResult.none) {
  //     addLoading.value = true;
  //     isLoading.value = true;
  //     await ApiProvider()
  //         .createUsualMeal(mealParameters: mealParameters)
  //         .then((value) async {
  //       if (value.success == true) {
  //         addLoading.value = false;
  //         mealsResponse.value = UsualMealsResponse();
  //         await getUserUsualMeals();
  //         Fluttertoast.showToast(fontSize: 10, msg: "${value.message}");
  //       } else {
  //         Fluttertoast.showToast(fontSize: 10, msg: "${value.message}");
  //         addLoading.value = false;
  //       }
  //       isLoading.value = false;
  //     });
  //   }else{
  //     isLoading.value = true;
  //     await ApiProvider()
  //         .createUsualMeal(mealParameters: mealParameters);
  //     MealData mealData = MealData(
  //         id: 0,
  //         name: mealParameters["name"],
  //         totalCalories: mealParameters["calories"],
  //         proteins: UsualProteins(items: []),
  //         carbs: UsualProteins(items: []),
  //         fats: UsualProteins(items: [])
  //     );
  //     List<int> foodIds = mealParameters["food_id"].toString().split(',').map((value) => int.parse(value.trim())).toList();
  //     print(mealParameters["qty"]);
  //     List<double> qtys = mealParameters["qty"].toString().split(',').map((value) => double.parse(value.trim())).toList();
  //     double totalCalories = 0;
  //     diaryCubit.dayDetailsResponse!.data!.proteins!.food!.forEach((element) {
  //       if(foodIds.contains(element.id)){
  //         mealData.proteins?.items?.add(Items(
  //             food: FoodDataItem.fromJson(element.toJson()),
  //             qty: qtys[foodIds.indexOf(element.id!)]
  //         ),);
  //         totalCalories = totalCalories+ (element.caloriePerUnit*qtys[foodIds.indexOf(element.id!)]);
  //       }
  //     });
  //     diaryCubit.dayDetailsResponse!.data!.carbs!.food!.forEach((element) {
  //       if(foodIds.contains(element.id)){
  //         mealData.carbs?.items?.add(Items(
  //             food: FoodDataItem.fromJson(element.toJson()),
  //             qty: qtys[foodIds.indexOf(element.id!)]
  //         ),);
  //         totalCalories = totalCalories+ (element.caloriePerUnit*qtys[foodIds.indexOf(element.id!)]);
  //       }
  //     });
  //     diaryCubit.dayDetailsResponse!.data!.fats!.food!.forEach((element) {
  //       if(foodIds.contains(element.id)){
  //         mealData.fats?.items?.add(Items(
  //             food: FoodDataItem.fromJson(element.toJson()),
  //             qty: qtys[foodIds.indexOf(element.id!)]
  //         ),);
  //         totalCalories = totalCalories+ (element.caloriePerUnit*qtys[foodIds.indexOf(element.id!)]);
  //       }
  //     });
  //     mealData.totalCalories = totalCalories ;
  //     print(totalCalories);
  //     mealsResponse.value.data?.add(mealData);
  //     ApiProvider().saveMyUsualMealsLocally(mealsResponse.value);
  //
  //     kUpdate.value = kUpdate.value + 1;
  //     isLoading.value = false;
  //
  //   }
  // }
  Future<void> updateCurrentUsualMeal(
      {required Map<String, dynamic> mealParameters,required DiaryCubit diaryCubit}) async {
    emit(UsualMealCreating());
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      addLoading.value = true;
      isLoading.value = true;
      await _usualRepository
          .updateUsualMeal(mealParameters: mealParameters)
          .then((value) async {
        if (value.success == true) {
          addLoading.value = false;
          mealsResponse = UsualMealsResponse();
          await getMyUsualMeals();
          Fluttertoast.showToast(fontSize: 10, msg: "${value.message}");
        } else {
          Fluttertoast.showToast(fontSize: 10, msg: "${value.message}");
        }
        isLoading.value = false;
      });
    }else{
      isLoading.value = true;
      await _usualRepository
          .updateUsualMeal(mealParameters: mealParameters);
      MealData mealData = MealData(
          id: mealParameters["id"],
          name: mealParameters["name"],
          totalCalories: mealParameters["calories"],
          proteins: UsualProteins(items: []),
          carbs: UsualProteins(items: []),
          fats: UsualProteins(items: [])
      );
      List<int> foodIds = mealParameters["food_id"].toString().split(',').map((value) => int.parse(value.trim())).toList();
      List<double> qtys = mealParameters["qty"].toString().split(',').map((value) => double.parse(value.trim())).toList();
      double totalCalories = 0;
      diaryCubit.dayDetailsResponse!.data!.proteins!.food!.forEach((element) {
        if(foodIds.contains(element.id)){
          mealData.proteins?.items?.add(Items(
              food: FoodDataItem.fromJson(element.toJson()),
              qty: qtys[foodIds.indexOf(element.id!)]
          ),);
          totalCalories = totalCalories+ (element.caloriePerUnit*qtys[foodIds.indexOf(element.id!)]);
        }
      });
      diaryCubit.dayDetailsResponse!.data!.carbs!.food!.forEach((element) {
        if(foodIds.contains(element.id)){
          mealData.carbs?.items?.add(Items(
              food: FoodDataItem.fromJson(element.toJson()),
              qty: qtys[foodIds.indexOf(element.id!)]
          ),);
          totalCalories = totalCalories+ (element.caloriePerUnit*qtys[foodIds.indexOf(element.id!)]);
        }
      });
      diaryCubit.dayDetailsResponse!.data!.fats!.food!.forEach((element) {
        if(foodIds.contains(element.id)){
          mealData.fats?.items?.add(Items(
              food: FoodDataItem.fromJson(element.toJson()),
              qty: qtys[foodIds.indexOf(element.id!)]
          ),);
          totalCalories = totalCalories+ (element.caloriePerUnit*qtys[foodIds.indexOf(element.id!)]);
        }
      });
      mealData.totalCalories = totalCalories ;
      print(totalCalories);
      mealsResponse.data![mealsResponse.data!.indexWhere((element) => element.id==mealData.id)]=mealData;
      _usualRepository.saveMyUsualMealsLocally(mealsResponse);

      kUpdate.value = kUpdate.value + 1;
      isLoading.value = false;

    }

    emit(UsualLoaded());
  }

  Future addMealToDiary({required int mealId,required MealData? meal, double? fraction,required DiaryCubit diaryCubit}) async {


      meal?.proteins?.items?.forEach((element) async{
        diaryCubit.createOrUpdateFoodData(Food.fromJson(element.food!.toJson()),double.parse(element.qty.toString())*((fraction??1)),type: 'proteins',isUsual:true);
      });
      meal?.carbs?.items?.forEach((element) async{
        diaryCubit.createOrUpdateFoodData(Food.fromJson(element.food!.toJson()),double.parse(element.qty.toString())*((fraction??1)),type: 'carbs',isUsual:true);
      });
      meal?.fats?.items?.forEach((element) async{
        diaryCubit.createOrUpdateFoodData(Food.fromJson(element.food!.toJson()),double.parse(element.qty.toString())*((fraction??1)),type: 'fats',isUsual:true);
      });
      Fluttertoast.showToast(fontSize: 10, msg: "Meal is added to diary successfully");


  }

  Future<void> getMyUsualMeals({bool isLoad = true}) async {
    // emit(MealsLoading());
    if(isLoad) {
      emit(UsualLoading()); // Emits loading state
    }
    final result = await _usualRepository.getMyUsualMeals();
    result.fold(
          (failure) {
        emit(MealsError(failure.message));
        Fluttertoast.showToast(msg: "Failed to fetch meals data");
      },
          (usualMealsResponse) {
            mealsResponse = usualMealsResponse;
        emit(MealsLoaded(usualMealsResponse));
            emit(UsualLoaded());
            // Fluttertoast.showToast(msg: "Meals data loaded successfully");
      },
    );
  }

  Future<void> deleteUserUsualMeal(int mealId) async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      // emit(UsualLoading());  // Emits loading state
      mealsResponse.data?.removeWhere((element) => element.id==mealId);
      Fluttertoast.showToast(fontSize: 8, msg: "Meal Deleted Successfully");
      emit(UsualLoaded());

      try {
        final response = await _usualRepository.deleteUsualMeal(mealId: mealId);
        if (response.success == true) {
          mealsResponse = UsualMealsResponse();
          await getMyUsualMeals(isLoad: false);

          // update();
          // mealsResponse.refresh();
          deleteLoading.value = false;
          // Fluttertoast.showToast(fontSize: 8, msg: "${response.message}");
        } else {
          Fluttertoast.showToast(fontSize: 8, msg: "${response.message}");
        }
      } catch (error) {
        Fluttertoast.showToast(
            fontSize: 8, msg: "An error occurred while deleting the meal.");
      }
    }else{
      await _usualRepository.deleteUsualMealLocally(mealId);
      mealsResponse.data?.removeWhere((element) => element.id==mealId);
      // update();
      // mealsResponse.refresh();
    }
  }

  // Future<void> deleteItemCalories(int id, String _date, String type) async {
  //   await ApiProvider()
  //       .deleteCalorie("delete_calories_details", id)
  //       .then((value) {
  //     if (value.success == true) {
  //       caloriesDetails.removeWhere((element) => element.id == id);
  //     } else {
  //       caloriesDetails.removeWhere((element) => element.id == id);
  //     }
  //   });
  // }
  //
  // Future<void> deleteItemCarbs(int id, String _date, String type) async {
  //   await ApiProvider()
  //       .deleteCalorie("delete_calories_details", id)
  //       .then((value) {
  //     if (value.success == true) {
  //       carbsDetails.removeWhere((element) => element.id == id);
  //     } else {
  //       carbsDetails.removeWhere((element) => element.id == id);
  //     }
  //   });
  // }
  //
  // Future<void> deleteItemFats(int id, String _date, String type) async {
  //   await ApiProvider()
  //       .deleteCalorie("delete_calories_details", id)
  //       .then((value) {
  //     if (value.success == true) {
  //       fatsDetails.removeWhere((element) => element.id == id);
  //     } else {
  //       fatsDetails.removeWhere((element) => element.id == id);
  //       Fluttertoast.showToast(fontSize: 8, msg: "${value.message}");
  //     }
  //   });
  // }

}

class FoodItem {
  int foodId;
  String mealName;
  dynamic quantity;

  FoodItem(
      {required this.foodId, required this.quantity, required this.mealName});

  Map<String, dynamic> toJson() {
    return {
      'food_id[]': foodId,
      'qty[]': quantity,
    };
  }
}
