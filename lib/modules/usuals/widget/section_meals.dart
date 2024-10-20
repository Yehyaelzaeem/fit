import 'dart:io';

import 'package:app/modules/usuals/cubits/usual_cubit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/models/usual_meals_data_reposne.dart';
import '../../../core/resources/resources.dart';
import '../../../core/view/views.dart';
import '../../../core/view/widgets/default/text.dart';
import '../save_new_meal.dart';
import '../views/make_a_meal_view.dart';

class MealsSection extends StatefulWidget {
  final String icon;
  final String title;
  final String type;
  final UsualCubit usualCubit;
  final List<FoodDataItem> caloriesDetails;
  const MealsSection({super.key,
    required this.icon,
    required this.title,
    required this.type,
    required this.usualCubit,
    required this.caloriesDetails,

  });

  @override
  State<MealsSection> createState() => _MealsSectionState();
}

class _MealsSectionState extends State<MealsSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s12),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey.withOpacity(0.1),
                blurRadius: 1,
                spreadRadius: 2,
                offset: Offset(0, 0),
              ),
            ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSize.s12),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),

            child: ExpansionTile(
              backgroundColor: AppColors.white,
              collapsedBackgroundColor: AppColors.white,
              initiallyExpanded: true,
              title: Row(
                children: [
                  Image.asset(widget.icon),
                  HorizontalSpace(AppSize.s2),
                  SizedBox(
                      width: AppSize.s60,
                      child: CustomText(widget.title,fontSize: FontSize.s16,fontWeight: FontWeightManager.medium,)),
                  ],
              ),
              children: [

                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal:AppSize.s4),
                        child: Container(
                          padding: EdgeInsets.all(AppSize.s12),
                          decoration: BoxDecoration(
                              color: AppColors.customBlack,
                              borderRadius: BorderRadius.circular(AppSize.s8)

                          ),
                          alignment: Alignment.center,
                          child: CustomText(
                            'Quantity',
                            fontWeight: FontWeightManager.semiBold,
                            color: Colors.white,
                            fontSize: AppSize.s16,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal:AppSize.s6),
                        child: Container(
                          padding: EdgeInsets.all(AppSize.s12),
                          decoration: BoxDecoration(
                              color: AppColors.customBlack,
                              borderRadius: BorderRadius.circular(AppSize.s8)

                          ),
                          alignment: Alignment.center,
                          child: CustomText(
                            'Quality',
                            fontWeight: FontWeightManager.semiBold,
                            color: Colors.white,
                            fontSize: AppSize.s16,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal:AppSize.s6),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal:AppSize.s8,vertical: AppSize.s12),
                          decoration: BoxDecoration(
                              color: AppColors.customBlack,
                              borderRadius: BorderRadius.circular(AppSize.s8)

                          ),
                          alignment: Alignment.center,
                          child: CustomText(
                            'Calories',
                            fontWeight: FontWeightManager.semiBold,
                            color: Colors.white,
                            fontSize: AppSize.s16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.s32,)

                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: widget.caloriesDetails.length,
                    itemBuilder: (context, indedx) {
                      return MealRowItem(item:widget.caloriesDetails[indedx],
                        type:widget.type, usualCubit: widget.usualCubit,);
                    }),
                VerticalSpace(AppSize.s12),

                Container(
                  padding: EdgeInsets.all(AppSize.s8),
                  width: double.infinity,
                  height: AppSize.s40,
                  decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2)
                  ),
                  child:InkWell(
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (widget.type == 'proteins') {
                          widget.usualCubit.caloriesDetails.add(FoodDataItem());
                        } else if (widget.type == 'carbs') {
                          widget.usualCubit.carbsDetails.add(FoodDataItem());
                        } else {
                          widget.usualCubit.fatsDetails.add(FoodDataItem());
                        }
                        setState(() {

                        });
                      },
                      child: SvgPicture.asset(AppIcons.plus)),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}


class MealRowItem extends StatefulWidget {
  final FoodDataItem item;
  final String type;
  final UsualCubit usualCubit;
  const MealRowItem({super.key,
  required this.item,
    required this.type,
    required this.usualCubit,
  });

  @override
  State<MealRowItem> createState() => _MealRowItemState();
}

