import 'package:app/app/data/database/shared_pref.dart';
import 'package:app/app/models/mymeals_response.dart';
import 'package:app/app/modules/myMeals/controllers/my_meals_controller.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/error_handler_widget.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyMealsView extends GetView<MyMealsController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorPrimary,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Obx(() {
            if (controller.loading.value) return Center(child: CircularLoadingWidget());
            // if (controller.requiredAuth.value) return IncompleteData();
            if (controller.error.value.isNotEmpty)
              return Container(
                  margin: EdgeInsets.only(top: Get.height / 3),
                  child: Center(
                      child: errorHandler(
                    controller.error.value,
                    controller,
                  )));
            return SingleChildScrollView(
              child: Column(
                children: [
                  //App bar
                  appBar(),
                  SizedBox(height: 20),
                  header(),
                  SizedBox(height: 4),
                  if (controller.getMyMealsLoading.value) Container(height: 100, child: CircularLoadingWidget()),
                  if (!controller.getMyMealsLoading.value && controller.response.value.data != null && controller.response.value.data!.isEmpty)
                    Text(
                      'No meals added',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  if (!controller.getMyMealsLoading.value && controller.response.value.data != null)
                    ...controller.response.value.data!.reversed.map((e) {
                      return singleItem(meal: e);
                    }).toList(),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: kButtonDefault(
                          "Order Now",
                          color: controller.response.value.data != null && controller.response.value.data!.isEmpty ? Colors.grey : kColorPrimary,
                          func: () {
                            List<SingleMyMeal> meals = controller.response.value.data == null ? [] : controller.response.value.data!.where((element) => element.selected).toList();
                            if (meals.isEmpty) {
                              Get.snackbar(
                                'Error',
                                'Please select at least one meal',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }

                            YemenyPrefs yemenyPrefs = YemenyPrefs();

                            Get.toNamed(Routes.SHIPPING_DETAILS, arguments: meals, parameters: {
                              "name": yemenyPrefs.getShippingName() ?? '',
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
                          if (controller.response.value.data != null && controller.response.value.data!.isNotEmpty) controller.deleteMeals();
                        },
                        border: Border.all(color: Colors.red, width: 1),
                      )),
                    ],
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget appBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: MediaQuery.of(Get.context!).size.width,
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
              kLogoChellFullRow,
              height: 44,
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: GestureDetector(
              onTap: () {
                Get.back();
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

  Widget header() {
    return Row(
      children: [
        PageLable(name: "My meals"),
        Expanded(child: SizedBox(width: 10)),
        GestureDetector(
          onTap: () async {
            dynamic val = await Get.toNamed(Routes.MAKE_MEALS);
            if (val != null) controller.getNetworkData();
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

  Widget singleItem({required SingleMyMeal meal}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xffF1F1F1),
      ),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
              value: meal.selected,
              onChanged: (sts) {
                controller.response.update((val) {
                  val!.data!.forEach((e) {
                    if (e.id == meal.id) e.selected = sts!;
                  });
                });
              }),
          SizedBox(width: 8),
          Expanded(child: kTextbody("${meal.name}", color: kColorPrimary, align: TextAlign.start, bold: true)),
          kTextbody("${meal.price} L.E", color: Colors.black),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () async {
              dynamic val = await Get.toNamed(Routes.MAKE_MEALS, arguments: meal);
              if (val != null) controller.getNetworkData();
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
    );
  }
}
