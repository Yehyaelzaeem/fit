import 'package:app/config/navigation/navigation.dart';
import 'package:app/core/view/views.dart';
import 'package:app/modules/diary/cubits/diary_cubit.dart';
import 'package:app/modules/usuals/cubits/usual_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/models/usual_meals_reposne.dart';
import '../../../core/resources/resources.dart';
import '../../../core/view/widgets/app_dialog.dart';
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 2,
                spreadRadius: 2,
                offset: Offset(0, 0),
              ),
            ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSize.s12),

          child: ExpansionTile(
            backgroundColor: AppColors.white,
            collapsedBackgroundColor: AppColors.white,
            initiallyExpanded: false,
            title: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        widget.mealName,
                      fontWeight: FontWeightManager.semiBold,
                      fontSize: FontSize.s18,
                    ),
                    CustomText(
                      "${widget.mealCalories} Cal.",
                      fontSize: FontSize.s14,
                      fontWeight: FontWeightManager.medium,
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: ()async{
                          showAddOptionsDialog(context);
                          // await usualCubit.addMealToDiary(mealId: widget.mealId!,meal: widget.meal,diaryCubit:diaryCubit);

                          // NavigationService.goBack(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(AppSize.s8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                            ),
                            child: SvgPicture.asset(AppIcons.storeSvg,height: FontSize.s18,width: FontSize.s18,)),
                      ),
                      HorizontalSpace(AppSize.s12),
                      InkWell(
                        onTap: (){

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,  // This will allow the bottom sheet to take full screen height if needed
                            backgroundColor: AppColors.white.withOpacity(0.001),
                            builder: (context) {
                              return FractionallySizedBox(
                                heightFactor: 0.8,  // Adjust the height factor to control how much space the bottom sheet takes
                                child: MakeAMealView(
                                  mealData: widget.meal,
                                  mealId: widget.mealId,
                                  mealName: widget.mealName,
                                  refresh: (){
                                    setState(() {

                                    });
                                  },
                                ),
                              );
                            },
                          ).then((value) async{
                            await usualCubit.fetchUsualMealsData();

                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(AppSize.s8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    offset: Offset(0, 0),
                                  ),
                                ]
                            ),
                            child: SvgPicture.asset(AppIcons.pen,height: FontSize.s18,width: FontSize.s18,)),
                      ),
                      HorizontalSpace(AppSize.s12),
                      InkWell(
                          onTap: () async {
                            appDialog(
                              title: "Do you want to delete ${widget.mealName}?",
                              image:  Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: SvgPicture.asset(AppIcons.trashSvg,height: AppSize.s32,width: AppSize.s32,),
                              ),
                              // image: Icon(Icons.de, size: 32, color: Colors.red),
                              context: context,
                              cancelAction: () {
                                NavigationService.goBack(context);
                              },
                              cancelText: "No",
                              confirmAction: () async {
                                NavigationService.goBack(context);
                                usualCubit
                                    .deleteUserUsualMeal(widget.mealId!).then((value){
                                      setState(() {

                                      });
                                });
                              },
                              confirmText: "Yes",
                            );
                          },

                        child: Container(
                          padding: EdgeInsets.all(AppSize.s8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    offset: Offset(0, 0),
                                  ),
                                ]
                            ),
                            child: SvgPicture.asset(AppIcons.trashSvg,height: FontSize.s18,width: FontSize.s18,)),
                      ),
                    ],
                  ),
                )
              ],
            ),

            children: [
              SizedBox(
                height: 8,
              ),
              if (widget.meal?.proteins != null)

                CaloriesTypeItemWidget(
                  caloriesTypeName: 'Proteins',
                  usualProteins: widget.meal!.proteins!,
                  mealCalories: widget.mealCalories,
                  icon: Container(
                    width: 35,
                    height: 28,
                    decoration: ShapeDecoration(
                      color: Color(0x4C7FC902),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(AppImages.proteins,width: 20,
                      height: 20,),
                  ),
                ),
              if (widget.meal?.carbs != null)
                CaloriesTypeItemWidget(
                  icon: Container(
                    width: 35,
                    height: 28,
                    decoration: ShapeDecoration(
                      color: Color(0xFFB9E5F9),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(AppImages.carbs,width: 20,
                      height: 20,),
                  ),
                  caloriesTypeName: 'Carbs',
                  usualProteins: widget.meal!.carbs!,
                  mealCalories: widget.mealCalories,
                ),
              if (widget.meal?.fats != null)
                CaloriesTypeItemWidget(
                  icon: Container(
                    width: 35,
                    height: 28,
                    decoration: ShapeDecoration(
                      color: Color(0x3FCFC928),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(AppImages.fats,width: 20,
                      height: 20,),
                  ),
                  caloriesTypeName: 'Fats',
                  usualProteins: widget.meal!.fats!,
                  mealCalories: widget.mealCalories,
                ),
              SizedBox(height: 18),

            ],

          )),
      ));

  }

  void showAddOptionsDialog(BuildContext context) {
    TextEditingController fractionController = TextEditingController();
    int selectedOption = 1; // 1 for "Add to Diary", 2 for "Add Fraction"

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: AddToDiaryDialog(mealId: widget.mealId!,meal: widget.meal,)
            );
          },
        );
      },
    );
  }
}


class AddToDiaryDialog extends StatefulWidget {
  final int mealId;
  final MealData? meal;
  const AddToDiaryDialog({super.key,required this.meal,required this.mealId});

  @override
  State<AddToDiaryDialog> createState() => _AddToDiaryDialogState();
}

class _AddToDiaryDialogState extends State<AddToDiaryDialog> {
  TextEditingController fractionController = TextEditingController();
  bool selectedOption = false; // 1 for "Add to Diary", 2 for "Add Fraction"

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s12),
          color: Colors.white
        ),
        child: selectedOption ?
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Enter a fraction'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                controller: fractionController,
                keyBoardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (val){

                },
                hintText: 'Enter a number',

              ),
            ),

            VerticalSpace(AppSize.s12),
            CustomButton(
              text: 'Save',
              height: AppSize.s40,
              width: AppSize.s100,
              onPressed: ()async{
                if(fractionController.text!= ''){
                  double fraction = double.tryParse(fractionController.text)??0;
                  await BlocProvider.of<UsualCubit>(context).addMealToDiary(mealId: widget.mealId,meal: widget.meal,fraction: fraction,diaryCubit:BlocProvider.of<DiaryCubit>(context));
                  NavigationService.goBack(context);
                  NavigationService.goBack(context);

                }
              },

            ),
          ],
        ):Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Radio button for "Add to Diary"
            CustomButton(
              text: 'Add to diary',
              height: AppSize.s40,
              width: AppSize.s200,
              onPressed: ()async{
                await BlocProvider.of<UsualCubit>(context).addMealToDiary(mealId: widget.mealId,meal: widget.meal,diaryCubit:BlocProvider.of<DiaryCubit>(context));
                NavigationService.goBack(context);
                NavigationService.goBack(context);
              },

            ),
            VerticalSpace(AppSize.s12),
            CustomButton(
              text: 'Add fraction',
              height: AppSize.s40,
              width: AppSize.s200,
              onPressed: (){
                setState(() {
                  selectedOption = true;
                });
                },
            ),


          ],
        ),
      ),
    );
  }
}
