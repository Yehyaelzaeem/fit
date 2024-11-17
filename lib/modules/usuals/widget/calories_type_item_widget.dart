import 'package:app/modules/usuals/widget/static_bar.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../../../core/models/usual_meals_reposne.dart';
import '../../../core/resources/resources.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../../core/view/widgets/spaces.dart';


class CaloriesTypeItemWidget extends StatelessWidget {
  const CaloriesTypeItemWidget({Key? key, required this.usualProteins,required this.caloriesTypeName, required this.icon, required this.mealCalories,}) : super(key: key);
final UsualProteins usualProteins;
  final String caloriesTypeName;
  final String mealCalories;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 2,
                spreadRadius: 2,
                offset: Offset(0, 0),
              ),
            ]
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ExpandableNotifier(
          initialExpanded:false,
          child: ScrollOnExpand(
            child: ExpandablePanel(
              theme:
              const ExpandableThemeData(
                headerAlignment:
                ExpandablePanelHeaderAlignment
                    .center,
                tapBodyToCollapse: false,
              ),
              header:  Row(
                children: [
                  Expanded(child:

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      icon,
                      HorizontalSpace(AppSize.s2),
                      kTextbody("${caloriesTypeName}", bold: true,align: TextAlign.start),
                    ],
                  )),
                  Expanded(child: kTextbody("(${"${usualProteins.calories!=null?usualProteins.calories.toStringAsFixed(2):0.0}"} Cal.)",align: TextAlign.end)),
                ],
              ),
              expanded: StaticBar(type: caloriesTypeName.toLowerCase(), usualProteins: usualProteins,),
              collapsed: const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}
