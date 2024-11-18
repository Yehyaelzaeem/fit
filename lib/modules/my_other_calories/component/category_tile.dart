import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/models/my_other_calories_response.dart';
import '../../../core/resources/resources.dart';
import '../../../core/view/widgets/custom_text.dart';
import '../../../core/view/widgets/spaces.dart';
import '../../diary/cubits/diary_cubit.dart';
import '../add_new_other_calories.dart';
import '../my_other_calories.dart';
import '../../../core/models/day_details_reposne.dart' as dayDetails;

class CategoryTile extends StatefulWidget {
  final Widget icon;
  final String title;
  final int type;
  const CategoryTile({super.key,
    required this.icon,
    required this.title,
    required this.type,

  });

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          children: [
            widget.icon,
            HorizontalSpace(AppSize.s8),
            SizedBox(
                child: CustomText(widget.title,fontSize: FontSize.s18,fontWeight: FontWeightManager.medium,)),

            Spacer(),

            InkWell(
                onTap: () async {
                  dynamic result = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,  // This will allow the bottom sheet to take full screen height if needed
                    backgroundColor: AppColors.white.withOpacity(0.001),

                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.8,  // Adjust the height factor to control how much space the bottom sheet takes
                        child: AddNewCalorie(type: widget.type
                        ),
                      );
                    },
                  );

                  if (result == null) getDiaryData(context);
                  if(result!=null){

                    if (widget.type == 1)BlocProvider.of<DiaryCubit>(context).otherCaloriesResponse.data!.proteins!.add(result);
                    if (widget.type == 2) BlocProvider.of<DiaryCubit>(context).otherCaloriesResponse.data!.carbs!.add(result);
                    if (widget.type == 3) BlocProvider.of<DiaryCubit>(context).otherCaloriesResponse.data!.fats!.add(result);

                    // final controllerDiary = Get.find<DiaryController>(tag: 'diary');
                    Proteins a = result;

                    ItemResponse itemResponse =calculateItemDetails(a.qty!,int.parse(a.calories));

                    if (widget.type == 1)
                      BlocProvider.of<DiaryCubit>(context).dayDetailsResponse!.data!.proteins!.food!.add(dayDetails.Food(
                          id: 9999,
                          title: a.title,
                          unit: itemResponse.units??a.qty,
                          qty: 1.0,
                          caloriePerUnit: double.parse(itemResponse.caloriesPerUnit??a.calories),
                          color: 'F00000'

                      ));
                    if (widget.type == 2) BlocProvider.of<DiaryCubit>(context).dayDetailsResponse!.data!.carbs!.food!.add(dayDetails.Food(
                        id: 9999,
                        title: a.title,
                        unit: itemResponse.units??a.qty,
                        qty: 1.0,
                        caloriePerUnit: double.parse(itemResponse.caloriesPerUnit??a.calories),
                        color: 'F00000'
                    ));
                    if (widget.type == 3)
                      BlocProvider.of<DiaryCubit>(context).dayDetailsResponse!.data!.fats!.food!.add(dayDetails.Food(
                          id: 9999,
                          title: a.title,
                          unit: itemResponse.units??a.qty,
                          qty: 1.0,
                          caloriePerUnit: double.parse(itemResponse.caloriesPerUnit??a.calories),
                          color: 'F00000'
                      ));
                    await BlocProvider.of<DiaryCubit>(context).saveDiaryLocally(BlocProvider.of<DiaryCubit>(context).dayDetailsResponse!,BlocProvider.of<DiaryCubit>(context).lastSelectedDate.value);

                    await BlocProvider.of<DiaryCubit>(context).saveMyOtherCaloriesLocally(BlocProvider.of<DiaryCubit>(context).otherCaloriesResponse);
                  }

                  // setState(() {});
                },

                child: SvgPicture.asset(AppIcons.plus)),

            ],
        ),
    );
  }

  ItemResponse calculateItemDetails(String qty, int calories) {
    String? caloriesPerUnit;
    String? units;

    // Splitting the qty string into quantity and unit
    List<String> qtyParts = qty.split(" ");
    if (qtyParts.length == 2) {
      String quantity = qtyParts[0];
      String unit = qtyParts[1];
      // Calculating calories per unit
      double quantityValue = double.tryParse(quantity) ?? 1.0;
      double caloriesPerUnitValue = calories / quantityValue;
      caloriesPerUnit = caloriesPerUnitValue.toStringAsFixed(2);
      units = unit;
    }

    return ItemResponse(caloriesPerUnit: caloriesPerUnit, units: units);
  }

  void getDiaryData(BuildContext context) async {
    await BlocProvider.of<DiaryCubit>(context).fetchOtherCalories(isChangeState: true).then((value) {
      // if (value.success == true) {
      //   setState(() {
      //     diaryCubit.otherCaloriesResponse = value;
      //     isLoading = false;
      //   });
      // } else {
      //   setState(() {
      //     diaryCubit.otherCaloriesResponse = value;
      //     isLoading = false;
      //   });
      //   // Fluttertoast.showToast(msg: "${value.message}");
      //   print("error");
      // }
    });
  }
}
