
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/models/my_other_calories_response.dart';
import '../../core/models/other_calories_units_repose.dart';
import '../../core/services/api_provider.dart';
import '../../core/view/widgets/custom_bottom_sheet.dart';
import '../../core/view/widgets/default/app_buttons.dart';
import '../../core/view/widgets/default/edit_text.dart';
import '../home/view/widgets/home_appbar.dart';


class AddNewCalorie extends StatefulWidget {
  final int type;

  const AddNewCalorie({Key? key, required this.type}) : super(key: key);

  @override
  _AddNewCalorieState createState() => _AddNewCalorieState();
}

class _AddNewCalorieState extends State<AddNewCalorie> {
  bool isLoading = true;
  GlobalKey<FormState> key = GlobalKey();
  MyOtherCaloriesUnitsResponse otherCaloriesResponse =
      MyOtherCaloriesUnitsResponse();
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

    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
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
          Navigator.of(context).pop();
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
    }else{
      await ApiProvider()
          .addOtherCalories(
          title: title,
          calPerUnti: calorie_per_unit,
          unit: unitID,
          unitQuantity: unit_qty,
          unitName: unit_name,
          type: widget.type);


      Fluttertoast.showToast(msg: "Saved successfully");
      Navigator.of(context).pop(Proteins(title: title,qty: unit_name,calories: calorie_per_unit,calorie_per_unit: unitID));
    }
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
                type: TextInputType.numberWithOptions(decimal: true),
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
                            padding: EdgeInsets.only(top: 16),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  unitName =
                                      otherCaloriesResponse.data![index].title!;
                                  unit_name =
                                      otherCaloriesResponse.data![index].title!;
                                  unitID =
                                      otherCaloriesResponse.data![index].id!;
                                });
                                Navigator.pop(context);
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                      "${otherCaloriesResponse.data![index].title!.toUpperCase()}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
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
                      type: TextInputType.phone,
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
              loading: showLoader,
              marginH: MediaQuery.of(context).size.width / 4.5,
              paddingV: 0,
              func: () {
                if (!key.currentState!.validate()) {
                  print("Ererer");
                  return;
                } else {
                if(showLoader==false)  addItem();
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
