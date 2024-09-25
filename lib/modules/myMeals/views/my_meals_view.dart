
import 'package:app/config/navigation/navigation.dart';
import 'package:app/core/resources/app_assets.dart';
import 'package:app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../core/database/shared_pref.dart';
import '../../../core/models/mymeals_response.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/utils/alerts.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/default/app_buttons.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../../core/view/widgets/error_handler_widget.dart';
import '../../../core/view/widgets/page_lable.dart';
import '../../makeMeals/views/make_meals_view.dart';
import '../../subscribe/views/non_user_subscribe_view.dart';
import '../cubits/my_meals_cubit.dart';

Future<bool> _willPopCallback() async {
  NavigationService.goBack(NavigationService.navigationKey.currentState!.context);
  NavigationService.goBack(NavigationService.navigationKey.currentState!.context);
  return true;
}

class MyMealsView extends StatefulWidget {
  const MyMealsView({Key? key}) : super(key: key);

  @override
  _MyMealsViewState createState() => _MyMealsViewState();
}

class _MyMealsViewState extends State<MyMealsView> {
  late final MyMealsCubit myMealsCubit;


  @override
  void initState() {
    super.initState();
    myMealsCubit = BlocProvider.of<MyMealsCubit>(context);
    myMealsCubit.fetchMyMeals();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorPrimary,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: _willPopCallback,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: BlocConsumer<MyMealsCubit, MyMealsStates>(
                listener: (context, state) {

                },
                builder: (context, state) {

              if (state is MyMealsLoading) return Center(child: CircularLoadingWidget());
              // if (myMealsCubit.requiredAuth.value) return IncompleteData();
              if (state is MyMealsError)
                return Container(
                    margin: EdgeInsets.only(top: deviceHeight / 3),
                    child: Center(
                        child: errorHandler(
                      myMealsCubit.error.value,
                      myMealsCubit,
                    )));
              return SingleChildScrollView(
                child: Column(
                  children: [
                    //App bar
                    appBar(),
                    SizedBox(height: 20),
                    header(context),
                    SizedBox(height: 4),
                    if (myMealsCubit.getMyMealsLoading.value) Container(height: 100, child: CircularLoadingWidget()),
                    if (!myMealsCubit.getMyMealsLoading.value && myMealsCubit.response.data != null && myMealsCubit.response.data!.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 45),
                        child: Column(
                          children: [
                            Image.asset(
                              AppImages.kEmptyPackage,
                              scale: 5,
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            kTextbody("  No meals added  ", size: 16),
                          ],
                        ),
                      ),
                    if (!myMealsCubit.getMyMealsLoading.value && myMealsCubit.response.data != null)
                      ...myMealsCubit.response.data!.reversed.map((e) {
                        return singleItem(meal: e, context: context,myMealsCubit: myMealsCubit);
                      }).toList(),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: kButtonDefault(
                            "Order Now",
                            color: myMealsCubit.response.data != null && myMealsCubit.response.data!.isEmpty ? Colors.grey : kColorPrimary,
                            func: () {
                              List<SingleMyMeal> meals = myMealsCubit.response.data == null ? [] : myMealsCubit.response.data!.where((element) => element.selected).toList();
                              if (meals.isEmpty) {
                                Alerts.showSnackBar(context,
                                  'Please select at least one meal',
                                  // backgroundColor: Colors.red,
                                  // colorText: Colors.white,
                                );
                                return;
                              }

                              YemenyPrefs yemenyPrefs = YemenyPrefs();

                              NavigationService.pushReplacement(context,Routes.shippingDetailsView,
                                  arguments: {
                                "meals": meals,
                                "name": yemenyPrefs.getShippingName() ?? '',
                                "last_name": yemenyPrefs.getShippingLastName() ?? '',
                                "email": yemenyPrefs.getShippingEmail() ?? '',
                                "phone": yemenyPrefs.getShippingPhone() ?? '',
                                "detailedAddress": yemenyPrefs.getShippingAddress() ?? '',
                                "latitude": yemenyPrefs.getShippingLat() ?? '',
                                "longitude": yemenyPrefs.getShippingLng() ?? '',
                                "address": yemenyPrefs.getShippingCoordinatesAddress() ?? '',
                              });
                            },
                          ),
                        ),
                        Expanded(
                            child: kButtonDefault(
                          "Delete",
                          color: Color(0xffF1F1F1),
                          textColor: Colors.red,
                          func: () {
                            if (myMealsCubit.response.data != null && myMealsCubit.response.data!.isNotEmpty) myMealsCubit.deleteMeals();
                          },
                          border: Border.all(color: Colors.red, width: 1),
                        )),
                      ],
                    ),
                    if (!myMealsCubit.isGuestSaved && myMealsCubit.userId.isEmpty)
                      SizedBox(
                        height: 250,
                      ),
                    if (!myMealsCubit.isGuestSaved && myMealsCubit.userId.isEmpty)
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                          ),
                          Expanded(
                            child: kButtonDefault(
                              "  Get old meals  ",
                              bold: false,
                              color: Colors.white,
                              textColor: AppColors.ACCENT_COLOR,
                              func: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => NonUserSubscribeView(isGuest: true, toCheer: true)),
                                );
                              },
                              border: Border.all(color: AppColors.ACCENT_COLOR, width: 1),
                            ),
                          ),
                          SizedBox(
                            width: 80,
                          ),
                        ],
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget appBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: deviceWidth,
      height: 65,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          blurRadius: 2,
          spreadRadius: 2,
          offset: Offset(0, 0),
        ),
      ]),
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              AppImages.kLogoChellFullRow,
              height: 44,
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: GestureDetector(
              onTap: () {
                NavigationService.goBack(context);
                NavigationService.goBack(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget header(context) {
    return Row(
      children: [
        PageLable(name: "My meals"),
        Expanded(child: SizedBox(width: 10)),
        GestureDetector(
          onTap: () async {
            // bool status = await Get.isRegistered<MakeMealsController>();
            // //remove controller
            // if (status) {
            //   Get.delete<MakeMealsController>();
            //   await Future.delayed(Duration(milliseconds: 100));
            // }
            dynamic val = await NavigationService.push(context,Routes.makeMeals);
            if (val != null) myMealsCubit.fetchMyMeals();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              border: Border.all(color: kColorPrimary, width: 1),
              color: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(width: 10),
                Icon(Icons.add, color: kColorPrimary),
                kTextbody(
                  'Create new meal',
                  paddingH: 6,
                  paddingV: 8,
                  color: kColorPrimary,
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }

  Widget body(List<Widget> widgets, {Color color = Colors.white}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      color: color,
      child: Column(
        children: [...widgets],
      ),
    );
  }

  Widget singleItem({required SingleMyMeal meal, required MyMealsCubit myMealsCubit, required BuildContext context}) {
    return BlocConsumer<MyMealsCubit, MyMealsStates>(
      listener: (context, state) {
        if (state is GetMyMealsFailureState) {
          Alerts.showToast(state.failure.message);
        }

      },
      builder: (context, state) => state is GetMyMealsLoadingState
          ?  Container()
          : Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(0xffF1F1F1),
        ),
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                    value: meal.selected,
                    onChanged: (sts) {
                      // myMealsCubit.response.update((val) {
                      //   val!.data!.forEach((e) {
                      //     if (e.id == meal.id) e.selected = sts!;
                      //   });
                      // });
                      myMealsCubit.changeValue(meal.selected);
                    }),
                SizedBox(width: 8),
                Expanded(child: kTextbody("${meal.name}", color: kColorPrimary, align: TextAlign.start, bold: true)),
                kTextbody("${myMealsCubit.totalPrice(meal: meal)} L.E", color: Colors.black),
                SizedBox(width: 12),
                GestureDetector(
                  onTap: () async {
                    dynamic val = await Get.toNamed(Routes.makeMeals, arguments: meal);
                    if (val != null) myMealsCubit.fetchMyMeals();
                  },
                  child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Icon(
                        Icons.edit,
                        size: 18,
                      )),
                ),
                SizedBox(width: 8),
              ],
            ),
            meal.selected == true
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      width: 90,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      /**************************** number & add & minus *****************************/
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /**************************** minus *****************************/
                          GestureDetector(
                            onTap: () {
                              myMealsCubit.minus(
                                meal: meal,
                              );
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.remove,
                                size: 18,
                              ),
                            ),
                          ),
                          /**************************** number *****************************/
                          kTextHeader(meal.qty.toString()),
                          /**************************** add *****************************/
                          GestureDetector(
                            onTap: () {
                              myMealsCubit.add(meal: meal);
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
