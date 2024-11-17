
import 'package:app/core/view/views.dart';
import 'package:flutter/material.dart';

import '../../../core/models/usual_meals_reposne.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/resources/resources.dart';
import '../../../core/view/widgets/custom_text.dart';
import '../../../core/view/widgets/default/text.dart';

class StaticBar extends StatelessWidget {
  const StaticBar({Key? key, required this.type, required this.usualProteins}) : super(key: key);
final String type;
  final UsualProteins usualProteins;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
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
                      'Quantity',
                      fontWeight: FontWeightManager.semiBold,
                      color: Colors.white,
                      fontSize: AppSize.s16,
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
                  padding: EdgeInsets.symmetric(vertical:AppSize.s12-2,horizontal:AppSize.s8),
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
                      fontWeight: FontWeightManager.semiBold,
                      color: Colors.white,
                      fontSize: AppSize.s16,
                    ),
                  ),
                ),
              ),
            ),
            // Spacer(
            //   flex: 1,)

          ],
        ),
        VerticalSpace(AppSize.s2),
        // Container(
        //   height: 40,
        //   color: Color(0xFF414042),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       buildSpace(),
        //       Expanded(
        //         flex: 3,
        //         child: Container(
        //           width: double.infinity,
        //           child: Center(
        //             child: kTextbody('Quantity',
        //                 color: Colors.white,),
        //           ),
        //         ),
        //       ),
        //       buildSpace(),
        //       Expanded(
        //         flex: 5,
        //         child: Container(
        //           width: double.infinity,
        //           child: Center(
        //             child: kTextbody('Quality',
        //                 color: Colors.white,),
        //           ),
        //         ),
        //       ),
        //       buildSpace(),
        //       Expanded(
        //         flex: 2,
        //         child: kTextbody('Cal.', color: Colors.white,),
        //       ),
        //       buildSpace(),
        //     ],
        //   ),
        // ),
        Container(
          child: Column(
            children: [
           ...List.generate(usualProteins.items!.length, (index) => Container(
             padding: EdgeInsets.symmetric(vertical:2),
             height: 40,

             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 Expanded(
                   flex: 5,
                   child: Padding(
                     padding:  EdgeInsets.symmetric(horizontal:AppSize.s8),
                     child: Container(
                       padding: EdgeInsets.all(AppSize.s4),
                       alignment: Alignment.center,
                       decoration: BoxDecoration(
                           border: Border.all(color: AppColors.black,),
                           borderRadius: BorderRadius.circular(AppSize.s8)
                       ),
                     child:kTextbody("${usualProteins.items?[index].qty} ${usualProteins.items?[index].food?.unit}"),
                   ),),
                 ),
                 Expanded(
                   flex: 9,
                   child: Padding(
                     padding:  EdgeInsets.symmetric(horizontal:AppSize.s8),
                     child: Container(
                       decoration: BoxDecoration(
                           border: Border.all(color: AppColors.black,),
                           borderRadius: BorderRadius.circular(AppSize.s8)
                       ),
                     alignment: Alignment.center,
                     width: double.infinity,
                     child: FittedBox(
                       child: kTextbody(
                         "${usualProteins.items?[index].food?.title}",
                         color: Colors.black,
                         bold: false,
                       ),
                     ),
                   ),),
                 ),
                 Expanded(
                   flex: 5,
                   child: Padding(
                     padding:  EdgeInsets.symmetric(horizontal:AppSize.s8),
                     child: Container(
                       decoration: BoxDecoration(
                           border: Border.all(color: AppColors.black,),
                           borderRadius: BorderRadius.circular(AppSize.s8)
                       ),
                     child: FittedBox(
                       fit: BoxFit.scaleDown,
                       child: kTextbody(
                         usualProteins.items?[index].calories!=null?(usualProteins.items?[index].calories).toStringAsFixed(2):'0',
                         color: Colors.black,
                       ),
                     ),
                   ),),
                 ),
               ],
             ),
           )) ,
            ],
          ),
        )
      ],
    );
  }

  Container buildSpace({Color? color}) => Container(width: 1, height: 50, color:color?? Color(0xffE1E1E3));
}
