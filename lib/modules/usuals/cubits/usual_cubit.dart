
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
  final response = UsualMealsDataResponse().obs;
  final mealsResponse = UsualMealsResponse().obs;
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
          (data) => emit(UsualLoaded(data)),  // Emits loaded state with data if successful
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
        await getUserUsualMeals();
        Fluttertoast.showToast(fontSize: 10, msg: "${success.message}");

        // Update DiaryCubit with the new meal data
        _updateDiaryWithMealData(mealParameters,diaryCubit);
      },
    );
  }

  Future<void> _updateDiaryWithMealData(Map<String, dynamic> mealParameters, DiaryCubit _diaryCubit) async {
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
    print(totalCalories);
    // Optionally save locally or update Cubit state with the new meal data.
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

    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      addLoading.value = true;
      isLoading.value = true;
      await ApiProvider()
          .updateUsualMeal(mealParameters: mealParameters)
          .then((value) async {
        if (value.success == true) {
          addLoading.value = false;
          mealsResponse.value = UsualMealsResponse();
          await getUserUsualMeals();
          Fluttertoast.showToast(fontSize: 10, msg: "${value.message}");
        } else {
          Fluttertoast.showToast(fontSize: 10, msg: "${value.message}");
        }
        isLoading.value = false;
      });
    }else{
      isLoading.value = true;
      await ApiProvider()
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
      print(mealParameters["qty"]);
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
      mealsResponse.value.data![mealsResponse.value.data!.indexWhere((element) => element.id==mealData.id)]=mealData;
      ApiProvider().saveMyUsualMealsLocally(mealsResponse.value);

      kUpdate.value = kUpdate.value + 1;
      isLoading.value = false;

    }
  }

  Future addMealToDiary({required int mealId,required MealData? meal,required DiaryCubit diaryCubit}) async {
    final result = await Connectivity().checkConnectivity();

    if (false) {
      await ApiProvider().mealToDiary(mealId: mealId).then((value) async {
        if (value.success == true) {
          // Get.find<DiaryController>(tag: 'diary').getDiaryData(lastSelectedDate.value,false);
          Fluttertoast.showToast(fontSize: 10, msg: "${value.message}");
        } else {
          Fluttertoast.showToast(fontSize: 10, msg: "${value.message}");
        }
      });
    }else{
      meal?.proteins?.items?.forEach((element) async{
        diaryCubit.createProtineData(Food.fromJson(element.food!.toJson()),double.parse(element.qty.toString()),type: 'proteins');
      });
      meal?.carbs?.items?.forEach((element) async{
        diaryCubit.createProtineData(Food.fromJson(element.food!.toJson()),double.parse(element.qty.toString()),type: 'carbs');
      });
      meal?.fats?.items?.forEach((element) async{
        diaryCubit.createProtineData(Food.fromJson(element.food!.toJson()),double.parse(element.qty.toString()),type: 'fats');
      });
      Fluttertoast.showToast(fontSize: 10, msg: "Meal is added to diary successfully");

    }

  }

  Future getUserUsualMeals() async {
    isLoading.value = true;
    addLoading.value = true;

    await ApiProvider().getMyUsualMeals().then((value) {
      if (value.success == true) {
        print("Here success");
        print(mealsResponse.value.data);
        mealsResponse.value = value;
        print("Here success ${mealsResponse.value.data?.length}");
        isLoading.value = false;
        addLoading.value = false;
      } else {
        Fluttertoast.showToast(fontSize: 8, msg: "${value.message}");
      }
    });
    kUpdate.value = kUpdate.value + 1;
  }

  Future<void> deleteUserUsualMeal(int mealId) async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      deleteLoading.value = true;
      try {
        final response = await ApiProvider().deleteUsualMeal(mealId: mealId);
        if (response.success == true) {
          mealsResponse.value = UsualMealsResponse();
          await getUserUsualMeals();
          // update();
          mealsResponse.refresh();
          deleteLoading.value = false;
          Fluttertoast.showToast(fontSize: 8, msg: "${response.message}");
        } else {
          Fluttertoast.showToast(fontSize: 8, msg: "${response.message}");
        }
      } catch (error) {
        print("Error: $error");
        Fluttertoast.showToast(
            fontSize: 8, msg: "An error occurred while deleting the meal.");
      }
    }else{
      await ApiProvider().deleteUsualMealLocally(mealId);
      mealsResponse.value.data?.removeWhere((element) => element.id==mealId);
      // update();
      mealsResponse.refresh();
    }
  }

  Future<void> deleteItemCalories(int id, String _date, String type) async {
    await ApiProvider()
        .deleteCalorie("delete_calories_details", id)
        .then((value) {
      if (value.success == true) {
        caloriesDetails.removeWhere((element) => element.id == id);
      } else {
        caloriesDetails.removeWhere((element) => element.id == id);
      }
    });
  }

  Future<void> deleteItemCarbs(int id, String _date, String type) async {
    await ApiProvider()
        .deleteCalorie("delete_calories_details", id)
        .then((value) {
      if (value.success == true) {
        carbsDetails.removeWhere((element) => element.id == id);
      } else {
        carbsDetails.removeWhere((element) => element.id == id);
      }
    });
  }

  Future<void> deleteItemFats(int id, String _date, String type) async {
    await ApiProvider()
        .deleteCalorie("delete_calories_details", id)
        .then((value) {
      if (value.success == true) {
        fatsDetails.removeWhere((element) => element.id == id);
      } else {
        fatsDetails.removeWhere((element) => element.id == id);
        Fluttertoast.showToast(fontSize: 8, msg: "${value.message}");
      }
    });
  }

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
