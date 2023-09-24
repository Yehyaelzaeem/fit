import 'dart:io';

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
import 'package:get/get.dart';

import '../../../models/usual_meals_data_reposne.dart';
import '../../home/home_appbar.dart';
import '../../main_un_auth.dart';
import '../controllers/usual_controller.dart';
import '../save_new_meal.dart';

class MakeAMealView extends GetView<UsualController> {
  @override
  final controller = Get.find(tag: 'usual');

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      if (controller.showLoader.value || controller.isLoading.value)
        return Container(child: CircularLoadingWidget(), color: Colors.white);
      return Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                HomeAppbar(
                  type: null,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                       padding: EdgeInsets.symmetric(vertical:16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(15.0),
                          ),
                          color: const Color(0xFF414042),
                        ),
                        child:  Padding(
                          padding: EdgeInsets.symmetric(vertical:8),
                          child: Text(
                            '        Make a meal      ',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 18),
                      child: EditText(
                        hint: 'Meal name',
                        hintColor: Color(0xff8D8D8D),
                        background: Color(0xffF1F1F1),
                        controller: controller.mealNameController,
                        updateFunc: (value) {
                          controller.mealName.value = value;
                        },
                        contentPaddingV: 0,
                        padding: 0,
                        noBorder: false,
                        radius: 4,
                      ),
                    ),
                    SizedBox(height: 12),
                    Divider(thickness: 2),
                   // rowWithProgressBar("Proteins", ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                      /*    if (controller.refreshLoadingProtine.value)
                            Container(
                              child: LinearProgressIndicator(
                                color: kColorPrimary,
                              ),
                            ),*/
                          staticBar('proteins'),
                          if (controller.caloriesDetails.isEmpty)
                            SizedBox(height: 20),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: controller.caloriesDetails.length,
                              itemBuilder: (context, indedx) {
                                return rowItem(
                                    controller.caloriesDetails[indedx], 'proteins');
                              }),
                        ],
                      ),
                    ),
                    Divider(thickness: 2),
                //    rowWithProgressBar("Carbs", controller.response.value.data?.carbs),
                  /*  if (controller.refreshLoadingCarbs.value)
                      Container(
                        child: LinearProgressIndicator(color: kColorPrimary),
                      ),*/
                    staticBar('carbs'),
                    if (controller.carbsDetails.isEmpty) SizedBox(height: 20),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.carbsDetails.length,
                        itemBuilder: (context, indedx) {
                          return rowItem(controller.carbsDetails[indedx], 'carbs');
                        }),
                    Divider(thickness: 2),
                 //   rowWithProgressBar("Fats", controller.response.value.data?.fats),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                        /*  if (controller.refreshLoadingFats.value)
                            Container(
                              child: LinearProgressIndicator(
                                color: kColorPrimary,
                              ),
                            ),*/
                          staticBar('fats'),
                          if (controller.fatsDetails.isEmpty) SizedBox(height: 20),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: controller.fatsDetails.length,
                              itemBuilder: (context, indedx) {
                                return rowItem(
                                    controller.fatsDetails[indedx], 'fats');
                              }),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Color(0xffF1F9E3),
              ),
              child: kButtonDefault(
                'Save Meal',
                marginH: MediaQuery.of(Get.context!).size.width / 6,
                paddingV: 0,
                shadow: true,
                paddingH: 12,
              ),
            ),
          ),
        ],
      );
    }));
  }