class _MealRowItemState extends State<MealRowItem> {
  @override
  Widget build(BuildContext context) {

      return Container(
        height: 40,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 5,
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
                                widget.type == 'proteins'
                                    ? widget.usualCubit.response.data!.proteins!
                                    : widget.type == 'carbs'
                                    ? widget.usualCubit.response.data!.carbs!
                                    : widget.usualCubit.response.data!.fats!,
                                widget.item,
                                widget.type == 'proteins'
                                    ? 'proteins'
                                    : widget.type == 'carbs'
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
                                key: Key('foodName_${widget.item.id}_${widget.item.qty}'),
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
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                    color: Colors.black),
                                enableInteractiveSelection: false,
                                initialValue: widget.item.qty == null
                                    ? ''
                                    : widget.item.qty.toString().replaceAll('.0', ''),
                                keyboardType: Platform.isIOS
                                    ? TextInputType.numberWithOptions(
                                    signed: true, decimal: true)
                                    : TextInputType.numberWithOptions(
                                    decimal: true, signed: false),
                                // keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (text) {
                                  if (text.isEmpty) return;
                                  // if (text.isNum) {
                                    widget.item.qty = text;
                                    print(widget.item.qty);
                                    for (var element in widget.usualCubit.foodItems) {
                                      if (element.foodId == widget.item.id) {
                                        double.parse(widget.item.qty) * widget.item.caloriePerUnit;
                                        element.quantity = double.parse(widget.item.qty);
                                      }
                                    }
                                    setState(() {});
                                  // }
                                },
                              ),
                            ),
                          ),
                        ),
                        // Expanded(
                        //   flex: 5,
                        //   child: FittedBox(
                        //     fit: BoxFit.scaleDown,
                        //     child: Container(
                        //       padding: EdgeInsets.symmetric(horizontal: 1),
                        //       child: kTextbody(
                        //         widget.item.unit == null ? '' : '${widget.item.unit}',
                        //         color: Colors.black,
                        //         bold: false,
                        //         size: 12,
                        //         maxLines: 2,
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: double.infinity,
                    height: 34,
                    child: GestureDetector(
                      onTap: () {
                        showQualityDialog(
                          widget.type == 'proteins'
                              ? widget.usualCubit.response.data!.proteins!
                              : widget.type == 'carbs'
                              ? widget.usualCubit.response.data!.carbs!
                              : widget.usualCubit.response.data!.fats!,
                          widget.item,
                          widget.type == 'proteins'
                              ? 'proteins'
                              : widget.type == 'carbs'
                              ? 'carbs'
                              : 'fats',
                        );
                      },
                      child: itemWidget(
                        title: widget.item.title == null ? '' : '${widget.item.title}',
                        showDropDownArrow:
                        widget.item.title == null || '${widget.item.title}'.isEmpty,
                        color: widget.item.color,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal:AppSize.s8),
                    child: Container(
                      padding: EdgeInsets.all(AppSize.s4),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.black,),
                          borderRadius: BorderRadius.circular(AppSize.s8)
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: kTextbody(
                          widget.item.caloriePerUnit == null
                              ? ''
                              : '${(double.parse(widget.item.qty.toString()) *
                              widget.item.caloriePerUnit).toStringAsFixed(1)}',
                          color: Colors.black,
                          bold: false,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: AppSize.s32,
                  child: DeleteItemWidget(
                    controller: widget.usualCubit,
                    item: widget.item,
                    type: widget.type == 'proteins'
                        ? 'proteins'
                        : widget.type == 'carbs'
                        ? 'carbs'
                        : 'fats',
                  ),
                ),
              ],
            ),
            // Divider(
            //   height: 1,
            //   color: Colors.black,
            // ),
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
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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
        context: context,
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
        widget.usualCubit.foodItems.removeWhere((element) => element.foodId == item.id);
      }
      item.title = food.title;
      item.qty = food.qty;
      item.color = food.color;
      item.unit = food.unit;
      item.caloriePerUnit = food.caloriePerUnit;
      widget.usualCubit.sendJsonData(food);
      widget.usualCubit.caloriesDetails.refresh();
      widget.usualCubit.carbsDetails.refresh();
      widget.usualCubit.fatsDetails.refresh();
    }
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
