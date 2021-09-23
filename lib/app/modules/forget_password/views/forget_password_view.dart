import 'package:app/app/models/user_response.dart';
import 'package:app/app/modules/home/views/home_view.dart';
import 'package:app/app/modules/login/views/login_view.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/helper/const_strings.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late String pin;
  bool showLoader = false;

  GlobalKey<FormState> key = GlobalKey();
  UserResponse loginResponse = UserResponse();

  void sendData() async {
    setState(() {
      showLoader = true;
    });
    await ApiProvider().forgetPassword(pin).then((value) async {
      if (value.success == true) {
        setState(() {
          showLoader = false;
        });
        Fluttertoast.showToast(msg: "${value.message}");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginView(),
            ),
            (Route<dynamic> route) => false);
      } else {
        setState(() {
          showLoader = false;
        });
        print("error");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50 * kPixelFactor),
                  Image.asset(kLogoRow, height: 54 * kPixelFactor),
                  SizedBox(height: 27 * kPixelFactor),
                  Container(
                    height: 50,
                    width: double.infinity,
                    color: kColorAccent,
                    child: Center(
                      child: Text(
                        'Forget Password',
                        style: TextStyle(
                          fontSize: 27.0 * kTextPixelFactor,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        //id
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: kTextbody('Email', size: 18),
                        ),
                        EditText(
                          value: '',
                          hint: '',
                          updateFunc: (text) {
                            setState(() {
                              pin = text;
                            });
                            print(text);
                          },
                          validateFunc: (text) {
                            if (!text.toString().contains("@")) {
                              return "Enter Valid Email";
                            }
                          },
                          type: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 12),

                        //Forget password
                        SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.width / 14),
                              kButtonDefault(
                                '  SEND  ',
                                marginH: MediaQuery.of(context).size.width / 4.5,
                                paddingV: 0,
                                func: () {
                                  if (!key.currentState!.validate()) {
                                    print("Ererer");
                                    return;
                                  } else {
                                    sendData();
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
      ),
    );
  }
}
