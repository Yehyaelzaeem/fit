//
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
//
// import '../../../core/models/mymeals_response.dart';
// import '../../../core/services/api_provider.dart';
// import '../../../core/utils/shared_helper.dart';
//
//
// class MyMealsController extends GetxController {
//   final response = MyMealResponse().obs;
//   final error = ''.obs;
//   final loading = false.obs;
//   final viewOnly = false.obs;
//   final requiredAuth = false.obs;
//   final getMyMealsLoading = false.obs;
//   bool isGuest = false;
//   bool isGuestSaved = false;
//   String userId = "";
//   changeValue(value) {
//     value = !value;
//     print(value);
//     update();
//   }
//
//   @override
//   void onInit() async {
//     userId = await SharedHelper().readString(CachingKey.USER_ID);
//     isGuest = await SharedHelper().readBoolean(CachingKey.IS_GUEST);
//     isGuestSaved = await SharedHelper().readBoolean(CachingKey.IS_GUEST_SAVED);
//     if(userId.isNotEmpty){
//       getNetworkData();
//     }else if(isGuestSaved){
//       getNetworkData();
//     }
//     super.onInit();
//   }
//
//   getNetworkData() async {
//
//     error.value = '';
//     getMyMealsLoading.value = true;
//     try {
//       response.value = await ApiProvider().getMyMeals();
//     } catch (e) {
//       error.value = '$e';
//     }
//     getMyMealsLoading.value = false;
//   }
//
//   void deleteMeals() async {
//     response.value.data!.forEach((element) async {
//       if (element.selected) {
//         await networkDeleteMeal(element.id.toString());
//       }
//     });
//     response.refresh();
//   }
//
//   networkDeleteMeal(String id) async {
//     getMyMealsLoading.value = true;
//     try {
//       await ApiProvider().deleteMeal(id: id);
//       response.value.data!
//           .removeWhere((element) => element.id == int.parse(id));
//     } catch (e) {
//       Get.snackbar('Error', '$e');
//     }
//     getMyMealsLoading.value = false;
//     response.refresh();
//   }
//
//   void add({
//     required SingleMyMeal meal,
//   }) {
//     meal.qty = meal.qty! + 1;
//     meal.qty! * (double.tryParse('${meal.price}')?.floor() ?? 0);
//     update();
//   }
//
//   void minus({
//     required SingleMyMeal meal,
//   }) {
//     if (meal.qty == 1) {
//       Fluttertoast.showToast(msg: "Quantity can't be less than 1");
//     } else
//       meal.qty = meal.qty! - 1;
//     meal.qty!  * (double.tryParse('${meal.price}')?.floor() ?? 0);
//     update();
//   }
//
//   int totalPrice({
//     required SingleMyMeal meal,
//   }) {
//     // int sum = int.parse(meal.price!);
//     // if (meal.qty != 1) {
//     //   sum = int.parse(meal.price!) * meal.qty!;
//     // }
//     // return sum;
//      int sum = double.tryParse('${meal.price}')?.floor() ?? 0;
//     if (meal.qty != 1) {
//       sum = (double.tryParse('${meal.price}')?.floor() ?? 0) * meal.qty!;
//     }
//     return sum;
//   }
// }
