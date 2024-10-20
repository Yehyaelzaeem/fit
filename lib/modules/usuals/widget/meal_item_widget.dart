import 'package:app/config/navigation/navigation.dart';
import 'package:app/core/view/views.dart';
import 'package:app/modules/diary/cubits/diary_cubit.dart';
import 'package:app/modules/usuals/cubits/usual_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../core/models/usual_meals_reposne.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/resources/resources.dart';
import '../../../core/view/widgets/app_dialog.dart';
import '../../../core/view/widgets/default/text.dart';
import '../controllers/usual_controller.dart';
import '../views/make_a_meal_view.dart';
import 'calories_type_item_widget.dart';

class MealItemWidget extends StatefulWidget {
  const MealItemWidget({
    Key? key,
    required this.mealName,
    this.meal,
    this.mealId,
    required this.mealCalories,
  }) : super(key: key);
  final String mealName;
  final String mealCalories;
  final MealData? meal;
  final int? mealId;

  @override
  State<MealItemWidget> createState() => _MealItemWidgetState();
}

class _MealItemWidgetState extends State<MealItemWidget> {
  // final controller = Get.find<UsualController>(tag: 'usual');

  late final UsualCubit usualCubit;
  late final DiaryCubit diaryCubit;


  @override
  void initState() {
    super.initState();
    usualCubit = BlocProvider.of<UsualCubit>(context);
    diaryCubit = BlocProvider.of<DiaryCubit>(context);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 2,
                spreadRadius: 2,
                offset: Offset(0, 0),
              ),
            ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSize.s12),

          child: ExpansionTile(
            backgroundColor: AppColors.white,
            collapsedBackgroundColor: AppColors.white,
            initiallyExpanded: false,
            title: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        widget.mealName,
                      fontWeight: FontWeightManager.semiBold,
                      fontSize: FontSize.s18,
                    ),
                    CustomText(
                      "${widget.mealCalories} Cal.",
                      fontSize: FontSize.s14,
                      fontWeight: FontWeightManager.medium,
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: ()async{
                          await usualCubit.addMealToDiary(mealId: widget.mealId!,meal: widget.meal,diaryCubit:diaryCubit);

                        },
                        child: Container(
                          padding: EdgeInsets.all(AppSize.s8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                            ),
                            child: SvgPicture.asset(AppIcons.storeSvg,height: FontSize.s18,width: FontSize.s18,)),
                      ),
                      HorizontalSpace(AppSize.s12),
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
                                  mealData: widget.meal,
                                  mealId: widget.mealId,
                                  mealName: widget.mealName,
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(AppSize.s8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    offset: Offset(0, 0),
                                  ),
                                ]
                            ),
                            child: SvgPicture.asset(AppIcons.pen,height: FontSize.s18,width: FontSize.s18,)),
                      ),
                      HorizontalSpace(AppSize.s12),
                      InkWell(
                          onTap: () async {
                            appDialog(
                              title: "Do you want to delete ${widget.mealName}?",
                              image: Icon(Icons.delete, size: 24, color: Colors.red),
                              context: context,
                              cancelAction: () {
                                NavigationService.goBack(context);
                              },
                              cancelText: "No",
                              confirmAction: () async {
                                NavigationService.goBack(context);
                                usualCubit
                                    .deleteUserUsualMeal(widget.mealId!);
                              },
                              confirmText: "Yes",
                            );
                          },

                        child: Container(
                          padding: EdgeInsets.all(AppSize.s8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    offset: Offset(0, 0),
                                  ),
                                ]
                            ),
                            child: SvgPicture.asset(AppIcons.trashSvg,height: FontSize.s18,width: FontSize.s18,)),
                      ),
                    ],
                  ),
                )
              ],
            ),

            children: [
              SizedBox(
                height: 8,
              ),
              if (widget.meal?.proteins != null)

                CaloriesTypeItemWidget(
                  icon: AppIcons.proteins,
                  caloriesTypeName: 'Proteins',
                  usualProteins: widget.meal!.proteins!,
                  mealCalories: widget.mealCalories,
                ),
              if (widget.meal?.carbs != null)
                CaloriesTypeItemWidget(
                  icon: AppIcons.carbs,
                  caloriesTypeName: 'Carbs',
                  usualProteins: widget.meal!.carbs!,
                  mealCalories: widget.mealCalories,
                ),
              if (widget.meal?.fats != null)
                CaloriesTypeItemWidget(
                  icon: AppIcons.fats,
                  caloriesTypeName: 'Fats',
                  usualProteins: widget.meal!.fats!,
                  mealCalories: widget.mealCalories,
                ),
              SizedBox(height: 18),

            ],

          )),
      ));



  }
}
