import 'dart:io';

import 'package:app/app/models/day_details_reposne.dart';
import 'package:app/app/modules/diary/add_new_food.dart';
import 'package:app/app/modules/diary/controllers/diary_controller.dart';
import 'package:app/app/modules/home/home_drawer.dart';
import 'package:app/app/modules/my_other_calories/my_other_calories.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/custom_bottom_sheet.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';

import '../../un_auth_view.dart';

class DiaryView extends StatefulWidget {
  const DiaryView({Key? key}) : super(key: key);

  @override
  _DiaryViewState createState() => _DiaryViewState();
}

class _DiaryViewState extends State<DiaryView> {
  GlobalKey<FormState> key = GlobalKey();
  bool isLoading = true;
  late String WorkOutData;
  DayDetailsResponse sessionResponse = DayDetailsResponse();
  late String qtyProtine, foodProtine;
  List<SingleImageItem> list = [];

  void getDiaryData() async {
    await ApiProvider().getDiaryView().then((value) {
      if (value.success == true) {
        setState(() {
          sessionResponse = value;
          isLoading = false;
          WorkOutData = "${sessionResponse.data!.workouts![0].title}";
        });
      } else {
        setState(() {
          sessionResponse = value;
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "${value.message}");
        print("error");
      }
    });
  }

  void deleteItem(int id) async {
    await ApiProvider().deleteCalorie("delete_calories_details", id).then((value) {
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

  bool ShowLoader = false;
  late int workOut;
  late String workDesc;

  void updateWaterData(String water) async {
    setState(() {
      ShowLoader = true;
    });
    await ApiProvider().updateDiaryData(water: water).then((value) {
      if (value.success == true) {
        setState(() {
          ShowLoader = false;
        });
        Fluttertoast.showToast(msg: "${value.message}");
      } else {
        Fluttertoast.showToast(msg: "${value.message}");
        print("error");
      }
    });
  }

  void updateWork() async {
    setState(() {
      ShowLoader = true;
    });
    await ApiProvider().updateDiaryData(workOut: workOut, workout_desc: workDesc).then((value) {
      if (value.success == true) {
        setState(() {
          ShowLoader = false;
        });
        Fluttertoast.showToast(msg: "${value.message}");
      } else {
        setState(() {
          ShowLoader = false;
        });
        Fluttertoast.showToast(msg: "Server Error");
        print("error");
      }
    });
  }

  void getFromCash() async {
    bool IsLogggd = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    if (IsLogggd != true) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => UnAuthView(),
          ),
          (Route<dynamic> route) => false);
    } else {
      getDiaryData();
    }
  }

  @override
  void initState() {
    list.add(SingleImageItem(id: 1, imagePath: 'assets/img/im_holder1.png', selected: false));
    list.add(SingleImageItem(id: 2, imagePath: 'assets/img/im_holder1.png', selected: false));
    list.add(SingleImageItem(id: 3, imagePath: 'assets/img/im_holder1.png', selected: false));
    list.add(SingleImageItem(id: 4, imagePath: 'assets/img/im_holder1.png', selected: false));
    list.add(SingleImageItem(id: 5, imagePath: 'assets/img/im_holder1.png', selected: false));
    list.add(SingleImageItem(id: 6, imagePath: 'assets/img/im_holder1.png', selected: false));
    getFromCash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                alignment: Alignment(0.01, -1.0),
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF414042),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Calories Calculator',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Image.asset('assets/img/ic_pdf.png'),
                          kTextHeader('PDF', color: Colors.white)
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        downloadFile(sessionResponse.data!.pdf!);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        margin: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: kColorPrimary,
                          borderRadius: BorderRadius.circular(64),
                        ),
                        child: Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if (isLoading == true)
                CircularLoadingWidget()
              else
                sessionResponse.data == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 148),
                        child: Center(
                          child: Text("${sessionResponse.message}"),
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(height: 24),
                          //* Date
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.keyboard_arrow_left,
                                color: kColorPrimary,
                                size: 28,
                              ),
                              kTextHeader('Tuesday, 15 Jun 2021',
                                  color: Colors.black, bold: true, size: 18),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: kColorPrimary,
                                size: 28,
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          // RatingBar.builder(
                          //   unratedColor: Colors.transparent.withOpacity(0.5),
                          //   initialRating: double.parse("${sessionResponse.data!.water}"),
                          //   itemCount: 6,
                          //   itemSize: 100,
                          //   itemPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          //   itemBuilder: (context, _) => Container(
                          //     width: 100,
                          //     height: 100,
                          //     decoration: BoxDecoration(
                          //         image: DecorationImage(
                          //       image: AssetImage("assets/img/im_holder1.png"),
                          //       fit: BoxFit.cover,
                          //     )),
                          //   ),
                          //   onRatingUpdate: (rating) {
                          //     print(rating);
                          //     updateWaterData(rating.toString());
                          //   },
                          // ),

                          Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 3,
                              padding: EdgeInsets.all(12.0),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: list.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                      onTap: () {
                                        for (int i = 0; i < list.length; i++) {
                                          setState(() {
                                            list[i].selected = false;
                                          });
                                        }
                                        for (int i = 0; i <= index; i++) {
                                          setState(() {
                                            list[i].selected = true;
                                          });
                                        }
                                        updateWaterData("${index + 1}");
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(list[index].imagePath),
                                                    fit: BoxFit.fitHeight)),
                                          ),
                                          list[index].selected == false
                                              ? SizedBox()
                                              : Padding(
                                                  padding: const EdgeInsets.all(8.2),
                                                  child: Container(
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.check_circle,
                                                        size: 50,
                                                        color: kColorPrimary,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: Colors.black.withOpacity(0.5)),
                                                  ),
                                                ),
                                        ],
                                      ));
                                },
                              )),

                          Container(
                            alignment: Alignment(0.01, -1.0),
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
                                              builder: (context) => AddNewFood(
                                                    list: sessionResponse.data!.proteins!.food,
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
                                            right: sessionResponse.data!.proteins!.caloriesTotal!
                                                .progress!.percentage!
                                                .toDouble(),
                                            child: Container(
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: Color(int.parse(
                                                    "0xFF${sessionResponse.data!.proteins!.caloriesTotal!.progress!.bg}")),
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
                                      '${sessionResponse.data!.proteins!.caloriesTotal!.taken} / ${sessionResponse.data!.proteins!.caloriesTotal!.imposed}',
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
                                      flex: 4,
                                      child: Container(
                                        height: 30,
                                        width: double.infinity,
                                        decoration:
                                            BoxDecoration(color: Colors.white, boxShadow: []),
                                        child:
                                            kTextbody('Quantity', color: Colors.black, bold: true),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 1.4,
                                      decoration: BoxDecoration(color: Colors.grey[700]),
                                    ),
                                    Flexible(
                                      flex: 4,
                                      child: Container(
                                        height: 30,
                                        width: double.infinity,
                                        decoration:
                                            BoxDecoration(color: Colors.white, boxShadow: []),
                                        child: kTextbody('Unit', color: Colors.black, bold: true),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 1.4,
                                      decoration: BoxDecoration(color: Colors.grey[700]),
                                    ),
                                    Flexible(
                                      flex: 4,
                                      child: Container(
                                        height: 30,
                                        width: double.infinity,
                                        decoration:
                                            BoxDecoration(color: Colors.white, boxShadow: []),
                                        child:
                                            kTextbody('Quality', color: Colors.black, bold: true),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 1.4,
                                      decoration: BoxDecoration(color: Colors.grey[700]),
                                    ),
                                    Flexible(
                                      flex: 4,
                                      child: Container(
                                        height: 30,
                                        width: double.infinity,
                                        decoration:
                                            BoxDecoration(color: Colors.white, boxShadow: []),
                                        child:
                                            kTextbody('Calories', color: Colors.black, bold: true),
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
                                        decoration:
                                            BoxDecoration(color: Colors.white, boxShadow: []),
                                        child: kTextbody('', color: Colors.black, bold: true),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                      sessionResponse.data!.proteins!.caloriesDetails!.length,
                                  itemBuilder: (context, indedx) {
                                    return rowItem(
                                        sessionResponse.data!.proteins!.caloriesDetails![indedx]);
                                  })
                            ],
                          ),
                          Container(
                            alignment: Alignment(0.01, -1.0),
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
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddNewFood(
                                                    list: sessionResponse.data!.carbsFats!.food,
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
                                            right: sessionResponse.data!.carbsFats!.caloriesTotal!
                                                .progress!.percentage!
                                                .toDouble(),
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
                                      '${sessionResponse.data!.carbsFats!.caloriesTotal!.taken} / ${sessionResponse.data!.carbsFats!.caloriesTotal!.imposed}',
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
                                      flex: 4,
                                      child: Container(
                                        height: 30,
                                        width: double.infinity,
                                        decoration:
                                            BoxDecoration(color: Colors.white, boxShadow: []),
                                        child:
                                            kTextbody('Quantity', color: Colors.black, bold: true),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 1.4,
                                      decoration: BoxDecoration(color: Colors.grey[700]),
                                    ),
                                    Flexible(
                                      flex: 4,
                                      child: Container(
                                        height: 30,
                                        width: double.infinity,
                                        decoration:
                                            BoxDecoration(color: Colors.white, boxShadow: []),
                                        child: kTextbody('Unit', color: Colors.black, bold: true),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 1.4,
                                      decoration: BoxDecoration(color: Colors.grey[700]),
                                    ),
                                    Flexible(
                                      flex: 4,
                                      child: Container(
                                        height: 30,
                                        width: double.infinity,
                                        decoration:
                                            BoxDecoration(color: Colors.white, boxShadow: []),
                                        child:
                                            kTextbody('Quality', color: Colors.black, bold: true),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 1.4,
                                      decoration: BoxDecoration(color: Colors.grey[700]),
                                    ),
                                    Flexible(
                                      flex: 4,
                                      child: Container(
                                        height: 30,
                                        width: double.infinity,
                                        decoration:
                                            BoxDecoration(color: Colors.white, boxShadow: []),
                                        child:
                                            kTextbody('Calories', color: Colors.black, bold: true),
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
                                        decoration:
                                            BoxDecoration(color: Colors.white, boxShadow: []),
                                        child: kTextbody('', color: Colors.black, bold: true),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                      sessionResponse.data!.carbsFats!.caloriesDetails!.length,
                                  itemBuilder: (context, indedx) {
                                    return rowItem(
                                        sessionResponse.data!.carbsFats!.caloriesDetails![indedx]);
                                  })
                            ],
                          ),
                          //
                          // kButtonDefault('Save',
                          //     marginH: MediaQuery.of(context).size.width / 5,
                          //     paddingV: 0,
                          //     shadow: true,
                          //     paddingH: 50),

                          SizedBox(height: 12),
                          Divider(),
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => MyOtherCalories()));
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Color(0xffF1F9E3),
                              ),
                              child: kButtonDefault('My other calories',
                                  marginH: MediaQuery.of(context).size.width / 6,
                                  paddingV: 0,
                                  shadow: true,
                                  paddingH: 12),
                            ),
                          ),
                          Divider(),
                          SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Workout Details",
                                  style:
                                      TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.upload_sharp,
                                  color: Colors.white,
                                )
                              ],
                            ),
                            height: 45,
                            margin: EdgeInsets.symmetric(
                              horizontal: 72,
                            ),
                            decoration: BoxDecoration(
                                color: kColorPrimary, borderRadius: BorderRadius.circular(50)),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.width / 14),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Text(
                                  "Workout",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              CustomSheet(
                                  context: context,
                                  widget: ListView.builder(
                                      itemCount: sessionResponse.data!.workouts!.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              WorkOutData =
                                                  sessionResponse.data!.workouts![index].title!;
                                              workOut = sessionResponse.data!.workouts![index].id!;
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 16),
                                                child: Text(
                                                  "${sessionResponse.data!.workouts![index].title}",
                                                  style:
                                                      TextStyle(color: kColorPrimary, fontSize: 15),
                                                ),
                                              ),
                                              Divider()
                                            ],
                                          ),
                                        );
                                      }));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${WorkOutData}",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      Icon(Icons.arrow_drop_down)
                                    ],
                                  ),
                                ),
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.black)),
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),

                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      kTextbody('Workout Description', size: 18, bold: true),
                                      EditText(
                                        radius: 12,
                                        lines: 5,
                                        value: '',
                                        hint: '',
                                        updateFunc: (text) {
                                          setState(() {
                                            workDesc = text;
                                          });
                                        },
                                        validateFunc: (text) {},
                                      ),
                                      SizedBox(height: 8),
                                      Center(
                                        child: kButtonDefault('Save',
                                            marginH: MediaQuery.of(context).size.width / 5,
                                            paddingV: 0, func: () {
                                          if (workDesc == null || workOut == null) {
                                            Fluttertoast.showToast(msg: "Please Complete Data");
                                          } else {
                                            updateWork();
                                          }
                                        }, shadow: true, paddingH: 50),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
            ],
          ),
          ShowLoader == false
              ? SizedBox()
              : Container(
                  child: Center(
                    child: CircularLoadingWidget(),
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(.9),
                )
        ],
      ),
    );
  }

  Widget rowItem(CaloriesDetails item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 4,
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
            flex: 4,
            child: Container(
              height: 30,
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xffE6E6E6)),
              child: kTextbody('${item.unit}', color: Colors.black, bold: true),
            ),
          ),
          Container(
            height: 30,
            width: 1.4,
            decoration: BoxDecoration(color: Colors.grey[700]),
          ),
          Flexible(
            flex: 4,
            child: Container(
              height: 30,
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xffE6E6E6)),
              child: kTextbody('${item.quality}', color: Colors.black, bold: true, size: 12),
            ),
          ),
          Container(
            height: 30,
            width: 1.4,
            decoration: BoxDecoration(color: Colors.grey[700]),
          ),
          Flexible(
            flex: 4,
            child: Container(
              height: 30,
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xffE6E6E6)),
              child: kTextbody('${item.id}', color: Colors.black, bold: true, size: 12),
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

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  void downloadFile(String file) async {
    print("Downloading File ====>${file}");
    if (file == "") {
      Fluttertoast.showToast(msg: "No File Exists To Download");
    } else {
      Dio dio = Dio();
      var tempDir = await getTemporaryDirectory();
      String fullPath = tempDir.path + "/File.pdf'";
      print('full path ${fullPath}');
      download2(dio, file, fullPath);
      Fluttertoast.showToast(msg: "File downloaded At ${fullPath} ");
    }
  }
}
