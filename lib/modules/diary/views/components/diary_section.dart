
import 'dart:io';
import 'dart:math';

import 'package:app/core/resources/app_assets.dart';
import 'package:app/core/view/views.dart';
import 'package:app/modules/diary/cubits/diary_cubit.dart';
import 'package:app/modules/diary/views/diary_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../core/models/day_details_reposne.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/resources/font_manager.dart';
import '../../../../core/view/widgets/default/text.dart';
import '../../add_new_food.dart';

class DiarySection extends StatefulWidget {
  final Widget iconWidget;
  final String title;
  final String type;
  final Proteins? item;
  final DiaryCubit diaryCubit;
  final List<CaloriesDetails> caloriesDetails;
  const DiarySection({super.key,
    required this.iconWidget,
    required this.title,
    required this.type,
    required this.item,
    required this.diaryCubit,
    required this.caloriesDetails,

  });

  @override
  State<DiarySection> createState() => _DiarySectionState();
}

class _DiarySectionState extends State<DiarySection>  with SingleTickerProviderStateMixin{
  late AnimationController _animationController;
  late Animation<double> _iconTurns;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleExpansionChanged(bool expanded) {
    setState(() {
      isExpanded = expanded;
      if (expanded) {
        _animationController.forward(); // Rotate icon downwards
      } else {
        _animationController.reverse(); // Rotate icon back upwards
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.s8),

        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),

          child: ExpansionTile(
            backgroundColor: AppColors.white,
            collapsedBackgroundColor: AppColors.white,
            initiallyExpanded: false,
            expandedAlignment: Alignment.centerRight,
            onExpansionChanged: _handleExpansionChanged,
            trailing: Padding(
              padding: const EdgeInsets.only(top: AppSize.s24),
              child: RotationTransition(
                turns: _iconTurns,
                child: const Icon(Icons.expand_more),
              ),
            ),
            tilePadding: EdgeInsets.only(left: AppSize.s6,right: AppSize.s2),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(

                  children: [
                    // Image.asset(icon),
                    widget.iconWidget,
                    HorizontalSpace(AppSize.s6),
                    CustomText(widget.title,
                      fontSize: FontSize.s18,
                      fontWeight: FontWeight.w600,
                    ),
                    Spacer(),

                    CustomText(
                      widget.item!=null?'${widget.item!.caloriesTotal!.taken} / ${widget.item!.caloriesTotal!.imposed}':'',

                        fontWeight: FontWeightManager.medium,
                        fontSize: FontSize.s18,
                      ),
                  ],
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal:0,vertical: AppSize.s12),
                //   child: new LinearPercentIndicator(
                //     // width: AppSize.s150,
                //     animation: true,
                //     lineHeight: AppSize.s20,
                //     animationDuration: 500,
                //     padding: EdgeInsets.zero,
                //     percent: widget.item==null?0:(widget.item!.caloriesTotal!.progress!.percentage!.toDouble() / 100)>1?1:(widget.item!.caloriesTotal!.progress!.percentage!.toDouble() / 100),
                //     center: Text(""),
                //     curve: Curves.easeInCirc,
                //
                //     barRadius: Radius.circular(AppSize.s24),
                //     progressColor: widget.item?.caloriesTotal?.progress?.bg!=null?Color(
                //         int.parse("0xFF${widget.item!.caloriesTotal!.progress!.bg}")):AppColors.primary,
                //     backgroundColor: AppColors.lightGrey,
                //   ),
                // ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: AppSize.s12),
                  child: AnimatedPercentIndicator(
                        percent: widget.item==null?0:(widget.item!.caloriesTotal!.progress!.percentage!.toDouble() / 100)>1?1:(widget.item!.caloriesTotal!.progress!.percentage!.toDouble() / 100),

                  progressColor: widget.item?.caloriesTotal?.progress?.bg!=null?Color(
                            int.parse("0xFF${widget.item!.caloriesTotal!.progress!.bg}")):AppColors.primary,
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 0, vertical: AppSize.s12),
                //   child: AnimatedPercentIndicator(
                //     percent: widget.item == null
                //         ? 0
                //         : (widget.item!.caloriesTotal!.progress!.percentage!.toDouble() / 100)
                //         .clamp(0.0, 1.0), // Ensure it's within valid range
                //     progressColor: widget.item?.caloriesTotal?.progress?.bg != null
                //         ? Color(int.parse("0xFF${widget.item!.caloriesTotal!.progress!.bg}"))
                //         : AppColors.primary,
                //   ),
                // ),
              ],
            ),
            children: [

              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal:AppSize.s6),
                      child: FittedBox(
                        child: Container(
                          padding: EdgeInsets.all(AppSize.s12),
                          decoration: BoxDecoration(
                            color: AppColors.customBlack,
                            borderRadius: BorderRadius.circular(AppSize.s8)
                        
                          ),
                          alignment: Alignment.center,
                          child: CustomText(
                            'Quantity',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: FontSize.s14,
                          ),
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
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: FittedBox(
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
                            'Calories',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: FontSize.s14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSize.s36,)

                ],
              ),
              VerticalSpace(AppSize.s4),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: widget.caloriesDetails.length,
                  itemBuilder: (context, indedx) {
                    return CaloriesRowItem(item:widget.caloriesDetails[indedx],
                        type:widget.type, diaryCubit: widget.diaryCubit,
                      index: indedx,
                      refreshParent: (){
                      switch (widget.type) {
                        case 'proteins':
                          widget.diaryCubit.dayDetailsResponse!.data!.proteins!.caloriesDetails!.last.randomId=widget.diaryCubit.dayDetailsResponse?.data?.proteins?.caloriesDetails?.last.randomId;
                          break;
                        case 'carbs':
                          widget.diaryCubit.dayDetailsResponse!.data!.carbs!.caloriesDetails!.last.randomId=widget.diaryCubit.dayDetailsResponse?.data?.carbs?.caloriesDetails?.last.randomId;
                          break;
                        case 'fats':
                          widget.diaryCubit.dayDetailsResponse!.data!.fats!.caloriesDetails!.last.randomId=widget.diaryCubit.dayDetailsResponse?.data?.fats?.caloriesDetails?.last.randomId;
                          break;
                        default:
                          throw Exception('Unknown type: ${widget.type}');
                      }
                      setState(() {

                      });
                      },);
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
                        BlocProvider.of<DiaryCubit>(context).addNewRow(widget.title);
                      },
                      child: SvgPicture.asset(AppIcons.plus)),
              )

            ],
          ),
        ),
      ),
    );
  }
}


