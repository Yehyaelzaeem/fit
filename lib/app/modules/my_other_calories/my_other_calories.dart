import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/material.dart';

class MyOtherCalories extends StatefulWidget {
  const MyOtherCalories({Key? key}) : super(key: key);

  @override
  _MyOtherCaloriesState createState() => _MyOtherCaloriesState();
}

class _MyOtherCaloriesState extends State<MyOtherCalories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 48),
            HomeAppbar(
              type: null,
            ),
            SizedBox(height: 12),
            PageLable(name: "My Other Calories"),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment(0.01, -1.0),
                          margin: EdgeInsets.symmetric(vertical: 10),
                          height: 50.0,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF414042),
                          ),
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 8),
                                Text(
                                  'Carbs & Fats',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Container(
                                    decoration: BoxDecoration(color: kColorPrimary),
                                    child: Icon(
                                      Icons.add,
                                      color: Color(0xFF414042),
                                    )),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(64),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          bottom: 0,
                                          left: 0,
                                          right: 100,
                                          child: Container(
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF0088FF),
                                              borderRadius: BorderRadius.circular(64),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6),
                                kTextHeader('89 / 350', color: Colors.white),
                                SizedBox(width: 6),
                              ],
                            ),
                          ),
                        ),
                        ListView.builder(
                            itemCount: 1,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                        offset: Offset(0, 0),
                                      ),
                                    ]),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Flexible(
                                          flex: 4,
                                          child: Container(
                                            height: 45,
                                            width: double.infinity,
                                            decoration:
                                                BoxDecoration(color: kColorAccent, boxShadow: []),
                                            child: Center(
                                              child: kTextbody('Quantity',
                                                  color: Colors.white, bold: true),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: Container(
                                            height: 45,
                                            width: double.infinity,
                                            decoration:
                                                BoxDecoration(color: kColorAccent, boxShadow: []),
                                            child: Center(
                                                child: kTextbody('Unit',
                                                    color: Colors.white, bold: true)),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: Container(
                                            height: 45,
                                            width: double.infinity,
                                            decoration:
                                                BoxDecoration(color: kColorAccent, boxShadow: []),
                                            child: Center(
                                                child: kTextbody('Quality',
                                                    color: Colors.white, bold: true)),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: Container(
                                            height: 45,
                                            width: double.infinity,
                                            decoration:
                                                BoxDecoration(color: kColorAccent, boxShadow: []),
                                            child: Center(
                                                child: kTextbody('Calories',
                                                    color: Colors.white, bold: true)),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 1.4,
                                          decoration: BoxDecoration(color: kColorAccent),
                                        ),
                                      ],
                                    ),
                                  ),
                                  rowItem(),
                                  rowItem(),
                                  rowItem(),
                                  rowItem(),
                                  rowItem(),
                                  rowItem(),
                                  rowItem(),
                                ],
                              );
                            })
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget rowItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 4,
            child: Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(color: kColorPrimary),
              child: Center(child: kTextbody('2', color: Colors.white, bold: true)),
            ),
          ),
          Flexible(
            flex: 4,
            child: Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(color: kColorPrimary),
              child: Center(child: kTextbody('Gm', color: Colors.white, bold: true)),
            ),
          ),
          Flexible(
            flex: 4,
            child: Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(color: kColorPrimary),
              child: Center(child: kTextbody('Chicken Liver', color: Colors.white, bold: true)),
            ),
          ),
          Flexible(
            flex: 4,
            child: Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(color: kColorPrimary),
              child: Center(child: kTextbody('253', color: Colors.white, bold: true)),
            ),
          ),
          // Flexible(
          //   flex: 1,
          //   child: Container(
          //     height: 30,
          //     width: double.infinity,
          //     decoration: BoxDecoration(color: kColorPrimary),
          //     child: Center(
          //       child: Icon(
          //         Icons.delete,
          //         color: Colors.redAccent,
          //         size: 24,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