String getTotal(String total){
    return total;
}

  Widget rowItem(FoodCaloriesDetails item, String type) {
    return Container(
      height: 40,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 1, height: 38, color: Color(0xffE1E1E3)),
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: GestureDetector(
                          onTap: () {
                            showQualityDialog(
                              type == 'proteins'
                                  ? controller
                                      .response.value.data!.proteins!
                                  : type == 'carbs'
                                      ? controller
                                          .response.value.data!.carbs!
                                      : controller
                                          .response.value.data!.fats!,
                              item,
                              type == 'proteins'
                                  ? 'proteins'
                                  : type == 'carbs'
                                      ? 'carbs'
                                      : 'fats',
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 2, vertical: 2),
                            height: 34,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              key: Key('foodName_${item.id}_${item.qty}'),
                              decoration: InputDecoration(
                                hintText: '',
                                hintStyle: TextStyle(fontSize: 12),
                                labelStyle: TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                      color: kColorPrimary, width: 1),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.5),
                                ),
                                contentPadding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 2),
                              ),
                              style: TextStyle(
                                  fontSize: 12.0,
                                  height: 1.4,
                                  color: Colors.black),
                              enableInteractiveSelection: false,
                              initialValue: item.qty == null
                                  ? ''
                                  : item.qty.toString().replaceAll('.0', ''),
                              keyboardType: Platform.isIOS
                                  ? TextInputType.numberWithOptions(
                                      signed: true, decimal: true)
                                  : TextInputType.numberWithOptions(
                                      decimal: true, signed: false),
                              // keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (text) {
                                if (text.isEmpty) return;
                                try {
                                  double qty = double.parse(text);
                                  int foodId = 0;
                                  if (type == 'proteins') {
                                    foodId = controller
                                        .response.value.data!.proteins!
                                        .firstWhere((element) =>
                                            element.title == item.quality)
                                        .id!;
                                  } else if (type == 'carbs') {
                                    foodId = controller
                                        .response.value.data!.carbs!
                                        .firstWhere((element) =>
                                            element.title == item.quality)
                                        .id!;
                                  } else {
                                    foodId = controller
                                        .response.value.data!.fats!
                                        .firstWhere((element) =>
                                            element.title == item.quality)
                                        .id!;
                                  }
/*
                                  controller.updateProtineData(
                                    item.id,
                                    foodId,
                                    qty,
                                    type: type == 'proteins'
                                        ? 'proteins'
                                        : type == 'carbs'
                                            ? 'carbs'
                                            : 'fats',
                                  );*/
                                } catch (e) {}
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 1),
                            child: kTextbody(
                              item.unit == null ? '' : '${item.unit}',
                              color: Colors.black,
                              bold: false,
                              size: 12,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(width: 1, height: 38, color: Color(0xffE1E1E3)),
              Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: double.infinity,
                  height: 34,
                  child: GestureDetector(
                    onTap: () {
                      showQualityDialog(
                        type == 'proteins'
                            ? controller.response.value.data!.proteins!
                            : type == 'carbs'
                                ? controller.response.value.data!.carbs!
                                : controller.response.value.data!.fats!,
                        item,
                        type == 'proteins'
                            ? 'proteins'
                            : type == 'carbs'
                                ? 'carbs'
                                : 'fats',
                      );
                    },
                    child: itemWidget(
                      title: item.quality == null ? '' : '${item.quality}',
                      showDropDownArrow:
                          item.quality == null || '${item.quality}'.isEmpty,
                      color: item.color,
                    ),
                  ),
                ),
              ),
              Container(width: 1, height: 38, color: Color(0xffE1E1E3)),
              Expanded(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: kTextbody(
                    item.calories == null ? '' : '${(item.calories*item.qty).toStringAsFixed(1)}',
                    color: Colors.black,
                    bold: false,
                  ),
                ),
              ),
              Container(width: 1, height: 38, color: Color(0xffE1E1E3)),
              Expanded(
                flex: 1,
                child: DeleteItemWidget(
                  controller: controller,
                  item: item,
                  type: type == 'proteins'
                      ? 'proteins'
                      : type == 'carbs'
                          ? 'carbs'
                          : 'fats',
                ),
              ),
              Container(width: 1, height: 38, color: Color(0xffE1E1E3)),
            ],
          ),
          Divider(
            height: 1,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget rowWithProgressBar(String Title, String totalCalories) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    '${Title}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              kTextHeader(
                  totalCalories,
                  bold: false,
                  size: 20,
                  color: Colors.black),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget staticBar(String type) {
    return Container(
      height: 40,
      color: Color(0xFF414042),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(width: 1, height: 50, color: Color(0xffE1E1E3)),
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              child: Center(
                child: kTextbody('Quantity',
                    color: Colors.white, bold: true, size: 16),
              ),
            ),
          ),
          Container(width: 1, height: 50, color: Color(0xffE1E1E3)),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              child: Center(
                child: kTextbody('Quality',
                    color: Colors.white, bold: true, size: 16),
              ),
            ),
          ),
          Container(width: 1, height: 50, color: Color(0xffE1E1E3)),
          Expanded(
            flex: 2,
            child: kTextbody('Cal.', color: Colors.white, bold: true, size: 16),
          ),
          Container(width: 1, height: 50, color: Color(0xffE1E1E3)),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () async {
                FocusScope.of(Get.context!).requestFocus(FocusNode());
                if (type == 'proteins') {
                  controller.caloriesDetails.add(FoodCaloriesDetails());
                } else if (type == 'carbs') {
                  controller.carbsDetails.add(FoodCaloriesDetails());
                } else {
                  controller.fatsDetails.add(FoodCaloriesDetails());
                }
              },
              child: Center(
                child: Container(
                    width: 26,
                    height: 26,
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(color: kColorPrimary),
                    child: Icon(
                      Icons.add,
                      color: Colors.black87,
                      size: 18,
                    )),
              ),
            ),
          ),
          Container(width: 1, height: 50, color: Color(0xffE1E1E3)),
        ],
      ),
    );
  }




  Widget itemWidget(
      {required String title, bool showDropDownArrow = false, String? color}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey, width: 1),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
              child: Container(
            key: Key('title$title'),
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: AutoSizeText(
              '$title',
              style: TextStyle(
                  fontSize: 12,
                  color: color != null
                      ? Color(int.parse("0xFF$color"))
                      : Colors.black87,
                  height: 1.2),
              textAlign: TextAlign.center,
              minFontSize: 8,
              maxLines: 2,
            ),
          )),
          if (showDropDownArrow)
            Icon(
              Icons.keyboard_arrow_down,
              size: 18,
            ),
        ],
      ),
    );
  }
  dynamic result;
  void showQualityDialog(
      List<Food> food, FoodCaloriesDetails item, String type) async {
    // show screen dialog
     result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return Dialog(
            child: SaveNewMeal(
              date: controller.apiDate.value,
              list: food,
            ),
          );
        });
    if (result != null) {
      Food food = result as Food;
      item.quality = food.title;
      item.qty = food.qty;
      item.color = food.color;
      item.calories = food.caloriePerUnit;

      controller.caloriesDetails.refresh();
      controller.carbsDetails.refresh();
      controller.fatsDetails.refresh();
      if (item.id == null) {
      //  controller.createProtineData(food.id, food.qty!, type: type);
      } else {
      //  controller.updateProtineData(item.id, food.id, food.qty!, type: type);
      }
    }
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }
}

