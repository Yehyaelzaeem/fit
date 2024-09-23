//
// import '../../../core/models/meal_food_list_response.dart';
// import '../../../core/models/mymeals_response.dart';
// import '../../../core/services/api_provider.dart';
// import '../../../core/utils/globals.dart';
// import '../../../core/utils/shared_helper.dart';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class MakeMealsController extends GetxController {
//   TextEditingController mealNameController = TextEditingController();
//   TextEditingController noteController = TextEditingController();
//   final mealName = "".obs;
//   final note = "".obs;
//   final error = ''.obs;
//   final loading = false.obs;
//   final saveLoading = false.obs;
//   bool isGuest = false;
//   bool isGuestSaved = false;
//   String userId = "";
//   RxList<Food> selectedFood = RxList<Food>();
//
//   // RxList<Food> carbSelected = RxList<Food>();
//   // RxList<Food> fatSelected = RxList<Food>();
//
//   RxList<SingleMeal> meals = RxList<SingleMeal>();
//
//   // RxList<Food> carb = RxList<Food>();
//   // RxList<Food> fat = RxList<Food>();
//
//   SingleMyMeal? meal;
//
//   @override
//   void onInit() async{
//     userId = await SharedHelper().readString(CachingKey.USER_ID);
//     isGuest = await SharedHelper().readBoolean(CachingKey.IS_GUEST);
//     isGuestSaved = await SharedHelper().readBoolean(CachingKey.IS_GUEST_SAVED);
//     getNetworkData();
//
//
//     super.onInit();
//   }
//   clearData(){
//     mealNameController.clear();
//     noteController.clear();
//     selectedFood.clear();
//    // meals.clear();
//   }
//
//   getNetworkData() async {
//     error.value = '';
//     loading.value = true;
//     try {
//       if (response.data.isEmpty) {
//         MealFoodListResponse mealFoodListResponse =
//             await ApiProvider().getMealFoodList();
//         List<SingleMeal> data = [];
//         mealFoodListResponse.data.forEach((element) {
//           List<Food> food = [];
//           element.food.forEach((fo) {
//             food.add(Food(
//               id: fo.id,
//               title: fo.title,
//               mealTitle: element.title ?? "",
//               amounts: fo.amounts,
//               selectedAmount: fo.selectedAmount,
//             ));
//           });
//           data.add(SingleMeal(
//             food: food,
//             id: element.id,
//             title: element.title,
//           ));
//         });
//         MealFoodListResponse res = MealFoodListResponse(
//           data: data,
//           code: mealFoodListResponse.code,
//           success: mealFoodListResponse.success,
//         );
//         response = res;
//       }
//       meals.value = response.data;
//
//       // if (globalController.response.value.data!.where((element) => element.title! == "Protien").isNotEmpty) protein.value = globalController.response.value.data!.firstWhere((element) => element.title! == "Protien").food;
//
//       // if (globalController.response.value.data!.where((element) => element.title! == "Carb").isNotEmpty) carb.value = globalController.response.value.data!.firstWhere((element) => element.title! == "Carb").food;
//
//       // if (globalController.response.value.data!.where((element) => element.title! == "Fats").isNotEmpty) fat.value = globalController.response.value.data!.firstWhere((element) => element.title! == "Fats").food;
//
//       if (Get.arguments != null) meal = Get.arguments;
//       if (meal != null) {
//         mealName.value = meal!.name;
//         note.value = meal!.note ?? '';
//         mealNameController.text = meal!.name;
//         noteController.text = note.value;
//         meal!.items.forEach((element) {
//           meals.forEach((meal) {
//             if (element.title == meal.title) {
//               element.items.forEach((element) {
//                 Food? food;
//                 Amount? amount;
//                 meal.food.forEach((item) {
//                   Echo(
//                       'arguments item ${item.title} ${item.id} element ${element.title} ${element.id}');
//                   if (item.id == element.id) {
//                     item.amounts.forEach((amountItem) {
//                       if (element.amount == amountItem.name)
//                         amount = amountItem;
//                     });
//                     if (amount != null) Echo('amount ${amount!.name}');
//                     if (amount != null)
//                       Echo('item.mealTitle ${item.mealTitle}');
//                     if (amount != null)
//                       food = Food(
//                         mealTitle: item.mealTitle,
//                         id: item.id,
//                         title: item.title,
//                         selectedAmount: amount!,
//                         amounts: item.amounts,
//                       );
//                   }
//                 });
//                 if (food != null) selectedFood.add(food!);
//               });
//             }
//           });
//
//           // if (element.title == "Protien") {
//           //   element.items.forEach((element) {
//           //     Food? food;
//           //     Amount? amount;
//           //     protein.forEach((item) {
//           //       if (item.id == element.id) {
//           //         item.amounts.forEach((amountItem) {
//           //           if (element.amount == amountItem.name) amount = amountItem;
//           //         });
//           //         if (amount != null)
//           //           food = Food(
//           //             id: item.id,
//           //             title: item.title,
//           //             selectedAmount: amount!,
//           //             amounts: item.amounts,
//           //           );
//           //       }
//           //     });
//           //     if (food != null) proteinSelected.add(food!);
//           //   });
//           // }
//
//           // if (element.title == "Carb" || element.title == "carb") {
//           //   element.items.forEach((element) {
//           //     Food? food;
//           //     Amount? amount;
//           //     carb.forEach((item) {
//           //       if (item.id == element.id) {
//           //         item.amounts.forEach((amountItem) {
//           //           if (element.amount == amountItem.name) amount = amountItem;
//           //         });
//           //         if (amount != null)
//           //           food = Food(
//           //             id: item.id,
//           //             title: item.title,
//           //             selectedAmount: amount!,
//           //             amounts: item.amounts,
//           //           );
//           //       }
//           //     });
//           //     if (food != null) carbSelected.add(food!);
//           //   });
//           // }
//           // if (element.title == "Fat" || element.title == "fat") {
//           //   element.items.forEach((element) {
//           //     Food? food;
//           //     Amount? amount;
//           //     fat.forEach((item) {
//           //       if (item.id == element.id) {
//           //         item.amounts.forEach((amountItem) {
//           //           if (element.amount == amountItem.name) amount = amountItem;
//           //         });
//           //         if (amount != null)
//           //           food = Food(
//           //             id: item.id,
//           //             title: item.title,
//           //             selectedAmount: amount!,
//           //             amounts: item.amounts,
//           //           );
//           //       }
//           //     });
//           //     if (food != null) fatSelected.add(food!);
//           //   });
//           // }
//         });
//       }
//     } catch (e) {
//       error.value = '$e';
//       loading.value = false;
//     }
//     loading.value = false;
//   }
//
//   double totalPrice() {
//     double total = 0;
//     selectedFood.forEach((element) {
//       if (element.selectedAmount.price.isNotEmpty)
//         total += double.parse(element.selectedAmount.price).round();
//     });
//
//     // proteinSelected.forEach((element) {
//     //   if (element.selectedAmount.price.isNotEmpty) total += double.parse(element.selectedAmount.price);
//     // });
//     // carbSelected.forEach((element) {
//     //   if (element.selectedAmount.price.isNotEmpty) total += double.parse(element.selectedAmount.price);
//     // });
//     // fatSelected.forEach((element) {
//     //   if (element.selectedAmount.price.isNotEmpty) total += double.parse(element.selectedAmount.price);
//     // });
//     return total;
//   }
//
//   Future saveMeal() async {
//     saveLoading.value = true;
//     String foodIds = "";
//     String amountIds = "";
//     selectedFood.forEach((element) {
//       foodIds += element.id.toString() + ",";
//       amountIds += element.selectedAmount.id.toString() + ",";
//     });
//     // proteinSelected.forEach((element) {
//     //   foodIds += element.id.toString() + ",";
//     //   amountIds += element.selectedAmount.id.toString() + ",";
//     // });
//     // carbSelected.forEach((element) {
//     //   foodIds += element.id.toString() + ",";
//     //   amountIds += element.selectedAmount.id.toString() + ",";
//     // });
//     // fatSelected.forEach((element) {
//     //   foodIds += element.id.toString() + ",";
//     //   amountIds += element.selectedAmount.id.toString() + ",";
//     // });
//     foodIds.substring(0, foodIds.length - 1);
//     amountIds.substring(0, amountIds.length - 1);
//
//     try {
//       print("Meal => $meal");
//       if (meal != null) {
//         await ApiProvider().updateNewMeal(
//           id: meal!.id.toString(),
//           name: mealName.value,
//           amountsId: amountIds,
//           foodIds: foodIds,
//           note: note.value,
//         );
//       } else {
//         await ApiProvider().createNewMeal(
//           name: mealName.value,
//           amountsId: amountIds,
//           foodIds: foodIds,
//           note: note.value,
//         );
//       }
// //// TODO handle it
//       if (isGuestSaved) {
//         Get.back(result: true);
//       } else if (userId.isNotEmpty) {
//         Get.back(result: true);
//       } else if (!isGuestSaved&&userId.isEmpty) {
//         Get.back(result: true);
//         Get.back(result: true);
//       }
//     } catch (e) {
//       Get.snackbar("Error", "$e");
//       saveLoading.value = false;
//     }
//     saveLoading.value = false;
//   }
// }
