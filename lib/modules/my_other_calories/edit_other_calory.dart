
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/models/my_other_calories_response.dart';
import '../../core/models/other_calories_units_repose.dart';
import '../../core/resources/app_colors.dart';
import '../../core/resources/app_values.dart';
import '../../core/services/api_provider.dart';
import '../../core/utils/alerts.dart';
import '../../core/view/widgets/custom_bottom_sheet.dart';
import '../../core/view/widgets/custom_text.dart';
import '../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../core/view/widgets/default/app_buttons.dart';
import '../../core/view/widgets/default/edit_text.dart';
import '../diary/cubits/diary_cubit.dart';
import '../home/view/widgets/home_appbar.dart';
import '../other_calories/cubits/other_calories_cubit.dart';
import 'my_other_calories.dart';

class EditNewCalorie extends StatefulWidget {
  final int type;
  final Proteins proteins;

  const EditNewCalorie({Key? key, required this.type, required this.proteins})
      : super(key: key);

  @override
  _EditNewCalorieState createState() => _EditNewCalorieState();
}

class _EditNewCalorieState extends State<EditNewCalorie> {
  bool isLoading = true;
  GlobalKey<FormState> key = GlobalKey();
  // MyOtherCaloriesUnitsResponse otherCaloriesResponse =
  //     MyOtherCaloriesUnitsResponse();
  String? title;
  String? calorie_per_unit;
  String unitName = "Choose Unit";
  int unitID = 1000000002130;
  String? unit_qty;
  String? unit_name;
  bool showLoader = false;


  void getUnits() async {
    await BlocProvider.of<DiaryCubit>(context).fetchOtherCaloriesUnits(changeState: true);
  }
  void addItem() async {
    // ignore: unnecessary_null_comparison
    if (unit_name == null) {
      Fluttertoast.showToast(msg: "Please Choose Unit");
    }
    setState(() => showLoader = true);

    await BlocProvider.of<OtherCaloriesCubit>(context)
        .updateOtherCalories(
            title: title,
            calPerUnit: calorie_per_unit,
            unit: unitID,
            unitQuantity: unit_qty,
            unitName: unit_name,
            type: widget.type,
            id: widget.proteins.id)
        .then((value) {
      setState(() {
        showLoader = false;
      });
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    title = widget.proteins.title;
    calorie_per_unit = "${widget.proteins.calories}";
    unitName = "${widget.proteins.qty}";

    unitID = 1000000002130;
    getUnits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(AppSize.s12),topLeft:Radius.circular(AppSize.s12) ),
        ),
        child: BlocConsumer<DiaryCubit, DiaryState>(
            listener: (context, state) {
              if (state is DiaryFailure) {
                Alerts.showSnackBar(context, state.failure.message,duration: Time.t2s*3);
              }

              if (state is DiaryLoaded) {
                Alerts.closeAllSnackBars(context);

              }
            },
            builder: (context, state) {
              if(state is DiaryLoading)
                return Container(
                    child: CircularLoadingWidget(), color: Colors.white);
              return Form(
          key: key,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16,horizontal: 12),
                child: CustomText(
                  'Edit other calories',
                  fontSize: AppSize.s16,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: EditText(
                  value: '${widget.proteins.title}',
                  hint: 'Title',
                  radius: 12,
                  type: TextInputType.emailAddress,
                  updateFunc: (text) => setState(() => title = text),
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
                  value: '${widget.proteins.calories}',
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
                          itemCount: BlocProvider.of<DiaryCubit>(context).myOtherCaloriesUnitsResponse.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    unitName =
                                    BlocProvider.of<DiaryCubit>(context).myOtherCaloriesUnitsResponse.data![index].title!;
                                    unit_name =
                                    BlocProvider.of<DiaryCubit>(context).myOtherCaloriesUnitsResponse.data![index].title!;
                                    unitID =
                                    BlocProvider.of<DiaryCubit>(context).myOtherCaloriesUnitsResponse.data![index].id!;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 4),
                                      child: Text(
                                        "${BlocProvider.of<DiaryCubit>(context).myOtherCaloriesUnitsResponse.data![index].title!.toUpperCase()}",
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
                        type: TextInputType.emailAddress,
                        updateFunc: (text) {
                          setState(() => unit_qty = text);
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
        );}),
      )
    );
  }
}
