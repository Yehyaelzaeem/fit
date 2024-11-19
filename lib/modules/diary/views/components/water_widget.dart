import 'package:app/core/resources/resources.dart';
import 'package:app/core/view/views.dart';
import 'package:app/core/view/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/navigation/navigation_services.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/view/components/scroll_fader.dart';
import '../../../../core/view/widgets/custom_button.dart';
import '../../cubits/diary_cubit.dart';

class WaterWidget extends StatefulWidget {
  const WaterWidget({super.key});

  @override
  State<WaterWidget> createState() => _WaterWidgetState();
}

class _WaterWidgetState extends State<WaterWidget> {
  late final DiaryCubit diaryCubit;


  @override
  void initState() {
    super.initState();
    diaryCubit = BlocProvider.of<DiaryCubit>(context);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8.0,horizontal: AppSize.s12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSize.s12,vertical: AppSize.s12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s8),
          color: AppColors.primary.withOpacity(0.08)
        ),
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText('Water',fontSize: FontSize.s14,fontWeight: FontWeight.w600,),
                    ],
                  ),

                  SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(AppSize.s24),
                    child: Column(
                      children: [
                        VerticalSpace(AppSize.s20),
                        InkWell(
                            onTap: (){
                              showWaterBottomSheet(context,diaryCubit,false);

                              // if((diaryCubit.dayDetailsResponse?.data?.water??0)>0) {
                              //   diaryCubit.updateWaterData("${(diaryCubit
                              //       .dayDetailsResponse?.data?.water ?? 0) - 1}");
                              // }
                            },
                            child: SvgPicture.asset(AppIcons.minus)),
                      ],
                    ),
                  ),

                  Column(
                    children: [
                      Lottie.asset(
                        'assets/animations/water.json', // Your animation file path
                        width: AppSize.s82,
                        height:  AppSize.s90,
                        fit: BoxFit.cover,
                      ),
                      CustomText('${(diaryCubit.dayDetailsResponse?.data?.water??0)} ml',fontSize: FontSize.s16,fontWeight: FontWeight.w600,)
                      ,VerticalSpace(AppSize.s2),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(AppSize.s24),
                    child: Column(
                      children: [
                        VerticalSpace(AppSize.s20),
                        InkWell(
                            onTap: (){
                              showWaterBottomSheet(context,diaryCubit,true);
                            },
                            child: SvgPicture.asset(AppIcons.plus)),
                      ],
                    ),
                  ),
                  SizedBox(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText('Water',fontSize: FontSize.s14,fontWeight: FontWeight.w600,color: AppColors.primary.withOpacity(0.08),),
                    ],
                  ),
                ],
              )
            ],
          )

          // Theme(
          //   data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          //
          //   child: ExpansionTile(
          //     initiallyExpanded: true,
          //   backgroundColor: AppColors.primary.withOpacity(0.08),
          //   collapsedBackgroundColor: AppColors.primary.withOpacity(0.08),
          //     childrenPadding:EdgeInsets.zero,
          //   tilePadding: EdgeInsets.symmetric(horizontal: AppSize.s12,vertical: AppSize.s0),
          //
          //   title:
          //   CustomText('Water',fontSize: FontSize.s14,fontWeight: FontWeight.w600,),
          //           children: [
          //             CustomText('Water',fontSize: FontSize.s14,fontWeight: FontWeight.w600,),
          //             Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.all(AppSize.s24),
          //         child: Column(
          //           children: [
          //             InkWell(
          //                 onTap: (){
          //                   showWaterBottomSheet(context,diaryCubit,false);
          //
          //                   // if((diaryCubit.dayDetailsResponse?.data?.water??0)>0) {
          //                   //   diaryCubit.updateWaterData("${(diaryCubit
          //                   //       .dayDetailsResponse?.data?.water ?? 0) - 1}");
          //                   // }
          //                 },
          //                 child: SvgPicture.asset(AppIcons.minus)),
          //             VerticalSpace(AppSize.s24)
          //           ],
          //         ),
          //       ),
          //
          //       Column(
          //         children: [
          //           Lottie.asset(
          //             'assets/animations/water.json', // Your animation file path
          //             width: AppSize.s90,
          //             height:  AppSize.s90,
          //             fit: BoxFit.cover,
          //           ),
          //           CustomText('${(diaryCubit.dayDetailsResponse?.data?.water??0)*200} ml',fontSize: FontSize.s16,fontWeight: FontWeight.w500,)
          //           ,VerticalSpace(AppSize.s12),
          //         ],
          //       ),
          //
          //       Padding(
          //         padding: const EdgeInsets.all(AppSize.s24),
          //         child: Column(
          //           children: [
          //             InkWell(
          //                 onTap: (){
          //                   showWaterBottomSheet(context,diaryCubit,true);
          //                 },
          //                 child: SvgPicture.asset(AppIcons.plus)),
          //             VerticalSpace(AppSize.s24)
          //           ],
          //         ),
          //       )
          //     ],
          //   )
          //           ],
          //           ),
          // ),
      ),
    );
  }
}

