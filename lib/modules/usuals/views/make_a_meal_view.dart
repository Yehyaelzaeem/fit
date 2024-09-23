import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../core/models/usual_meals_data_reposne.dart';
import '../../../core/models/usual_meals_reposne.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/view/widgets/default/app_buttons.dart';
import '../../../core/view/widgets/default/edit_text.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../diary/cubits/diary_cubit.dart';
import '../../home/view/widgets/home_appbar.dart';
import '../controllers/usual_controller.dart';
import '../cubits/usual_cubit.dart';
import '../save_new_meal.dart';

class MakeAMealView extends StatefulWidget {
  MakeAMealView({this.mealData, this.mealName, this.mealId});

  late MealData? mealData;
  final String? mealName;
  final int? mealId;

  @override
  State<MakeAMealView> createState() => _MakeAMealViewState();
}

class _MakeAMealViewState extends State<MakeAMealView> {
  TextEditingController _mealName = TextEditingController();

  late final UsualCubit usualCubit;
  late final DiaryCubit diaryCubit;


  @override
  void initState() {
    super.initState();
    usualCubit = BlocProvider.of<UsualCubit>(context);
    diaryCubit = BlocProvider.of<DiaryCubit>(context);
    _mealName.clear();
    print('usual');
    usualCubit.caloriesDetails.clear();
    usualCubit.carbsDetails.clear();
    usualCubit.fatsDetails.clear();
    usualCubit.foodItems = [];
    if (widget.mealData != null) {
      _mealName.text = widget.mealName ?? "";
      if (widget.mealData?.proteins?.items?.length != 0) {
        widget.mealData?.proteins?.items?.forEach((element) {
          print(element.food!.id);
          usualCubit.caloriesDetails.add(FoodDataItem(
              id: element.food?.id,
              title: element.food?.title,
              qty: element.qty,
              unit: element.food?.unit,
              color: element.food?.color,
              caloriePerUnit: element.food?.caloriePerUnit,
              total: element.food==null?0:element.qty! * element.food?.caloriePerUnit
          ));
          usualCubit.sendJsonData(
              FoodDataItem(id: element.food!.id, qty: element.qty));
        });
      }
      if (widget.mealData?.carbs?.items?.length != 0) {
        widget.mealData?.carbs?.items?.forEach((element) {
          usualCubit.carbsDetails.add(FoodDataItem(
              id: element.food!.id,
              title: element.food!.title,
              qty: element.qty,
              unit: element.food!.unit,
              color: element.food!.color,
              caloriePerUnit: element.food!.caloriePerUnit,
              total: element.qty! * element.food!.caloriePerUnit));
          usualCubit.sendJsonData(
              FoodDataItem(id: element.food!.id, qty: element.qty));
        });
      }
      if (widget.mealData?.fats?.items?.length != 0) {
        widget.mealData?.fats?.items?.forEach((element) {
          usualCubit.fatsDetails.add(FoodDataItem(
              id: element.food!.id,
              title: element.food!.title,
              qty: element.qty,
              unit: element.food!.unit,
              color: element.food!.color,
              caloriePerUnit: element.food!.caloriePerUnit,
              total: element.qty! * element.food!.caloriePerUnit));
          usualCubit.sendJsonData(
              FoodDataItem(id: element.food!.id, qty: element.qty));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
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
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(15.0),
                          ),
                          color: const Color(0xFF414042),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
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
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: EditText(
                        hint: 'Meal name',
                        hintColor: Color(0xff8D8D8D),
                        background: Color(0xffF1F1F1),
                        controller: _mealName,
                        contentPaddingV: 0,
                        padding: 0,
                        noBorder: false,
                        radius: 4,
                      ),
                    ),
                    SizedBox(height: 4),
                    // rowWithProgressBar("Proteins", ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              'Proteins',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          staticBar('proteins'),
                          if (usualCubit.caloriesDetails.isEmpty)
                            SizedBox(height: 20),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: usualCubit.caloriesDetails.length,
                              itemBuilder: (context, indedx) {
                                return rowItem(
                                    usualCubit.caloriesDetails[indedx],
                                    'proteins');
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Column(
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              'Carbs',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          staticBar('carbs'),
                          if (usualCubit.carbsDetails.isEmpty)
                            SizedBox(height: 20),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: usualCubit.carbsDetails.length,
                              itemBuilder: (context, indedx) {
                                return rowItem(
                                    usualCubit.carbsDetails[indedx], 'carbs');
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Column(
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              'Fats',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          staticBar('fats'),
                          if (usualCubit.fatsDetails.isEmpty)
                            SizedBox(height: 20),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: usualCubit.fatsDetails.length,
                              itemBuilder: (context, indedx) {
                                return rowItem(
                                    usualCubit.fatsDetails[indedx], 'fats');
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
          usualCubit.addLoading == true
              ? Container(
            height: 40,
            child: Lottie.asset('assets/loader.json'),
          )
              : InkWell(
            onTap: () async {
              if (_mealName.text.isEmpty) {
                Fluttertoast.showToast(msg: "Please, Enter meal name");
              } else if (usualCubit.foodItems.isEmpty &&
                  widget.mealId == null) {
                Fluttertoast.showToast(msg: "Please, Add meal first");
              } else {
                if (widget.mealData == null) {
                  /*         print("${usualCubit.foodItems.map((e) => e.foodId)}"
                            .replaceAll('(', '')
                            .replaceAll(')', ''));
                        print("${usualCubit.foodItems.map((e) => e.quantity)}"
                            .replaceAll('(', '')
                            .replaceAll(')', ''));*/
                  await usualCubit.createUsualMeal(mealParameters: {
                    "name": _mealName.text,
                    "food_id":
                    "${usualCubit.foodItems.map((e) => e.foodId)}"
                        .replaceAll('(', '')
                        .replaceAll(')', ''),
                    "qty":
                    "${usualCubit.foodItems.map((e) => e.quantity)}"
                        .replaceAll('(', '')
                        .replaceAll(')', ''),
                    "calories":usualCubit.foodItems.fold(0.0, (previousValue, element) => previousValue +
                        (
                            element.quantity*
                                (usualCubit.caloriesDetails.any((a) => element.foodId==a.id)?
                            usualCubit.caloriesDetails.firstWhere((a) => element.foodId==a.id).caloriePerUnit:
                            usualCubit.fatsDetails.any((a) => element.foodId==a.id)?
                            usualCubit.fatsDetails.firstWhere((a) => element.foodId==a.id).caloriePerUnit:
                            usualCubit.carbsDetails.any((a) => element.foodId==a.id)?
                            usualCubit.carbsDetails.firstWhere((a) => element.foodId==a.id).caloriePerUnit:0)
                        )
                    )
                  },diaryCubit: diaryCubit).then((value) async {
                    _mealName.clear();
                    Get.back();
                  });
                } else {
                  /* print("${usualCubit.foodItems.map((e) => e.foodId)}"
                            .replaceAll('(', '')
                            .replaceAll(')', ''));
                        print("${usualCubit.foodItems.map((e) => e.quantity)}"
                            .replaceAll('(', '')
                            .replaceAll(')', ''));*/
                  await usualCubit
                      .updateCurrentUsualMeal(mealParameters: {
                    "id": widget.mealId,
                    "name": _mealName.text,
                    "food_id":
                    "${usualCubit.foodItems.map((e) => e.foodId)}"
                        .replaceAll('(', '')
                        .replaceAll(')', ''),
                    "qty": "${usualCubit.foodItems.map((e) => e.quantity)}"
                        .replaceAll('(', '')
                        .replaceAll(')', ''),
                  },diaryCubit:diaryCubit).then((value) {
                    Get.back();
                  });
                }
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Color(0xffF1F9E3),
              ),
              child: kButtonDefault(
                widget.mealData == null ? 'Save Meal' : 'Update Meal',
                marginH: MediaQuery
                    .of(Get.context!)
                    .size
                    .width / 6,
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

  String getTotal(String total) {
    return total;
  }

  Widget rowItem(FoodDataItem item, String type) {
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
                                  ? usualCubit.response.value.data!.proteins!
                                  : type == 'carbs'
                                  ? usualCubit.response.value.data!.carbs!
                                  : usualCubit.response.value.data!.fats!,
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
                                if (text.isNum) {
                                  item.qty = text;
                                  print(item.qty);
                                  for (var element in usualCubit.foodItems) {
                                    if (element.foodId == item.id) {
                                      double.parse(item.qty) * item.caloriePerUnit;
                                      element.quantity = double.parse(item.qty);
                                    }
                                  }
                                  setState(() {});
                                }
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
                            ? usualCubit.response.value.data!.proteins!
                            : type == 'carbs'
                            ? usualCubit.response.value.data!.carbs!
                            : usualCubit.response.value.data!.fats!,
                        item,
                        type == 'proteins'
                            ? 'proteins'
                            : type == 'carbs'
                            ? 'carbs'
                            : 'fats',
                      );
                    },
                    child: itemWidget(
                      title: item.title == null ? '' : '${item.title}',
                      showDropDownArrow:
                      item.title == null || '${item.title}'.isEmpty,
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
                    item.caloriePerUnit == null
                        ? ''
                        : '${(double.parse(item.qty.toString()) *
                        item.caloriePerUnit).toStringAsFixed(1)}',
                    color: Colors.black,
                    bold: false,
                  ),
                ),
              ),
              Container(width: 1, height: 38, color: Color(0xffE1E1E3)),
              Expanded(
                flex: 1,
                child: DeleteItemWidget(
                  controller: usualCubit,
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
              kTextHeader(totalCalories,
                  bold: false, size: 20, color: Colors.black),
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
                  usualCubit.caloriesDetails.add(FoodDataItem());
                } else if (type == 'carbs') {
                  usualCubit.carbsDetails.add(FoodDataItem());
                } else {
                  usualCubit.fatsDetails.add(FoodDataItem());
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

  void showQualityDialog(List<FoodDataItem> food, FoodDataItem item,
      String type) async {
    print("Item Data => ${item.title}");
    print("Item Data => ${item.id}");
    // show screen dialog
    result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return Dialog(
            child: SaveNewMeal(
              list: food,
            ),
          );
        });
    if (result != null) {
      FoodDataItem food = result as FoodDataItem;
      if (item.id != null) {
        usualCubit.foodItems.removeWhere((element) => element.foodId == item.id);
      }
      item.title = food.title;
      item.qty = food.qty;
      item.color = food.color;
      item.unit = food.unit;
      item.caloriePerUnit = food.caloriePerUnit;
      usualCubit.sendJsonData(food);
      usualCubit.caloriesDetails.refresh();
      usualCubit.carbsDetails.refresh();
      usualCubit.fatsDetails.refresh();
    }
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }
}

class DeleteItemWidget extends StatefulWidget {
  final FoodDataItem item;
  final UsualCubit controller;
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
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (widget.type == 'proteins') {
          if (widget.item.id == null) {
            widget.controller.foodItems.removeWhere((element) =>
            widget.item.title == element.mealName);
          } else {
            widget.controller.foodItems.removeWhere((element) =>
            widget.item.id == element.foodId);
          }
          if (widget.item.title == null) {
            widget.controller.caloriesDetails.remove(widget.item);
          } else {
            widget.controller.caloriesDetails.removeWhere((element) =>
            widget.item.title == element.title);
          }
        }
        else if (widget.type == 'carbs') {
          if (widget.item.id == null) {
            widget.controller.foodItems.removeWhere((element) =>
            widget.item.title == element.mealName);
          } else {
            widget.controller.foodItems.removeWhere((element) =>
            widget.item.id == element.foodId);
          }
          if (widget.item.title == null) {
            widget.controller.carbsDetails.remove(widget.item);
          } else {
            widget.controller.carbsDetails.removeWhere((element) =>
            widget.item.title == element.title);
          }
        }
        else {
          if (widget.item.id == null) {
            widget.controller.foodItems.removeWhere((element) =>
            widget.item.title == element.mealName);
          } else {
            widget.controller.foodItems.removeWhere((element) =>
            widget.item.id == element.foodId);
          }
          if (widget.item.title == null) {
            widget.controller.fatsDetails.remove(widget.item);
          } else {
            widget.controller.fatsDetails.removeWhere((element) =>
            widget.item.title == element.title);
          }
        }
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
