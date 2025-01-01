
import 'package:app/config/navigation/navigation.dart';
import 'package:app/core/resources/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../config/navigation/routes.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/resources/resources.dart';
import '../../../core/utils/alerts.dart';
import '../../../core/view/widgets/custom_text.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../diary/cubits/diary_cubit.dart';
import '../../home/view/widgets/home_appbar.dart';
import '../cubits/usual_cubit.dart';
import '../widget/meal_item_widget.dart';
import '../widget/section_meals.dart';
import 'make_a_meal_view.dart';

class UsualView extends StatefulWidget {
  const UsualView({
    Key? key,
  }) : super(key: key);


  @override
  State<UsualView> createState() => _UsualViewState();
}

class _UsualViewState extends State<UsualView> {

  late final UsualCubit usualCubit;
  late final DiaryCubit diaryCubit;


  @override
  void initState() {
    super.initState();
    usualCubit = BlocProvider.of<UsualCubit>(context);
    diaryCubit = BlocProvider.of<DiaryCubit>(context);
    initData();
  }


  initData() async {
    await usualCubit.getMyUsualMeals();
    await usualCubit.fetchUsualMealsData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<UsualCubit, UsualStates>(
          listener: (context, state) {
            if (state is UsualError) {
              Alerts.showSnackBar(context, state.message,duration: Time.t2s);
            }

            if (state is UsualLoaded) {
              Alerts.closeAllSnackBars(context);

            }
          },
          builder: (context, state){
            // if (state is UsualLoading || usualCubit.deleteLoading.value)
            //   return Container(child: CircularLoadingWidget(), color: Colors.white);
            // MealsLoading;
            if (usualCubit.isLoading.value)
              return Container(child: CircularLoadingWidget(), color: Colors.white);
            if (usualCubit.addLoading.value)
              return Container(child: CircularLoadingWidget(), color: Colors.white);
            return Scaffold(
              backgroundColor: AppColors.offWhite,
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: AppSize.s32),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: (){
                              NavigationService.goBack(context);
                            },
                            child: Icon(Icons.arrow_back,color: AppColors.black,)),
                        SizedBox(width: AppSize.s24,),
                        CustomText(
                          "My Meals",
                          fontSize: FontSize.s20,
                          fontWeight: FontWeightManager.medium,
                        ),
                        Spacer(),
                        InkWell(
                            onTap: (){
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,  // This will allow the bottom sheet to take full screen height if needed
                                backgroundColor: AppColors.white.withOpacity(0.001),
                               
                                builder: (context) {
                                  return FractionallySizedBox(
                                    heightFactor: 0.8,  // Adjust the height factor to control how much space the bottom sheet takes
                                    child: MakeAMealView(
                                      refresh: (){
                                        setState(() {

                                        });
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            child: Icon(Icons.add_circle,color: AppColors.primary,size: AppSize.s32,)),
                      ],
                    ),
                  ),

                  Expanded(
                      child: usualCubit.mealsResponse.data==null||usualCubit.mealsResponse.data!.isEmpty
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.kEmptyPackage,
                              scale: 5,
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            kTextbody("  No Meals!  ", size: 16),
                          ],
                        ),
                      )
                          : RefreshIndicator(
                        onRefresh: () async {
                          await usualCubit.fetchUsualMealsData();
                        },
                        child: ListView.separated(
                            itemBuilder: (context, index) =>
                                MealItemWidget(
                                  mealName:
                                  "${usualCubit.mealsResponse.data?[index].name}",
                                  mealCalories: usualCubit
                                      .mealsResponse
                                      .data?[index]
                                      .totalCalories
                                      .toStringAsFixed(2),
                                  meal: usualCubit.mealsResponse
                                      .data?[index],
                                  mealId: usualCubit.mealsResponse
                                      .data?[index].id,
                                ),
                            separatorBuilder: (context, index) =>
                                SizedBox(
                                  height: 12,
                                ),
                            itemCount: usualCubit
                                .mealsResponse.data!.length),
                      )),
                  SizedBox(
                    height: 24,
                  ),
                ],
              ),
            );
          }

      ),


    );
  }
}