class CaloriesRowItem extends StatelessWidget {
  final CaloriesDetails item;
  final String type;
  final DiaryCubit diaryCubit;
  final VoidCallback refreshParent;
  final int index;
  const CaloriesRowItem({super.key,required this.item,required this.type,required this.diaryCubit,required this.refreshParent,required this.index});

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
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal:AppSize.s6),
                  child: Container(
                    // padding: EdgeInsets.all(AppSize.s2),
                    // decoration: BoxDecoration(
                    //   // borderRadius: BorderRadius.circular(4),
                    //   border: Border(
                    //     left: BorderSide(
                    //       color: AppColors.black,  // Left border color
                    //       width: 1.0,          // Left border width
                    //     ),
                    //     right: BorderSide(
                    //       color: AppColors.customBlack,
                    //       width: 1.0,
                    //     ),
                    //     bottom: BorderSide(
                    //       color: AppColors.customBlack,  // Bottom border color
                    //       width: 1.0,          // Bottom border width
                    //     ),
                    //     // No top border specified
                    //   ),
                    // ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 8,
                            child: GestureDetector(
                              onTap: () {
                                // showQualityDialog(
                                //   type == 'proteins'
                                //       ? diaryCubit
                                //       .dayDetailsResponse!.data!.proteins!.food!
                                //       : type == 'carbs'
                                //       ? diaryCubit
                                //       .dayDetailsResponse!.data!.carbs!.food!
                                //       : diaryCubit
                                //       .dayDetailsResponse!.data!.fats!.food!,
                                //   item,
                                //   type == 'proteins'
                                //       ? 'proteins'
                                //       : type == 'carbs' ? 'carbs' : 'fats',
                                // );
                              },
                              child: Container(
                                // margin: EdgeInsets.symmetric(
                                //     horizontal: 2, vertical: 2),
                                height: 34,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  key: Key('foodName_${item.id}_${item.qty}'),
                                  decoration: InputDecoration(
                                    hintText: '',
                                    hintStyle: TextStyle(fontSize: FontSize.s14,fontWeight: FontWeight.w500),
                                    labelStyle: TextStyle(fontSize: FontSize.s14,fontWeight: FontWeight.w500),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(
                                          color: kColorPrimary, width: 2),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        top: 10, bottom: 10, left: 2),
                                  ),
                                  style: TextStyle(
                                      fontSize: FontSize.s16,
                                      fontWeight: FontWeight.w500,
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
                                      Food food = Food();

                                      // Fetch the corresponding food based on the type
                                      if (type == 'proteins') {
                                        food = diaryCubit.dayDetailsResponse!.data!.proteins!.food!.firstWhere(
                                                (element) => element.title == item.quality);
                                      } else if (type == 'carbs') {
                                        food = diaryCubit.dayDetailsResponse!.data!.carbs!.food!.firstWhere(
                                                (element) => element.title == item.quality);
                                      } else {
                                        food = diaryCubit.dayDetailsResponse!.data!.fats!.food!.firstWhere(
                                                (element) => element.title == item.quality);
                                      }

                                      item.calories = (food.caloriePerUnit * qty).toStringAsFixed(2);

                                      // Check if it's a new item or an existing one
                                      if (item.id == null && item.randomId != null) {
                                        // Create a new entry if id is null

                                        diaryCubit.createOrUpdateFoodData(
                                          food,
                                          qty,
                                          type: type, // Directly pass the type
                                          randomId: item.randomId,
                                            itemIndex:index,
                                        );

                                      } else {
                                        // Update existing item

                                        diaryCubit.createOrUpdateFoodData(
                                          food,
                                          qty,
                                          type: type, // Directly pass the type
                                          index: item.id, // Make sure index is correct for updating
                                          randomId: item.randomId, // Pass the randomId for extra safety
                                          itemIndex: index
                                        );

                                        // Avoid manual updates to `item.qty` and `item.calories` here
                                        // Let createOrUpdateFoodData handle the updates and refresh the data
                                      }
                                    } catch (e) {
                                      print('Error updating food data: $e');
                                    }

                                    // if (text.isEmpty) return;
                                    // try {
                                    //   double qty = double.parse(text);
                                    //   Food food = Food();
                                    //   if (type == 'proteins') {
                                    //     food = diaryCubit
                                    //         .dayDetailsResponse!.data!.proteins!.food!
                                    //         .firstWhere((element) =>
                                    //     element.title == item.quality)
                                    //     ;
                                    //   }
                                    //   else if (type == 'carbs') {
                                    //     food = diaryCubit
                                    //         .dayDetailsResponse!.data!.carbs!.food!
                                    //         .firstWhere((element) =>
                                    //     element.title == item.quality)
                                    //     ;
                                    //   } else {
                                    //     food = diaryCubit
                                    //         .dayDetailsResponse!.data!.fats!.food!
                                    //         .firstWhere((element) =>
                                    //     element.title == item.quality)
                                    //     ;
                                    //   }
                                    //
                                    //   if(item.id==null&&item.randomId!=null) {
                                    //     diaryCubit.createOrUpdateFoodData(
                                    //       food,
                                    //       qty,
                                    //       type: type == 'proteins'
                                    //           ? 'proteins'
                                    //           : type == 'carbs'
                                    //           ? 'carbs'
                                    //           : 'fats',
                                    //       randomId: item.randomId,
                                    //       index:item.id,
                                    //     );
                                    //   }
                                    //   else{
                                    //
                                    //     diaryCubit.createOrUpdateFoodData(
                                    //       food,
                                    //       qty,
                                    //       type: type == 'proteins'
                                    //           ? 'proteins'
                                    //           : type == 'carbs'
                                    //           ? 'carbs'
                                    //           : 'fats',
                                    //       index:item.id,
                                    //
                                    //     );
                                    //     item.qty = qty;
                                    //     item.calories = (food.caloriePerUnit * qty).toStringAsFixed(2);
                                    //   }
                                    //
                                    //
                                    //
                                    // } catch (e) {}
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
                          //         item.unit == null ? '' : '${item.unit}',
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
                ),
              ),
              Expanded(
                flex: 9,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal:AppSize.s6),
                  child: Container(
                    // margin: EdgeInsets.symmetric(horizontal: 4),
                    width: double.infinity,
                    height: 34,
                    child: GestureDetector(
                      onTap: () async{

                        await showQualityDialog(
                          type == 'proteins'
                              ? diaryCubit.dayDetailsResponse!.data!.proteins!.food!
                              : type == 'carbs'
                              ? diaryCubit.dayDetailsResponse!.data!.carbs!.food!
                              : diaryCubit.dayDetailsResponse!.data!.fats!.food!,
                          item,
                          type == 'proteins'
                              ? 'proteins'
                              : type == 'carbs'
                              ? 'carbs'
                              : 'fats',
                          context
                        );

                        print("refreshParent");
                        refreshParent();

                      },
                      child: itemWidget(
                        title: item.quality == null ? '' : '${item.quality}',
                        showDropDownArrow:
                        item.quality == null || '${item.quality}'.isEmpty,
                        color: item.color == 'FFFFFF'? '555555': item.color,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal:AppSize.s6),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal:AppSize.s4,vertical: AppSize.s3),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.black,),
                      borderRadius: BorderRadius.circular(AppSize.s4)
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: kTextbody(
                        item.calories == null ? '' : '${item.calories}',
                        color: Colors.black,
                        bold: false,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: AppSize.s36,
                  child: DeleteItemWidget(
                    controller: diaryCubit,
                    item: item,
                    index:index,
                    type: type == 'proteins'
                        ? 'proteins'
                        : type == 'carbs'
                        ? 'carbs'
                        : 'fats',

                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }


  Widget itemWidget(
      {required String title, bool showDropDownArrow = false, String? color}) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 2),
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black, width: 1),
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
                      fontSize: FontSize.s14,
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

   showQualityDialog(
      List<Food> food, CaloriesDetails item, String type, BuildContext context) async {
    // Show dialog
    dynamic result = await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: AddNewFood(
              date: diaryCubit.lastSelectedDate.value,
              list: food,
            ),
          );
        });

    if (result != null) {
      Food food = result as Food;

      // Update item properties
      item.quality = food.title;
      item.qty = food.qty;
      item.color = food.color;

      if (food.qty != null) {
        // Update calories and unit
        item.calories = (food.qty! * food.caloriePerUnit).toStringAsFixed(2);
        item.unit = food.unit;
      }


      // Call createOrUpdateFoodData for updating or creating the item
      diaryCubit.createOrUpdateFoodData(
        food,
        food.qty!,
        type: type,
        index: item.id,  // Ensure index is used correctly
        randomId: item.randomId,  // Make sure randomId is unique and used correctly
        hasNoId: item.id==null && item.randomId==null
      );
    }

    FocusScope.of(context).requestFocus(FocusNode());
  }

  // void showQualityDialog(
  //     List<Food> food, CaloriesDetails item, String type,BuildContext context) async {
  //   // show screen dialog
  //   dynamic result = await showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Dialog(
  //           child: AddNewFood(
  //             date: diaryCubit.apiDate.value,
  //             list: food,
  //           ),
  //         );
  //       });
  //   if (result != null) {
  //     print('resultFood');
  //     Food food = result as Food;
  //     item.quality = food.title;
  //     item.qty = food.qty;
  //     item.color = food.color;
  //     if(food.qty!=null){
  //       // item.calories = food.qty! * food.caloriePerUnit;
  //       item.calories = (food.qty! * food.caloriePerUnit).toStringAsFixed(2);
  //       item.unit = food.unit;
  //     }
  //
  //
  //
  //
  //     diaryCubit.createOrUpdateFoodData(
  //       food, food.qty!, type: type,
  //       index:item.id,
  //       randomId:item.randomId,
  //     );
  //
  //   }
  //   FocusScope.of(context).requestFocus(FocusNode());
  // }

}



