
import 'package:app/config/navigation/navigation.dart';
import 'package:app/core/resources/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../config/navigation/routes.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../diary/cubits/diary_cubit.dart';
import '../../home/view/widgets/home_appbar.dart';
import '../cubits/usual_cubit.dart';
import '../widget/meal_item_widget.dart';

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
    await usualCubit.fetchUsualMealsData();
  }

  @override
  Widget build(BuildContext context) {
    initData();
    return SafeArea(
      child: Obx(() {
        if (usualCubit.deleteLoading.value)
          return Container(child: CircularLoadingWidget(), color: Colors.white);

        if (usualCubit.isLoading.value)
          return Container(child: CircularLoadingWidget(), color: Colors.white);
        if (usualCubit.addLoading.value)
          return Container(child: CircularLoadingWidget(), color: Colors.white);
        return Scaffold(
          body: Column(
            children: [
              HomeAppbar(
                type: null,
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(55.0),
                            ),
                            color: const Color(0xFF414042),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              '        My Meals      ',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          child: GestureDetector(
                            onTap: () {
                              NavigationService.push(context,Routes.makeMeals);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(200),
                                border:
                                    Border.all(color: kColorPrimary, width: 1),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(width: 10),
                                  Icon(Icons.add, color: kColorPrimary),
                                  kTextbody(
                                    'Make a meal',
                                    paddingH: 6,
                                    paddingV: 8,
                                    color: kColorPrimary,
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      return Expanded(
                          child: usualCubit.mealsResponse.value.data==null||usualCubit.mealsResponse.value.data!.isEmpty
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
                                                "${usualCubit.mealsResponse.value.data?[index].name}",
                                            mealCalories: usualCubit
                                                .mealsResponse
                                                .value
                                                .data?[index]
                                                .totalCalories
                                                .toStringAsFixed(2),
                                            meal: usualCubit.mealsResponse.value
                                                .data?[index],
                                            mealId: usualCubit.mealsResponse
                                                .value.data?[index].id,
                                          ),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                            height: 12,
                                          ),
                                      itemCount: usualCubit
                                          .mealsResponse.value.data!.length),
                                ));
                    })
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        );
      }),
    );
  }
}