void showWaterBottomSheet(BuildContext context, DiaryCubit diaryCubit,bool isAdd) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return WaterSheet(diaryCubit: diaryCubit,isAdd:isAdd);
    },
  );
}

class WaterSheet extends StatefulWidget {
  final DiaryCubit diaryCubit;
  final bool isAdd;
  const WaterSheet({super.key,required this.diaryCubit,required this.isAdd});

  @override
  State<WaterSheet> createState() => _WaterSheetState();
}

class _WaterSheetState extends State<WaterSheet> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.diaryCubit.changeWaterSheetVal((widget.diaryCubit.dayDetailsResponse?.data?.water??0).toDouble());

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
        left: 16,
        right: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // "Workout" Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                CustomText(
                  'Water',
                  fontWeight: FontWeightManager.semiBold, fontSize: FontSize.s16,
                ),

                Spacer(),
                TextButton(onPressed: (){
                  NavigationService.goBack(context);
                }, child: CustomText(
                    'cancel'
                )),
                Center(
                  child: CustomButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      widget.diaryCubit.updateWaterData("${(widget.diaryCubit.waterSheetVal.toInt())}").then((value) {
                        NavigationService.goBack(context);
                      });
                    },
                    child: widget.diaryCubit.workoutLoading.value
                        ? CircularProgressIndicator()
                        : CustomText("Save",color: AppColors.white,),
                    color: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s16,vertical: AppSize.s8)
                    ,borderRadius: AppSize.s24,
                  ),
                ),

              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(bottom:10.0),
              //   child: SvgPicture.asset(AppIcons.w),
              // ),
              // SvgPicture.asset(AppIcons.wb),
              // HorizontalSpace(AppSize.s16),
              CustomText('${(widget.diaryCubit.waterSheetVal)} ml',fontSize: FontSize.s20,)

            ],
          ),

          VerticalSpace(AppSize.s12),
          GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
                childAspectRatio: 1),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              WaterItemWidget(
                title: '250 ml',
                icon: AppIcons.water200,
                heightIcon: AppSize.s40,
                isAdd: widget.isAdd,
                onTap: (){

                  if(widget.isAdd) {
                    widget.diaryCubit.changeWaterSheetVal(
                        widget.diaryCubit.waterSheetVal + 250);
                  }else{
                    if((widget.diaryCubit.waterSheetVal - 250)>=0){

                      widget.diaryCubit.changeWaterSheetVal(
                          widget.diaryCubit.waterSheetVal - 250);
                    }
                  }
                  setState(() {

                  });
                },
              ),
              WaterItemWidget(
                title: '600 ml',
                isAdd: widget.isAdd,
                heightIcon:AppSize.s56 - 4,
                icon: AppIcons.water400,
                onTap: (){
                  if(widget.isAdd) {
                    widget.diaryCubit.changeWaterSheetVal(
                        widget.diaryCubit.waterSheetVal + 600);
                  }else{
                    if((widget.diaryCubit.waterSheetVal - 600)>=0){

                      widget.diaryCubit.changeWaterSheetVal(
                          widget.diaryCubit.waterSheetVal - 600);
                    }
                  }
                  setState(() {

                  });
                },
              ),


              WaterItemWidget(
                title: '1 litre',
                isAdd: widget.isAdd,
                heightIcon:AppSize.s68,
                icon: AppIcons.water600,
                onTap: (){
                  if(widget.isAdd) {
                    widget.diaryCubit.changeWaterSheetVal(
                        widget.diaryCubit.waterSheetVal + 1000);
                  }else{
                    if((widget.diaryCubit.waterSheetVal - 1000)>=0){

                      widget.diaryCubit.changeWaterSheetVal(
                          widget.diaryCubit.waterSheetVal - 1000);
                    }
                  }
                  setState(() {

                  });
                },
              ),
              WaterItemWidget(
                title: '1500 ml',
                icon: AppIcons.water800,
                isAdd: widget.isAdd,
                isLarge: true,
                onChange: (val){
                  int wVal = 0;
                  wVal = int.tryParse(val!)??0;
                  if(wVal!=0){
                      if(widget.isAdd) {
                        widget.diaryCubit.waterSheetVal = (wVal).toDouble() +
                            (widget.diaryCubit.dayDetailsResponse?.data?.water ?? 0);
                      }else{
                            if((widget.diaryCubit.dayDetailsResponse?.data?.water ?? 0)>(wVal )){
                              widget.diaryCubit.waterSheetVal = (widget.diaryCubit.dayDetailsResponse?.data?.water ?? 0) -(wVal).toDouble()
                                  ;
                            }else{
                              widget.diaryCubit.changeWaterSheetVal((widget.diaryCubit.dayDetailsResponse?.data?.water??0).toDouble());

                              Alerts.showToast('Insert a valid value');
                            }
                      }
                    setState(() {

                    });
                  }else{
                    widget.diaryCubit.waterSheetVal = (widget.diaryCubit.dayDetailsResponse?.data?.water ?? 0).toDouble();
                    setState(() {

                    });
                  }


                },
              ),

            ],
          )

        ],
      ),
    );
  }
}


