import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../../../widgets/default/text.dart';

class CaloriesTypeItemWidget extends StatelessWidget {
  const CaloriesTypeItemWidget({Key? key, required this.caloriesTypeName}) : super(key: key);
final String caloriesTypeName;
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
              header:  kTextbody(caloriesTypeName, bold: true,align: TextAlign.start),
              expanded: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(4, (index) => kTextbody('${caloriesTypeName}s Data ${index+1}'),),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(4, (index) =>  kTextbody("100gm",),),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
              collapsed: const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}
