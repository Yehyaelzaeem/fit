import 'dart:io';

import 'package:flutter/material.dart';

import '../../../utils/theme/app_colors.dart';
import '../../../widgets/default/text.dart';
import '../../diary/views/diary_view.dart';

class StaticBar extends StatelessWidget {
  const StaticBar({Key? key, required this.type}) : super(key: key);
final String type;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          color: Color(0xFF414042),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSpace(),
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  child: Center(
                    child: kTextbody('Quantity',
                        color: Colors.white,),
                  ),
                ),
              ),
              buildSpace(),
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  child: Center(
                    child: kTextbody('Quality',
                        color: Colors.white,),
                  ),
                ),
              ),
              buildSpace(),
              Expanded(
                flex: 2,
                child: kTextbody('Cal.', color: Colors.white,),
              ),
              buildSpace(),
            ],
          ),
        ),
        Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildSpace(),
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: kColorPrimary)
                      ),
                      child:kTextbody("6 gms"),
                    ),
                  ),
                  buildSpace(color: Colors.white),
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: double.infinity,
                      child: kTextbody(
                        'Meal Data',
                        color: Colors.black,
                        bold: false,
                        size: 16,
                      ),
                    ),
                  ),
                  buildSpace(color: Colors.white),
                  Expanded(
                    flex: 2,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: kTextbody(
                       '99',
                        color: Colors.black,
                        size: 16,
                      ),
                    ),
                  ),
                  buildSpace(),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Container buildSpace({Color? color}) => Container(width: 1, height: 50, color:color?? Color(0xffE1E1E3));
}
