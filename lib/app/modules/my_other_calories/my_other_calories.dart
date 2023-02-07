import 'package:app/app/models/my_other_calories_response.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/home/views/home_view.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'add_new_other_calories.dart';
import 'edit_other_calory.dart';

class MyOtherCalories extends StatefulWidget {
  final bool canGoBack;

  const MyOtherCalories({this.canGoBack = false, Key? key}) : super(key: key);

  @override
  _MyOtherCaloriesState createState() => _MyOtherCaloriesState();
}

class _MyOtherCaloriesState extends State<MyOtherCalories> {
  bool isLoading = true;

  MyOtherCaloriesResponse otherCaloriesResponse = MyOtherCaloriesResponse();

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
    await ApiProvider()
        .deleteCalorie("delete_other_calories", id)
        .then((value) {
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
    return WillPopScope(
      onWillPop: () async {
        if (widget.canGoBack) {
          return true;
        } else {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (c) => HomeView()), (route) => false);
          return false;
        }
      },
      child: Scaffold(
        body: isLoading == true
            ? CircularLoadingWidget()
            : ListView(
                children: [
                  HomeAppbar(
                    type: null,
                    onBack: widget.canGoBack
                        ? null
                        : () {
                            Get.offAndToNamed(Routes.HOME);
                          },
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: PageLable(name: "My other calories"),
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
                          itemCount:
                              otherCaloriesResponse.data!.proteins!.length,
                          itemBuilder: (context, indedx) {
                            return rowItem(
                                otherCaloriesResponse.data!.proteins![indedx],
                                1);
                          }),
                  SizedBox(height: 20),
                  rowWithProgressBar("Carbs", 2),
                  staticBar(),
                  otherCaloriesResponse.data!.carbs!.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              children: [
                                SizedBox(height: 24),
                                Text("No Carbs Added Yet"),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: otherCaloriesResponse.data!.carbs!.length,
                          itemBuilder: (context, i) {
                            return rowItem(
                                otherCaloriesResponse.data!.carbs![i], 2);
                          }),
                  SizedBox(height: 20),
                  rowWithProgressBar("Fats", 3),
                  staticBar(),
                  otherCaloriesResponse.data!.fats!.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              children: [
                                SizedBox(height: 24),
                                Text("No Fats Added Yet"),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: otherCaloriesResponse.data!.fats!.length,
                          itemBuilder: (context, j) {
                            return rowItem(
                                otherCaloriesResponse.data!.fats![j], 3);
                          }),
                ],
              ),
      ),
    );
  }

  Widget rowItem(Proteins item, int type) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => EditNewCalorie(
                    type: type,
                    proteins: item,
                  ))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3.1,
                  child: Container(
                      padding: EdgeInsets.all(4),
                      child: Center(
                          child: kTextbody('${item.title}',
                              color: Colors.black, bold: false, size: 16))),
                ),
                Container(width: 2, color: Colors.grey, height: 25),
                Container(
                    width: MediaQuery.of(context).size.width / 4,
                    padding: EdgeInsets.all(4),
                    child: kTextbody('${item.qty}',
                        color: Colors.black, bold: false, size: 16)),
                Container(width: 2, color: Colors.grey, height: 25),
                Container(
                    width: MediaQuery.of(context).size.width / 4,
                    padding: EdgeInsets.all(4),
                    child: kTextbody('${item.calories}',
                        color: Colors.black, bold: false, size: 16)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    width: 2,
                    color: Colors.grey,
                    height: 25),
                InkWell(
                  onTap: () {
                    deleteItem(item.id!);
                  },
                  child: Icon(Icons.delete, color: Colors.redAccent, size: 24),
                ),
                SizedBox(width: 4),
              ],
            ),
          ),
          Divider(thickness: 2, color: Colors.grey),
        ],
      ),
    );
  }

  Widget rowWithProgressBar(String Title, int type) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: InkWell(
        onTap: () async {
          dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNewCalorie(type: type)));
          if (result == null) getDiaryData();
          setState(() {});
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
                  fontWeight: FontWeight.w800),
            ),
            Row(
              children: [
                SizedBox(width: 10),
                Icon(Icons.add_box, color: kColorPrimary, size: 30)
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3.1,
              child: Container(
                  padding: EdgeInsets.all(4),
                  child: Center(
                      child: kTextbody('Title',
                          color: Colors.white, bold: false, size: 16))),
            ),
            Container(width: 2, color: Color(0xFF414042), height: 25),
            Container(
                width: MediaQuery.of(context).size.width / 4,
                padding: EdgeInsets.all(4),
                child: kTextbody('Unit',
                    color: Colors.white, bold: false, size: 16)),
            Container(width: 2, color: Color(0xFF414042), height: 25),
            Container(
                width: MediaQuery.of(context).size.width / 4,
                padding: EdgeInsets.all(4),
                child: kTextbody('Calories',
                    color: Colors.white, bold: false, size: 16)),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              width: 2,
              color: Color(0xFF414042),
              height: 25,
            ),
            InkWell(
              onTap: () {
                // deleteItem(item.id!);
              },
              child: Icon(
                Icons.delete,
                color: Color(0xFF414042),
                size: 24,
              ),
            ),
            SizedBox(
              width: 4,
            ),
          ],
        ));
  }
}
