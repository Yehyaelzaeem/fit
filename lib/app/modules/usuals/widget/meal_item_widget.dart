import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:pull_down_button/pull_down_button.dart';
import '../../../models/usual_meals_reposne.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../widgets/app_dialog.dart';
import '../../../widgets/default/text.dart';
import '../controllers/usual_controller.dart';
import 'calories_type_item_widget.dart';

class MealItemWidget extends StatefulWidget {
  const MealItemWidget(
      {Key? key, required this.mealName, this.proteins,this.mealId, required this.mealCalories, this.carbs, this.fats})
      : super(key: key);
  final String mealName;
  final String mealCalories;
  final UsualProteins ?proteins;
  final UsualProteins ?carbs;
  final UsualProteins ?fats;
  final int ?mealId;

  @override
  State<MealItemWidget> createState() => _MealItemWidgetState();
}

class _MealItemWidgetState extends State<MealItemWidget> {
  UsualController controller = UsualController();

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
                color: kColorAccent,
                align: TextAlign.start,
              ),
            ],
          )),
          PullDownButton(
            itemBuilder: (context) => [
              PullDownMenuItem(
                icon: Icons.fastfood,
                iconColor: Colors.brown,
                title: '    Add to diary',
                onTap: () async {
                await  controller.addMealToDiary(mealId: widget.mealId!);
                },
              ),
              PullDownMenuItem(
                icon: Icons.remove_red_eye,
                iconColor: kColorPrimary,
                title: '    View',
                onTap: () {
                  appDialog(
                      title: "${widget.mealName} \n (${widget.mealCalories} Cal.)",
                      child: Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          if(widget.proteins!=null)             CaloriesTypeItemWidget(
                              caloriesTypeName: 'Proteins', usualProteins: widget.proteins!, mealCalories: widget.mealCalories,),
          if(widget.carbs!=null)    CaloriesTypeItemWidget(
                              caloriesTypeName: 'Carbs', usualProteins: widget.carbs!, mealCalories: widget.mealCalories,),
                          if(widget.fats!=null)               CaloriesTypeItemWidget(
                              caloriesTypeName: 'Fats', usualProteins: widget.fats!, mealCalories: widget.mealCalories,),
                          SizedBox(
                            height: 18,
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: kColorPrimary,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  '    Close    ',
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
                title: '    Edit',
                onTap: () {
                  Get.toNamed(Routes.MALEAMEAL);
                },
              ),
              PullDownMenuItem(
                iconColor: Colors.red,
                icon: Icons.delete,
                title: '    Delete',
                isDestructive: true,
                onTap: () async {
                  appDialog(
                    title: "Do you want to delete ${widget.mealName}?",
                    image: Icon(Icons.delete, size: 24, color: Colors.red),
                    cancelAction: () {
                      Get.back();
                    },
                    cancelText: "No",
                    confirmAction: () async {
                      Get.back();
                      controller.deleteUsualMeal(widget.mealId!);
                      await   controller.getMyUsualMeals();
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
