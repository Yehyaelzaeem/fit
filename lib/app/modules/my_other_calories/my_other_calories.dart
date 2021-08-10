import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/text.dart';
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
            Container(
              alignment: Alignment(0.01, -1.0),
              width: MediaQuery.of(context).size.width / 2.4,
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(15.0),
                ),
                color: const Color(0xFF414042),
              ),
              child: Center(
                child: Text(
                  'My Other Calories',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Text(
                                  "Proteins",
                                  style: TextStyle(
                                      color: kColorPrimary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Icon(
                                Icons.add_box_sharp,
                                color: kColorPrimary,
                              )
                            ],
                          ),
                          width: double.infinity,
                          height: 45,
                          color: Colors.grey[300],
                        ),
                        ListView.builder(
                            itemCount: 1,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Flexible(
                                          flex: 5,
                                          child: Container(
                                            height: 30,
                                            width: double.infinity,
                                            decoration: BoxDecoration(),
                                            child:
                                                kTextbody('Title', color: Colors.white, bold: true),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 1.4,
                                          decoration: BoxDecoration(color: Colors.grey[700]),
                                        ),
                                        Flexible(
                                          flex: 5,
                                          child: Container(
                                            height: 30,
                                            width: double.infinity,
                                            decoration: BoxDecoration(),
                                            child: kTextbody('Quantity',
                                                color: Colors.white, bold: true),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 1.4,
                                          decoration: BoxDecoration(color: Colors.grey[700]),
                                        ),
                                        Flexible(
                                          flex: 5,
                                          child: Container(
                                            height: 30,
                                            width: double.infinity,
                                            decoration: BoxDecoration(),
                                            child:
                                                kTextbody('Unit', color: Colors.white, bold: true),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 1.4,
                                          decoration: BoxDecoration(color: Colors.grey[700]),
                                        ),
                                        Flexible(
                                          flex: 5,
                                          child: Container(
                                            height: 30,
                                            width: double.infinity,
                                            decoration: BoxDecoration(),
                                            child: kTextbody('Calories',
                                                color: Colors.white, bold: true),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 1.4,
                                          decoration: BoxDecoration(color: Colors.grey[700]),
                                        ),
                                        Flexible(
                                          flex: 3,
                                          child: Container(
                                            width: double.infinity,
                                            decoration:
                                                BoxDecoration(color: Colors.black, boxShadow: []),
                                            child: kTextbody('', color: Colors.black, bold: true),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 24),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Flexible(
                                          flex: 5,
                                          child: Container(
                                            height: 30,
                                            width: double.infinity,
                                            decoration: BoxDecoration(color: Color(0xffE6E6E6)),
                                            child: kTextbody('Kitkat',
                                                color: Colors.black, bold: true),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 1.4,
                                          decoration: BoxDecoration(color: Colors.grey[700]),
                                        ),
                                        Flexible(
                                          flex: 5,
                                          child: Container(
                                            height: 30,
                                            width: double.infinity,
                                            decoration: BoxDecoration(color: Color(0xffE6E6E6)),
                                            child: kTextbody('2', color: Colors.black, bold: true),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 1.4,
                                          decoration: BoxDecoration(color: Colors.grey[700]),
                                        ),
                                        Flexible(
                                          flex: 5,
                                          child: Container(
                                            height: 30,
                                            width: double.infinity,
                                            decoration: BoxDecoration(color: Color(0xffE6E6E6)),
                                            child: kTextbody('GM', color: Colors.black, bold: true),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 1.4,
                                          decoration: BoxDecoration(color: Colors.grey[700]),
                                        ),
                                        Flexible(
                                          flex: 5,
                                          child: Container(
                                            height: 30,
                                            width: double.infinity,
                                            decoration: BoxDecoration(color: Color(0xffE6E6E6)),
                                            child:
                                                kTextbody('253', color: Colors.black, bold: true),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 1.4,
                                          decoration: BoxDecoration(color: Colors.grey[700]),
                                        ),
                                        Flexible(
                                          flex: 3,
                                          child: Container(
                                            height: 30,
                                            width: double.infinity,
                                            decoration: BoxDecoration(color: Color(0xffE6E6E6)),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.redAccent,
                                                  size: 24,
                                                ),
                                                Icon(
                                                  Icons.edit,
                                                  color: kColorPrimary,
                                                  size: 24,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
}
