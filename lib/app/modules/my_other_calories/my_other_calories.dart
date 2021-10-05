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
                rowWithProgressBar("Proteins", 1),
                staticBar(),
                otherCaloriesResponse.data!.proteins!.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            children: [
                              SizedBox(height: 24),
                              Text("No Proteins Added Yet"),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: otherCaloriesResponse.data!.proteins!.length,
                        itemBuilder: (context, indedx) {
                          return rowItem(otherCaloriesResponse.data!.proteins![indedx]);
                        }),
                SizedBox(
                  height: 20,
                ),

                rowWithProgressBar("Carbs And Fats", 2), //*
                staticBar(),
                otherCaloriesResponse.data!.carbsFats!.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            children: [
                              SizedBox(height: 24),
                              Text("No Carbs Fats Added Yet"),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: otherCaloriesResponse.data!.carbsFats!.length,
                        itemBuilder: (context, indedx) {
                          return rowItem(otherCaloriesResponse.data!.carbsFats![indedx]);
                        })
              ],
            ),
    );
  }

  Widget rowItem(Proteins item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2.5,
                child: Container(
                    padding: EdgeInsets.all(4),
                    child: Center(
                        child: kTextbody('${item.title}',
                            color: Colors.black, bold: false, size: 16))),
              ),
              Container(
                width: 2,
                color: Colors.grey,
                height: 25,
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 5,
                  padding: EdgeInsets.all(4),
                  child: kTextbody('${item.qty}', color: Colors.black, bold: false, size: 16)),
              Container(
                width: 2,
                color: Colors.grey,
                height: 25,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 5,
                child: kTextbody('${item.calories}', color: Colors.black, bold: false, size: 16),
              ),
              Container(
                width: 2,
                color: Colors.grey,
                height: 25,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 10,
                child: InkWell(
                  onTap: () {
                    deleteItem(item.id!);
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 2,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget rowWithProgressBar(String Title, int type) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddNewCalorie(type: type)));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${Title}',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black87,
                fontWeight: FontWeight.w800,
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.add_box,
                  color: kColorPrimary,
                  size: 30,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget staticBar() {
    return Container(
      color: Color(0xFF414042),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2.5,
              child: Center(child: kTextbody('Title', color: Colors.white, bold: true, size: 16)),
            ),
            Container(
                width: MediaQuery.of(context).size.width / 5,
                child: Center(child: kTextbody('Unit', color: Colors.white, bold: true, size: 16))),
            Container(
                // color: Colors.red,
                width: MediaQuery.of(context).size.width / 5,
                child: Center(
                  child: kTextbody('Calories', color: Colors.white, bold: true, size: 16),
                )),
            SizedBox(
              width: MediaQuery.of(context).size.width / 9,
            ),
          ],
        ),
      ),
    );
  }
}
