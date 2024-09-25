import 'package:app/config/navigation/navigation.dart';
import 'package:app/modules/diary/cubits/diary_cubit.dart';
import 'package:app/modules/usuals/cubits/usual_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../core/models/usual_meals_reposne.dart';
import '../../../core/resources/app_colors.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          SizedBox(
            width: 8,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              kTextbody(widget.mealName,
                  size: 18,
                  color: kColorPrimary,
                  align: TextAlign.start,
                  bold: true),
              SizedBox(
                height: 4,
              ),
              kTextbody(
                "(${widget.mealCalories} Cal.)",
                size: 14,
                color: AppColors.ACCENT_COLOR,
                align: TextAlign.start,
              ),
            ],
          )),
          PullDownButton(
            itemBuilder: (context) => [
              PullDownMenuItem(
                icon: Icons.fastfood,
                iconColor: Colors.brown,
                title: 'Add to diary',
                onTap: () async {
                  await usualCubit.addMealToDiary(mealId: widget.mealId!,meal: widget.meal,diaryCubit:diaryCubit);


                  Get.back();
                },
              ),
              PullDownMenuItem(
                icon: Icons.remove_red_eye,
                iconColor: kColorPrimary,
                title: 'View',
                onTap: () {
                  appDialog(
                    isList: true,
                      context: context,
                      title:
                          "${widget.mealName} \n (${widget.mealCalories} Cal.)",
                      child: Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          if (widget.meal?.proteins != null)
                            CaloriesTypeItemWidget(
                              caloriesTypeName: 'Proteins',
                              usualProteins: widget.meal!.proteins!,
                              mealCalories: widget.mealCalories,
                            ),
                          if (widget.meal?.carbs != null)
                            CaloriesTypeItemWidget(
                              caloriesTypeName: 'Carbs',
                              usualProteins: widget.meal!.carbs!,
                              mealCalories: widget.mealCalories,
                            ),
                          if (widget.meal?.fats != null)
                            CaloriesTypeItemWidget(
                              caloriesTypeName: 'Fats',
                              usualProteins: widget.meal!.fats!,
                              mealCalories: widget.mealCalories,
                            ),
                          SizedBox(height: 18),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: kColorPrimary,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  '     Close     ',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ));
                },
              ),
              PullDownMenuItem(
                icon: Icons.edit,
                iconColor: Colors.blue,
                title: 'Edit',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MakeAMealView(
                                mealData: widget.meal,
                                mealId: widget.mealId,
                                mealName: widget.mealName,
                              )));
                },
              ),
              PullDownMenuItem(
                iconColor: Colors.red,
                icon: Icons.delete,
                title: 'Delete',
                isDestructive: true,
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
              ),
            ],
            buttonBuilder: (context, showMenu) => CupertinoButton(
              pressedOpacity: 0.2,
              onPressed: showMenu,
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.ellipsis_circle,
                size: 30,
                color: const Color(0xFF414042),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          )
        ],
      ),
    );
  }
}
