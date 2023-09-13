import 'package:app/app/modules/usuals/widget/static_bar.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../../../widgets/default/text.dart';

class CaloriesTypeItemWidget extends StatelessWidget {
  const CaloriesTypeItemWidget({Key? key, required this.caloriesTypeName, required this.totalCalories}) : super(key: key);
final String caloriesTypeName;
final String totalCalories;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
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
                  Expanded(child: kTextbody(caloriesTypeName, bold: true,align: TextAlign.start)),
                  kTextbody("($totalCalories Cal.)",align: TextAlign.start),
                ],
              ),
              expanded: StaticBar(type: caloriesTypeName.toLowerCase(),),

              collapsed: const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}
