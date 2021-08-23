import 'package:app/app/models/day_details_reposne.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/widgets/custom_bottom_sheet.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AddNewFood extends StatefulWidget {
  final List<Food>? list;

  const AddNewFood({Key? key, this.list}) : super(key: key);

  @override
  _AddNewFoodState createState() => _AddNewFoodState();
}

class _AddNewFoodState extends State<AddNewFood> {
  String food = "Choose Food";
  bool ShowLoader = false;
  int? foodId;
  int? quantity = 0 ;
  GlobalKey<FormState> key = GlobalKey();

  String? unit = " ";

  int? calories = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: key,
        child: Stack(
          children: [
            ListView(
              children: [
                HomeAppbar(
                  type: null,
                ),
                InkWell(
                  onTap: () {
                    CustomSheet(
                        context: context,
                        widget: ListView.builder(
                            itemCount: widget.list!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    food = widget.list![index].title!;
                                    foodId = widget.list![index].id!;
                                    unit = widget.list![index].unit;
                                    calories = widget.list![index].caloriePerUnit;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                      child: Text(
                                        "${widget.list![index].title}",
                                        style: TextStyle(
                                            color: Color(
                                                int.parse("0xFF${widget.list![index].color}")),
                                            fontSize: 17),
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
                              "${food}",
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: EditText(
                    value: '',
                    hint: 'Enter Quantity',
                    suffixData: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
                      child: Column(
                        children: [
                          Text("${unit}"),
                          Text("${calories} Calories"),
                        ],
                      ),
                    ),
                    radius: 12,
                    type: TextInputType.phone,
                    updateFunc: (text) {
                      setState(() {
                        quantity = int.parse(text);
                      });
                      print(quantity);
                    },
                    validateFunc: (text) {
                      if (text.toString().isEmpty) {
                        return "Enter Quantity";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.
                    symmetric(horizontal: 16 ,vertical: 16),
                  child: Text("Total Calories : ${quantity!*calories!} Calories" , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold), ),
                ),
                kButtonDefault(
                  '  Save  ',
                  marginH: MediaQuery.of(context).size.width / 4.5,
                  paddingV: 0,
                  func: () {
                    if (!key.currentState!.validate()) {
                      print("Ererer");
                      return;
                    } else {
                      updateProtineData(foodId, quantity);
                      print("Done");
                    }
                  },
                  shadow: true,
                  paddingH: 30,
                ),
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
      ),
    );
  }

  void updateProtineData(int? food, int? quantity) async {
    setState(() {
      ShowLoader = true;
    });
    await ApiProvider().updateDiaryData(foodProtine: food, qtyProtiene: quantity).then((value) {
      if (value.success == true) {
        setState(() {
          ShowLoader = false;
        });
        Get.offAllNamed(Routes.HOME);

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
}
