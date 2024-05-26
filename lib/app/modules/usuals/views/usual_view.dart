import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/helper/assets_path.dart';
import '../../home/home_appbar.dart';
import '../controllers/usual_controller.dart';
import '../widget/meal_item_widget.dart';

class UsualView extends GetView<UsualController> {
  final controller = Get.find<UsualController>(tag: 'usual');
  initData() async {
    await controller.usualMealsData();
  }

  @override
  Widget build(BuildContext context) {
    initData();
    return SafeArea(
      child: Obx(() {
        if (controller.deleteLoading.value)
          return Container(child: CircularLoadingWidget(), color: Colors.white);

        if (controller.isLoading.value)
          return Container(child: CircularLoadingWidget(), color: Colors.white);
        if (controller.addLoading.value)
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
                    Obx(() {
                      return Expanded(
                          child: controller.mealsResponse.value.data==null||controller.mealsResponse.value.data!.isEmpty
                              ? Center(
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
                                )
                              : RefreshIndicator(
                                  onRefresh: () async {
                                    await controller.usualMealsData();
                                  },
                                  child: ListView.separated(
                                      itemBuilder: (context, index) =>
                                          MealItemWidget(
                                            mealName:
                                                "${controller.mealsResponse.value.data?[index].name}",
                                            mealCalories: controller
                                                .mealsResponse
                                                .value
                                                .data?[index]
                                                .totalCalories
                                                .toStringAsFixed(2),
                                            meal: controller.mealsResponse.value
                                                .data?[index],
                                            mealId: controller.mealsResponse
                                                .value.data?[index].id,
                                          ),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                            height: 12,
                                          ),
                                      itemCount: controller
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
