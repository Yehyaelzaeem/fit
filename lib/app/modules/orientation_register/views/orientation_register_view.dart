import 'package:app/app/models/general_response.dart';
import 'package:app/app/models/orintation_response.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrientationRegisterView extends StatefulWidget {
  const OrientationRegisterView({Key? key}) : super(key: key);

  @override
  _OrientationRegisterViewState createState() => _OrientationRegisterViewState();
}

class _OrientationRegisterViewState extends State<OrientationRegisterView> {
  OrintationResponse ress = OrintationResponse();
  bool isLoading = true;
  GlobalKey<FormState> key = GlobalKey();
  String? first_name, middle_name, last_name, mobile, age, country;
  int? hear_from, target;
  bool showLoader = false;

  void getData() async {
    await ApiProvider().getOritationSelletionsData().then((value) {
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
            age: age,
            country: country,
            first_name: first_name,
            hear_from: hear_from,
            last_name: last_name,
            middle_name: middle_name,
            mobile: mobile,
            target: target)
        .then((value) {
      if (value.success == true) {
        setState(() {
          sendResponse = value;
          showLoader = false;
        });
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
        SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                HomeAppbar(type: null),
                SizedBox(height: 12),
                PageLable(name: "Orientation Registration"),
                SizedBox(height: 12),
                isLoading == true
                    ? CircularLoadingWidget()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.grey[300],
                            width: double.infinity,
                            child: kTextbody(
                              "${ress.data!.intro}",
                              align: TextAlign.center,
                              size: 15,
                              bold: true,
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
                                      //First name
                                      kTextbody('First Name', size: 18, bold: true),
                                      Container(
                                        color: Color(0xffeeeeee),
                                        margin: EdgeInsets.symmetric(horizontal: 8),
                                        child: Row(
                                          children: [
                                            //SizedBox(width: 20),
                                            // Container(height: 30, width: 1, color: Color(0xFF666565)),
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: EditText(
                                                value: '',
                                                hint: '',
                                                radius: 4,
                                                noBorder: true,
                                                background: Color(0xffeeeeee),
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
                                            ),
                                            SizedBox(width: 20),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      //Middle Name
                                      kTextbody('Middle Name', size: 18, bold: true),
                                      Container(
                                        color: Color(0xffeeeeee),
                                        margin: EdgeInsets.symmetric(horizontal: 8),
                                        child: Row(
                                          children: [
                                            //SizedBox(width: 20),
                                            // Container(height: 30, width: 1, color: Color(0xFF666565)),
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: EditText(
                                                value: '',
                                                hint: '',
                                                radius: 4,
                                                noBorder: true,
                                                background: Color(0xffeeeeee),
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
                                            ),
                                            SizedBox(width: 20),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      //Last name
                                      kTextbody('Last Name', size: 18, bold: true),
                                      Container(
                                        color: Color(0xffeeeeee),
                                        margin: EdgeInsets.symmetric(horizontal: 8),
                                        child: Row(
                                          children: [
                                            //SizedBox(width: 20),
                                            // Container(height: 30, width: 1, color: Color(0xFF666565)),
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: EditText(
                                                value: '',
                                                hint: '',
                                                radius: 4,
                                                noBorder: true,
                                                background: Color(0xffeeeeee),
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
                                            ),
                                            SizedBox(width: 20),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      //First name
                                      kTextbody('Mobile Number', size: 18, bold: true),
                                      Container(
                                        color: Color(0xffeeeeee),
                                        margin: EdgeInsets.symmetric(horizontal: 8),
                                        child: Row(
                                          children: [
                                            //SizedBox(width: 20),
                                            // Container(height: 30, width: 1, color: Color(0xFF666565)),
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: EditText(
                                                value: '',
                                                hint: '',
                                                radius: 4,
                                                noBorder: true,
                                                background: Color(0xffeeeeee),
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
                                            ),
                                            SizedBox(width: 20),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 8),
                                      //Age
                                      kTextbody('Age', size: 18, bold: true),
                                      Container(
                                        color: Color(0xffeeeeee),
                                        margin: EdgeInsets.symmetric(horizontal: 8),
                                        child: Row(
                                          children: [
                                            // SizedBox(width: 20),
                                            // Container(height: 30, width: 1, color: Color(0xFF666565)),
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: EditText(
                                                value: '',
                                                hint: '',
                                                contentPaddingH: 0,
                                                radius: 4,
                                                noBorder: true,
                                                background: Color(0xffeeeeee),
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
                                            ),
                                            SizedBox(width: 20),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 8),
                                      kTextbody('What is your target?', size: 18, bold: true),
                                    ],
                                  ),
                                ),

                                isLoading == true
                                    ? CircularLoadingWidget()
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: ress.data!.targets!.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              for (int i = 0; i < ress.data!.targets!.length; i++) {
                                                setState(() {
                                                  ress.data!.targets![i].isSellected = false;
                                                });
                                              }
                                              setState(() {
                                                ress.data!.targets![index].isSellected = true;
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
                                                  ress.data!.targets![index].isSellected == false
                                                      ? Icon(
                                                          Icons.radio_button_off,
                                                          color: kColorPrimary,
                                                        )
                                                      : Icon(
                                                          Icons.radio_button_checked,
                                                          color: kColorPrimary,
                                                        ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Text(
                                                      ress.data!.targets![index].title ?? "",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //Age
                                      SizedBox(height: 8),
                                      kTextbody('What is your country?', size: 18, bold: true),
                                      Container(
                                        color: Color(0xffeeeeee),
                                        margin: EdgeInsets.symmetric(horizontal: 8),
                                        child: Row(
                                          children: [
                                            //SizedBox(width: 20),
                                            // Container(height: 30, width: 1, color: Color(0xFF666565)),
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: EditText(
                                                value: '',
                                                hint: '',
                                                radius: 4,
                                                noBorder: true,
                                                background: Color(0xffeeeeee),
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
                                            ),
                                            SizedBox(width: 20),
                                          ],
                                        ),
                                      ),
                                      kTextbody('Where did you hear about us?',
                                          size: 18, bold: true),
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
                                                    ress.data!.hearingFrom![i].isSellected = false;
                                                  });
                                                }
                                                setState(() {
                                                  ress.data!.hearingFrom![index].isSellected = true;
                                                  hear_from = ress.data!.hearingFrom![index].id;
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
                                                    ress.data!.hearingFrom![index].isSellected ==
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
                                                          ress.data!.hearingFrom![index].title ??
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
                                    ],
                                  ),
                                ),

                                SizedBox(height: 6),
                                SizedBox(height: 4),

                                Center(
                                  child: kButtonDefault(
                                    'Done',
                                    paddingV: 0,
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
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
              ],
            ),
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
