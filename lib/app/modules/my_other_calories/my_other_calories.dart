import 'package:app/app/models/my_other_calories_response.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'add_new_other_calories.dart';

class MyOtherCalories extends StatefulWidget {
  const MyOtherCalories({Key? key}) : super(key: key);

  @override
  _MyOtherCaloriesState createState() => _MyOtherCaloriesState();
}

class _MyOtherCaloriesState extends State<MyOtherCalories> {
  bool isLoading = true;

  MyOtherCaloriesResponse otherCaloriesResponse = MyOtherCaloriesResponse();
  late String qtyProtine, foodProtine;

  void getDiaryData() async {
    await ApiProvider().getOtherCaloreis().then((value) {
      if (value.success == true) {
        setState(() {
          otherCaloriesResponse = value;
          isLoading = false;
        });
      } else {
        setState(() {
          otherCaloriesResponse = value;
          isLoading = false;
        });
        // Fluttertoast.showToast(msg: "${value.message}");
        print("error");
      }
    });
  }

  void deleteItem(int id) async {
    await ApiProvider().deleteCalorie("delete_other_calories", id).then((value) {
      if (value.success == true) {
        setState(() {
          isLoading = false;
        });
        getDiaryData();
        Fluttertoast.showToast(msg: "${value.message}");
      } else {
        setState(() {
          isLoading = false;
        });
        print("error");
      }
    });
  }

  @override
  void initState() {
    getDiaryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? CircularLoadingWidget()
          : ListView(
        children: [
          HomeAppbar(
            type: null,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: PageLable(name: "My Other Calories"),
              ),
            ],
          ),
          Container(
            alignment: Alignment(0.01, -1.0),
            height: 50.0,
            width: MediaQuery
                .of(context)
                .size
                .width,
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
                    'Proteins',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddNewCalorie(
                                    type: 1,
                                  )));
                    },
                    child: Container(
                        decoration: BoxDecoration(color: kColorPrimary),
                        child: Icon(
                          Icons.add,
                          color: Color(0xFF414042),
                        )),
                  ),
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
                          // Positioned(
                          //   top: 0,
                          //   bottom: 0,
                          //   left: 0,
                          //   right: 0,
                          //   child: Container(
                          //     height: 10,
                          //     decoration: BoxDecoration(
                          //       color: Color(int.parse(
                          //           "0xFF${sessionResponse.data!.proteins!.caloriesTotal!.progress!.bg}")),
                          //       borderRadius: BorderRadius.circular(64),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  kTextHeader(
                    // '${sessionResponse.data!.proteins!.caloriesTotal!.taken} / ${sessionResponse.data!.proteins!.caloriesTotal!.imposed}',
                      "0",
                      color: Colors.white),
                  SizedBox(width: 6),
                ],
              ),
            ),
          ),
          //* table
          SizedBox(height: 24),
          Column(
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
                      flex: 3,
                      child: Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white, boxShadow: []),
                        child: kTextbody('Title', color: Colors.black, bold: true),
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
                        decoration: BoxDecoration(color: Colors.white, boxShadow: []),
                        child: kTextbody('Unit', color: Colors.black, bold: true),
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
                        decoration: BoxDecoration(color: Colors.white, boxShadow: []),
                        child: kTextbody('Calories', color: Colors.black, bold: true),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 1.4,
                      decoration: BoxDecoration(color: Colors.grey[700]),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white, boxShadow: []),
                        child: kTextbody('', color: Colors.black, bold: true),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: otherCaloriesResponse.data!.proteins!.length,
                  itemBuilder: (context, indedx) {
                    return rowItem(otherCaloriesResponse.data!.proteins![indedx]);
                  })
            ],
          ),
          SizedBox(height: 24),
          Container(
            alignment: Alignment(0.01, -1.0),
            height: 50.0,
            width: MediaQuery
                .of(context)
                .size
                .width,
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddNewCalorie(
                                    type: 2,
                                  )));
                    },
                    child: Container(
                        decoration: BoxDecoration(color: kColorPrimary),
                        child: Icon(
                          Icons.add,
                          color: Color(0xFF414042),
                        )),
                  ),
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
                            right: 0,
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
                  kTextHeader(
                    // '${sessionResponse.data!.carbsFats!.caloriesTotal!.taken} / ${sessionResponse.data!.carbsFats!.caloriesTotal!.imposed}',
                      "0",
                      color: Colors.white),
                  SizedBox(width: 6),
                ],
              ),
            ),
          ),
          //* table
          SizedBox(height: 24),
          Column(
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
                      flex: 3,
                      child: Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white, boxShadow: []),
                        child: kTextbody('Title', color: Colors.black, bold: true),
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
                        decoration: BoxDecoration(color: Colors.white, boxShadow: []),
                        child: kTextbody('Unit', color: Colors.black, bold: true),
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
                        decoration: BoxDecoration(color: Colors.white, boxShadow: []),
                        child: kTextbody('Calories', color: Colors.black, bold: true),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 1.4,
                      decoration: BoxDecoration(color: Colors.grey[700]),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white, boxShadow: []),
                        child: kTextbody('', color: Colors.black, bold: true),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: otherCaloriesResponse.data!.carbsFats!.length,
                  itemBuilder: (context, indedx) {
                    return rowItem(otherCaloriesResponse.data!.carbsFats![indedx]);
                  })
            ],
          ),
        ],
      ),
    );
  }

  Widget rowItem(Proteins item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 3,
            child: Container(
              height: 30,
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xffE6E6E6)),
              child: kTextbody('${item.title}', color: Colors.black, bold: true),
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
              child: kTextbody('${item.qty}', color: Colors.black, bold: true),
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
              child: kTextbody('${item.calories}', color: Colors.black, bold: true, size: 12),
            ),
          ),
          Container(
            height: 30,
            width: 1.4,
            decoration: BoxDecoration(color: Colors.grey[700]),
          ),
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {
                deleteItem(item.id!);
              },
              child: Container(
                height: 30,
                width: double.infinity,
                decoration: BoxDecoration(color: Color(0xffE6E6E6)),
                child: Center(
                  child: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                    size: 24,
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