// class AnimatedPercentIndicator extends StatefulWidget {
//   final double percent; // The current percentage value
//   final Color progressColor;
//
//   const AnimatedPercentIndicator({
//     Key? key,
//     required this.percent,
//     required this.progressColor,
//   }) : super(key: key);
//
//   @override
//   State<AnimatedPercentIndicator> createState() => _AnimatedPercentIndicatorState();
// }
//
// class _AnimatedPercentIndicatorState extends State<AnimatedPercentIndicator> {
//   double _currentPercent = 0.0; // Initial value
//
//   @override
//   void didUpdateWidget(covariant AnimatedPercentIndicator oldWidget) {
//     super.didUpdateWidget(oldWidget);
//
//     // Update the current percent only if it changes
//     if (oldWidget.percent != widget.percent) {
//       setState(() {
//         _currentPercent = widget.percent.clamp(0.0, 1.0); // Clamp value between 0 and 1
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12.0),
//       child: LinearPercentIndicator(
//         animation: true,
//         lineHeight: 20.0,
//         animationDuration: 500, // Animation duration
//         percent: _currentPercent, // Use the tracked percent value
//         curve: Curves.easeInCirc,
//         barRadius: const Radius.circular(24.0),
//         progressColor: widget.progressColor,
//         backgroundColor: Colors.grey.shade300,
//         center: Text("${(_currentPercent * 100).toStringAsFixed(0)}%"),
//       ),
//     );
//   }
// }

class AnimatedPercentIndicator extends StatefulWidget {
  final double percent; // Current percent value
  final Color progressColor;

  const AnimatedPercentIndicator({
    Key? key,
    required this.percent,
    required this.progressColor,
  }) : super(key: key);

  @override
  _AnimatedPercentIndicatorState createState() =>
      _AnimatedPercentIndicatorState();
}

class _AnimatedPercentIndicatorState extends State<AnimatedPercentIndicator> {
  double _previousPercent = 0.0; // Tracks the previous value

  @override
  void didUpdateWidget(covariant AnimatedPercentIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update only if the new percent value is different
    if (oldWidget.percent != widget.percent) {
      setState(() {
        _previousPercent = oldWidget.percent.clamp(0.0, 1.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: LinearPercentIndicator(
        animation: false,
        lineHeight: 20.0,
        animationDuration: 500, // Animation duration
        percent: widget.percent, // Use current percent
        curve: Curves.linear,
        barRadius: const Radius.circular(24.0),
        progressColor: widget.progressColor,
        backgroundColor: Colors.grey.shade300,
        // center: Text("${(widget.percent * 100).toStringAsFixed(0)}%"),
      ),
    );
  }
}