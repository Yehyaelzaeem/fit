
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/models/general_response.dart';
import '../../../core/models/orintation_response.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/default/app_buttons.dart';
import '../../../core/view/widgets/default/edit_text.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../../core/view/widgets/page_lable.dart';
import '../../home/view/widgets/home_appbar.dart';

class OrientationRegisterView extends StatefulWidget {
  final int? id;

  const OrientationRegisterView({Key? key, this.id}) : super(key: key);

  @override
  _OrientationRegisterViewState createState() =>
      _OrientationRegisterViewState();
}

class _OrientationRegisterViewState extends State<OrientationRegisterView> {
  OrintationResponse ress = OrintationResponse();
  bool isLoading = true;
  GlobalKey<FormState> key = GlobalKey();
  String? first_name, middle_name, last_name, mobile, age, country, whats;
  int? hear_from, target, package;
  bool showLoader = false;
  TextEditingController Fnamecontroller = TextEditingController();
  TextEditingController Mnamecontroller = TextEditingController();
  TextEditingController Lnamecontroller = TextEditingController();
  TextEditingController Phonecontroller = TextEditingController();
  TextEditingController Agecontroller = TextEditingController();
  TextEditingController Countrycontroller = TextEditingController();
  TextEditingController Whatscontroller = TextEditingController();

  void getData() async {
    await ApiProvider().getOritationSelletionsData(widget.id!).then((value) {
      if (value.success == true) {
        setState(() {
          ress = value;
          isLoading = false;
        });
      } else {
        Fluttertoast.showToast(msg: "$value");
        print("error");
      }
    });
  }

  GeneralResponse sendResponse = GeneralResponse();

