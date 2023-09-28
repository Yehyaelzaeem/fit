import 'dart:io';

import 'package:app/app/models/day_details_reposne.dart';
import 'package:app/app/modules/diary/add_new_food.dart';
import 'package:app/app/modules/diary/controllers/diary_controller.dart';
import 'package:app/app/modules/home/home_drawer.dart';
import 'package:app/app/modules/my_other_calories/my_other_calories.dart';
import 'package:app/app/modules/notification_api.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/custom_bottom_sheet.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/helper/assets_path.dart';
import '../../home/home_appbar.dart';
import '../../main_un_auth.dart';
import '../controllers/usual_controller.dart';
import '../save_new_meal.dart';
import '../widget/meal_item_widget.dart';

class UsualView extends GetView<UsualController> {
  @override

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Obx(() {
        if ( controller.isLoading.value||controller.deleteLoading.value)
          return Container(child: CircularLoadingWidget(), color: Colors.white);
        return Column(
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
                            right: Radius.circular(15.0),
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
                        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 8),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.MALEAMEAL);
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
                  Expanded(
                      child:controller.mealsResponse.value.data!.isEmpty? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              kEmptyPackage,
                              scale: 5,
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            kTextbody("  No Meals!  ", size: 16),
                          ],
                        ),
                      ):

                      RefreshIndicator(
                        onRefresh: ()async{
                       await   controller.getMyUsualMeals();
                      },
                        child: ListView.separated(
                            itemBuilder: (context, index) => MealItemWidget(
                              mealName: "${controller.mealsResponse.value.data?[index].name}", mealCalories: "${controller.mealsResponse.value.data?[index].totalCalories}",
                              proteins: controller.mealsResponse.value.data?[index].proteins,
                              carbs:controller.mealsResponse.value.data?[index].carbs,
                              fats: controller.mealsResponse.value.data?[index].fats,
                              mealId: controller.mealsResponse.value.data?[index].id,
                            ),
                            separatorBuilder: (context, index) => SizedBox(
                              height: 12,
                            ),
                            itemCount: controller.mealsResponse.value.data!.length),
                      ))
                ],
              ),
            ),
            SizedBox(height: 24,),
          ],
        );
      })),
    );
  }
}