class WaterItemWidget extends StatelessWidget {
  final String title;
  final String icon;
  final bool isAdd;
  final bool isLarge;
  final double? heightIcon;
  final VoidCallback? onTap;
  final Function(String?)? onChange;

  const WaterItemWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.isAdd,
    this.isLarge = false,
    this.heightIcon,
     this.onTap,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s12),
                color: AppColors.white,
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(isLarge)
                  VerticalSpace(AppSize.s16),
                if(heightIcon!=null)
                if(heightIcon! < AppSize.s64)
                  VerticalSpace((AppSize.s64 - heightIcon! )),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: icon.contains('svg')?Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SvgPicture.asset(icon,width: AppSize.s48,height: AppSize.s48,fit: isLarge?BoxFit.cover:BoxFit.contain,),
                  ):Image.asset(icon,width: AppSize.s48,height: heightIcon??AppSize.s64,fit: isLarge?BoxFit.cover:null,),
                ),

                if(!isLarge)
                  VerticalSpace(AppSize.s8),
                if(!isLarge)

                  Center(child: CustomText(title,fontSize: FontSize.s16,)),

                if(heightIcon!=null)
                    VerticalSpace(AppSize.s8),
                if(isLarge)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      keyBoardType: TextInputType.number,
                      onChanged: onChange,
                      hintText: 'Custom ml',

                    ),
                  )
              ],
            ),
          ),
          if(!isLarge)
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.all(AppSize.s8),
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(AppSize.s16),bottomRight: Radius.circular(AppSize.s12))
                ),
                alignment: Alignment.center,
                child: Center(
                  child: Icon(
                    isAdd?Icons.add:Icons.minimize,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


