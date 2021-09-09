import 'package:app/app/models/other_calories_units_repose.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/my_other_calories/my_other_calories.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/widgets/custom_bottom_sheet.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddNewCalorie extends StatefulWidget {
  final int type;

  const AddNewCalorie({Key? key, required this.type}) : super(key: key);

  @override
  _AddNewCalorieState createState() => _AddNewCalorieState();
}

class _AddNewCalorieState extends State<AddNewCalorie> {
  bool isLoading = true;
  GlobalKey<FormState> key = GlobalKey();
  MyOtherCaloriesUnitsResponse otherCaloriesResponse = MyOtherCaloriesUnitsResponse();
  String? title;
  String? calorie_per_unit;
  String unitName = "Choose Unit";
  int unitID = 1000000002130;
  String? unit_qty;
  String? unit_name;
  bool showLoader = false;

  void getUnits() async {
    await ApiProvider().getOtherCaloriesUnit().then((value) {
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


  void addItem() async {
    setState(() {
      showLoader = true;
    });

    await ApiProvider()
        .addOtherCalories(
            title: title,
            calPerUnti: calorie_per_unit,
            unit: unitID,
            unitQuantity: unit_qty,
            unitName: unit_name,
            type: widget.type)
        .then((value) {
      if (value.success == true) {
        setState(() {
          showLoader = false;
        });
        Fluttertoast.showToast(msg: "${value.message}");
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyOtherCalories()));
        print("OK");
      } else {
        setState(() {
          showLoader = false;
        });

        print("error");
        Fluttertoast.showToast(msg: "${value.message}");
        print("error");
      }
    });
  }

  @override
  void initState() {
    getUnits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: key,
        child: ListView(
          children: [
            HomeAppbar(
              type: null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: EditText(
                value: '',
                hint: 'Title',
                radius: 12,
                type: TextInputType.emailAddress,
                updateFunc: (text) {
                  setState(() {
                    title = text;
                  });
                  print(title);
                },
                validateFunc: (text) {
                  if (text.toString().isEmpty) {
                    return "Enter Title";
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: EditText(
                value: '',
                hint: 'Calories Per Unit',
                radius: 12,
                type: TextInputType.emailAddress,
                updateFunc: (text) {
                  setState(() {
                    calorie_per_unit = text;
                  });
                  print(calorie_per_unit);
                },
                validateFunc: (text) {
                  if (text.toString().isEmpty) {
                    return "Enter Calories Per Unit";
                  }
                },
              ),
            ),
            InkWell(
              onTap: () {
                CustomSheet(
                    context: context,
                    widget: ListView.builder(
                        itemCount: otherCaloriesResponse.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  unitName = otherCaloriesResponse.data![index].title!;
                                  unit_name = otherCaloriesResponse.data![index].title!;
                                  unitID = otherCaloriesResponse.data![index].id!;
                                });
                                Navigator.pop(context);
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Text(
                                      "${otherCaloriesResponse.data![index].title}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Divider()
                                ],
                              ),
                            ),
                          );
                        }));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: EditText(
                  value: '',
                  hint: unitName,
                  radius: 12,
                  enable: false,
                  type: TextInputType.emailAddress,
                  updateFunc: (text) {},
                  validateFunc: (text) {},
                ),
              ),
            ),
            unitID != 0
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: EditText(
                      value: '',
                      hint: 'Unit Quantity',
                      radius: 12,
                      type: TextInputType.emailAddress,
                      updateFunc: (text) {
                        setState(() {
                          unit_qty = text;
                        });
                        print(unit_qty);
                      },
                      validateFunc: (text) {
                        if (text.toString().isEmpty) {
                          return "Enter Title";
                        }
                      },
                    ),
                  ),
            unitID != 0
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: EditText(
                      value: '',
                      hint: 'Unit Name',
                      radius: 12,
                      type: TextInputType.emailAddress,
                      updateFunc: (text) {
                        setState(() {
                          unit_name = text;
                        });
                        print(unit_name);
                      },
                      validateFunc: (text) {
                        if (text.toString().isEmpty) {
                          return "Enter Unit Name";
                        }
                      },
                    ),
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
                  addItem();
                  print("Done");
                }
              },
              shadow: true,
              paddingH: 30,
            ),
          ],
        ),
      ),
    );
  }
}
