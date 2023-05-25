import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../network_util/shared_helper.dart';
import '../../../routes/app_pages.dart';

class NonUserSubscribeView extends StatefulWidget {
  NonUserSubscribeView({this.isGuest, this.toCheer, this.toOrders, this.save, this.func});

  final bool? isGuest;
  final bool? toCheer;
  final bool? toOrders;
  final bool? save;
  final VoidCallback? func;

  @override
  _NonUserSubscribeViewState createState() => _NonUserSubscribeViewState();
}

class _NonUserSubscribeViewState extends State<NonUserSubscribeView> {
  late String email;
  late String name;
  late String lastName;
  late String phone;
  late String confirmPhone;
  GlobalKey<FormState> key = GlobalKey();

  @override
  void initState() {
    if (kDebugMode) {
      email = 'HossamNonUser@gmail.com';
      name = 'Hossam Non User';
      lastName = 'Hossam Non User';
      phone = '01113040518';
      confirmPhone = '01113040518';
    }
    super.initState();
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
                        if (widget.isGuest == null) PageLable(name: " Payment"),
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
                                  if (text.toString().isEmpty ||
                                      !text.toString().contains("@")) {
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
                                type: TextInputType.phone,
                                formatter: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
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
                              SizedBox(height: 12),
                              //name
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child:
                                    kTextbody('Confirm Phone Number', size: 18),
                              ),
                              EditText(
                                value: kDebugMode ? '01113040518' : '',
                                hint: '',
                                type: TextInputType.phone,
                                formatter: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                updateFunc: (text) {
                                  setState(() {
                                    confirmPhone = text;
                                  });
                                  print(text);
                                },
                                validateFunc: (text) {
                                  if (phone != confirmPhone) {
                                    return "Phone numbers are not the same";
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
                                                14),
                                    kButtonDefault(
                                      '  Submit  ',
                                      marginH:
                                          MediaQuery.of(context).size.width /
                                              4.5,
                                      paddingV: 0,
                                      func: () async {
                                        if (!key.currentState!.validate()) {
                                          return;
                                        } else if (widget.isGuest != null &&
                                            widget.isGuest == true) {
                                          await SharedHelper().writeData(CachingKey.PHONE, phone);
                                          await SharedHelper().writeData(CachingKey.IS_GUEST_SAVED, true);
                                          await SharedHelper().writeData(CachingKey.USER_LAST_NAME, lastName);
                                          await SharedHelper().writeData(CachingKey.EMAIL, email);
                                          await SharedHelper().writeData(CachingKey.USER_NAME, name);
                                          if (widget.toCheer == true) {
                                            Get.offNamed(Routes.MY_MEALS);
                                          } else if (widget.toOrders == true) {
                                            Get.offNamed(Routes.ORDERS);
                                          } else if(widget.save==true){
                                            Navigator.pop(context, true);
                                          }else {
                                            Get.toNamed(Routes.MY_PACKAGES);
                                           }
                                        } else {
                                          Navigator.pop(context, [
                                            name,
                                            lastName,
                                            email,
                                            phone,
                                            confirmPhone
                                          ]);
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
