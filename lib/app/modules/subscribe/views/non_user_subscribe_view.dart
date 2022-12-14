import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NonUserSubscribeView extends StatefulWidget {

  NonUserSubscribeView();

  @override
  _NonUserSubscribeViewState createState() => _NonUserSubscribeViewState();
}

class _NonUserSubscribeViewState extends State<NonUserSubscribeView> {
  late String email;
  late String name;
  late String lastName;
  late String phone;
  GlobalKey<FormState> key = GlobalKey();

@override
  void initState() {
  if (kDebugMode) {
    email = 'HossamNonUser@gmail.com';
    name = 'Hossam Non User';
    lastName = 'Hossam Non User';
    phone = '01113040518';
  }    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorPrimary,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //App bar
                  HomeAppbar(),
                  Form(
                    key: key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 22),
                        PageLable(name: " Payment"),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
                              kTextHeader('Kindly enter your info first',
                                  color: kColorPrimary,
                                  bold: true,
                                  paddingH: 12,
                                  size: 20),
                              SizedBox(height: 28),

                              //name
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: kTextbody('First Name', size: 18),
                              ),
                              EditText(
                                value: kDebugMode ? 'Hossam Non User' : '',
                                hint: '',
                                updateFunc: (text) {
                                  setState(() {
                                    name = text;
                                  });
                                  print(text);
                                },
                                validateFunc: (text) {
                                  if (text.toString().isEmpty) {
                                    return "Enter Valid Name";
                                  }
                                },
                                type: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 12),

                              //last
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: kTextbody('Last Name', size: 18),
                              ),
                              EditText(
                                value: kDebugMode ? 'Last Hossam Non User' : '',
                                hint: '',
                                updateFunc: (text) {
                                  setState(() {
                                    lastName = text;
                                  });
                                  print(text);
                                },
                                validateFunc: (text) {
                                  if (text.toString().isEmpty) {
                                    return "Enter Valid Name";
                                  }
                                },
                                type: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 12),
                              //email
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: kTextbody('Email', size: 18),
                              ),
                              EditText(
                                value:
                                    kDebugMode ? 'HossamNonUser@gmail.com' : '',
                                hint: '',
                                updateFunc: (text) {
                                  setState(() {
                                    email = text;
                                  });
                                  print(text);
                                },
                                validateFunc: (text) {
                                  if (text.toString().isEmpty || !text.toString().contains("@")) {
                                    return "Enter Valid Email";
                                  }
                                },
                                type: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 12),
                              //name
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: kTextbody('Phone Number', size: 18),
                              ),
                              EditText(
                                value: kDebugMode ? '01113040518' : '',
                                hint: '',
                                updateFunc: (text) {
                                  setState(() {
                                    phone = text;
                                  });
                                  print(text);
                                },
                                validateFunc: (text) {
                                  if (text.toString().length < 11) {
                                    return "Enter Valid Phone Number";
                                  }
                                },
                              ),
                              SizedBox(height: 16),
                              SizedBox(height: 4),
                              Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width /
                                                14), kButtonDefault(
                                      '  Submit  ',
                                      marginH:
                                          MediaQuery.of(context).size.width /
                                              4.5,
                                      paddingV: 0,
                                      func: () {
                                        if (!key.currentState!.validate()) {
                                          return;
                                        } else {
                                          Navigator.pop(context,[name,lastName,email,phone]);
                                          print("Done");
                                        }
                                      },
                                      shadow: true,
                                      paddingH: 30,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            )),
      ),
    );
  }
}