  void SendData() async {
    setState(() {
      showLoader = true;
    });
    await ApiProvider()
        .sendOrintaionData(
            id: widget.id,
            package: package,
            age: age,
            country: country,
            first_name: first_name,
            hear_from: hear_from,
            last_name: last_name,
            middle_name: middle_name,
            mobile: mobile,
            whats: whats,
            target: target)
        .then((value) {
      if (value.success == true) {
        setState(() {
          sendResponse = value;
          showLoader = false;
        });
        Fnamecontroller.clear();
        Mnamecontroller.clear();
        Lnamecontroller.clear();
        Phonecontroller.clear();
        Agecontroller.clear();
        Countrycontroller.clear();
        Fluttertoast.showToast(msg: "${value.message}");
        // Navigator.pop(context);
      } else {
        setState(() {
          sendResponse = value;
          showLoader = false;
        });
        Fluttertoast.showToast(msg: "${value.message}");
        print("error");
      }
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Form(
          key: key,
          child: ListView(
            children: [
              HomeAppbar(type: null),
              SizedBox(height: 12),
              Row(
                children: [
                  PageLable(name: "Orientation Registration"),
                ],
              ),
              SizedBox(height: 12),
              isLoading == true
                  ? CircularLoadingWidget()
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Container(
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: kTextHeader(ress.data!.intro!,
                                  size: 15, align: TextAlign.center)),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        EditText(
                          controller: Fnamecontroller,
                          value: '',
                          hint: 'First Name',
                          radius: 5,
                          // background: Color(0xffeeeeee),
                          updateFunc: (text) {
                            setState(() {
                              first_name = text;
                            });
                            print(text);
                          },
                          validateFunc: (text) {
                            if (text.toString().isEmpty) {
                              return "Enter Your First Name";
                            }
                          },
                          type: TextInputType.name,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        EditText(
                          controller: Mnamecontroller,
                          value: '',
                          hint: 'Middle Name',
                          radius: 5,
                          // background: Color(0xffeeeeee),
                          updateFunc: (text) {
                            setState(() {
                              middle_name = text;
                            });
                            print(text);
                          },
                          validateFunc: (text) {
                            if (text.toString().isEmpty) {
                              return "Enter Your Middle Name";
                            }
                          },
                          type: TextInputType.name,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        EditText(
                          controller: Lnamecontroller,
                          value: '',
                          hint: 'Last Name',
                          radius: 5,
                          // background: Color(0xffeeeeee),
                          updateFunc: (text) {
                            setState(() {
                              last_name = text;
                            });
                            print(text);
                          },
                          validateFunc: (text) {
                            if (text.toString().isEmpty) {
                              return "Enter Your Last Name";
                            }
                          },
                          type: TextInputType.name,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        EditText(
                          controller: Phonecontroller,
                          value: '',
                          hint: 'Mobile Number',
                          radius: 5,
                          // background: Color(0xffeeeeee),
                          updateFunc: (text) {
                            setState(() {
                              mobile = text;
                            });
                            print(text);
                          },
                          validateFunc: (text) {
                            if (text.toString().isEmpty ||
                                text.toString().length < 10) {
                              return "Enter Your Mobile Number At Least 10 Numbers";
                            }
                          },
                          type: TextInputType.phone,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        EditText(
                          controller: Whatscontroller,
                          value: '',
                          hint: 'WhatsApp Number (optional)',
                          radius: 5,
                          // background: Color(0xffeeeeee),
                          updateFunc: (text) {
                            setState(() {
                              whats = text;
                            });
                            print(text);
                          },
                          type: TextInputType.phone,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        EditText(
                          controller: Agecontroller,
                          value: '',
                          hint: 'Age ',
                          radius: 5,
                          // background: Color(0xffeeeeee),
                          updateFunc: (text) {
                            setState(() {
                              age = text;
                            });
                            print(text);
                          },
                          validateFunc: (text) {
                            if (text.toString().isEmpty) {
                              return "Enter Your Age";
                            }
                          },
                          type: TextInputType.number,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        EditText(
                          controller: Countrycontroller,
                          value: '',
                          hint: 'Where Do You Come From ?',
                          radius: 5,
                          // background: Color(0xffeeeeee),
                          updateFunc: (text) {
                            setState(() {
                              country = text;
                            });
                            print(text);
                          },
                          validateFunc: (text) {
                            if (text.toString().isEmpty) {
                              return "Enter Your Country";
                            }
                          },
                          type: TextInputType.name,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ress.data!.targets!.isEmpty
                            ? SizedBox()
                            : Row(
                                children: [
                                  PageLable(name: "What is your target?"),
                                ],
                              ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: ress.data!.targets!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  for (int i = 0;
                                      i < ress.data!.targets!.length;
                                      i++) {
                                    setState(() {
                                      ress.data!.targets![i].isSellected =
                                          false;
                                    });
                                  }
                                  setState(() {
                                    ress.data!.targets![index].isSellected =
                                        true;
                                    target = ress.data!.targets![index].id;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  width: double.infinity,
                                  color: Color(0xffeeeeee),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      ress.data!.targets![index].isSellected ==
                                              false
                                          ? Icon(
                                              Icons.radio_button_off,
                                              color: kColorPrimary,
                                            )
                                          : Icon(
                                              Icons.radio_button_checked,
                                              color: kColorPrimary,
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                            ress.data!.targets![index].title ??
                                                "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        ress.data!.hearingFrom!.isEmpty
                            ? SizedBox()
                            : Row(
                                children: [
                                  PageLable(name: "How did you hear about us?"),
                                ],
                              ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: ress.data!.hearingFrom!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  for (int i = 0;
                                      i < ress.data!.hearingFrom!.length;
                                      i++) {
                                    setState(() {
                                      ress.data!.hearingFrom![i].isSellected =
                                          false;
                                    });
                                  }
                                  setState(() {
                                    ress.data!.hearingFrom![index].isSellected =
                                        true;
                                    hear_from =
                                        ress.data!.hearingFrom![index].id;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  width: double.infinity,
                                  color: Color(0xffeeeeee),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      ress.data!.hearingFrom![index]
                                                  .isSellected ==
                                              false
                                          ? Icon(
                                              Icons.radio_button_off,
                                              color: kColorPrimary,
                                            )
                                          : Icon(
                                              Icons.radio_button_checked,
                                              color: kColorPrimary,
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                            ress.data!.hearingFrom![index]
                                                    .title ??
                                                "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        ress.data!.packages!.isEmpty
                            ? SizedBox()
                            : Row(
                                children: [
                                  PageLable(name: "Choose package?"),
                                ],
                              ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: ress.data!.packages!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  for (int i = 0;
                                      i < ress.data!.packages!.length;
                                      i++) {
                                    setState(() {
                                      ress.data!.packages![i].isSellected =
                                          false;
                                    });
                                  }
                                  setState(() {
                                    ress.data!.packages![index].isSellected =
                                        true;
                                    package = ress.data!.packages![index].id;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  width: double.infinity,
                                  color: Color(0xffeeeeee),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      ress.data!.packages![index].isSellected ==
                                              false
                                          ? Icon(
                                              Icons.radio_button_off,
                                              color: kColorPrimary,
                                            )
                                          : Icon(
                                              Icons.radio_button_checked,
                                              color: kColorPrimary,
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                            ress.data!.packages![index].title ??
                                                "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: kButtonDefault(
                              'Done',
                              paddingV: 20,
                              paddingH: 40,
                              marginH: MediaQuery.of(context).size.width / 10,
                              func: () {
                                if (!key.currentState!.validate()) {
                                  return;
                                } else {
                                  SendData();
                                }
                              },
                              shadow: true,
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
        showLoader == false
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
    ));
  }
}