class DeleteItemWidget extends StatefulWidget {
  final FoodCaloriesDetails item;
  final UsualController controller;
  final String type;

  DeleteItemWidget({
    Key? key,
    required this.item,
    required this.controller,
    required this.type,
  }) : super(key: key);

  @override
  State<DeleteItemWidget> createState() => _DeleteItemWidgetState();
}

class _DeleteItemWidgetState extends State<DeleteItemWidget> {
  bool deleteItem = false;

  @override
  Widget build(BuildContext context) {
    if (deleteItem)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 1.4,
            ),
          ),
        ],
      );
    return InkWell(
      onTap: () async {
        deleteItem = true;
        setState(() {});
        if (widget.item.id == null) {
          if (widget.type == 'proteins')
            await widget.controller.caloriesDetails.remove(widget.item);
          else if (widget.type == 'carbs')
            await widget.controller.carbsDetails.remove(widget.item);
          else
            await widget.controller.fatsDetails.remove(widget.item);
        } else {
          if (widget.type == 'proteins')
            await widget.controller.deleteItemCalories(widget.item.id!,
                widget.controller.lastSelectedDate.value, widget.type);
          else if (widget.type == 'carbs')
            await widget.controller.deleteItemCarbs(widget.item.id!,
                widget.controller.lastSelectedDate.value, widget.type);
          else
            await widget.controller.deleteItemCarbs(widget.item.id!,
                widget.controller.lastSelectedDate.value, widget.type);

          await widget.controller.carbsDetails.remove(widget.item);
          await widget.controller.fatsDetails.remove(widget.item);
        }

        deleteItem = false;
        setState(() {});
        FocusScope.of(Get.context!).requestFocus(FocusNode());
      },
      child: Icon(
        Icons.delete,
        color: Colors.redAccent,
        size: 26,
      ),
    );
  }
}
