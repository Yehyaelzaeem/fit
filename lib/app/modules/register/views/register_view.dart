import 'package:app/app/models/general_response.dart';
import 'package:app/app/modules/login/views/login_view.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/helper/const_strings.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/password_edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late String id;
  late String password;
  late String name;
  late String email;
  late String date;
  late String phone;
  late String password_confirmation;
  String gender = "male";
  GlobalKey<FormState> key = GlobalKey();
  bool showLoader = false;
  GeneralResponse loginResponse = GeneralResponse();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        date = picked.toString().substring(0, 10);
      });
  }

  void SendData() async {
    setState(() {
      showLoader = true;
    });
    await ApiProvider()
        .signUpApi(id, password, name, email, date, phone, password_confirmation)
        .then((value) async {
      if (value.success == true) {
        setState(() {
          loginResponse = value;
          showLoader = false;
        });
        Fluttertoast.showToast(msg: "${value.message}");

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginView(),
            ),
            (Route<dynamic> route) => false);

        // SharedHelper _shared = SharedHelper();
        // await _shared.writeData(CachingKey.TOKEN, loginResponse.data!.accessToken);
        // await _shared.writeData(CachingKey.USER_NAME, loginResponse.data!.name);
        // await _shared.writeData(CachingKey.EMAIL, loginResponse.data!.email);
        // await _shared.writeData(CachingKey.USER_ID, loginResponse.data!.id);
        // await _shared.writeData(CachingKey.MOBILE_NUMBER, loginResponse.data!.phone);
        // await _shared.writeData(CachingKey.AVATAR, loginResponse.data!.image);
        // await _shared.writeData(CachingKey.IS_LOGGED, true);
      } else {
        setState(() {
          loginResponse = value;
          showLoader = false;
        });
        Fluttertoast.showToast(msg: "${value.message}");
        print("error");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 27 * kPixelFactor),
                Image.asset(kLogoRow, height: 54 * kPixelFactor),
                SizedBox(height: 27 * kPixelFactor),
                Container(
                  width: double.infinity,
                  color: kColorAccent,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
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
                      SizedBox(height: 18 * kPixelFactor),
                      //id
                      kTextbody('ID', size: 18),
                      EditText(
                        value: '',
                        hint: '',
                        updateFunc: (text) {
                          setState(() {
                            id = text;
                          });
                          print(text);
                        },
                        validateFunc: (text) {
                          if (text.toString().isEmpty || text.toString().length < 4) {
                            return "Enter Valid Id";
                          }
                        },
                        type: TextInputType.name,
                      ),
                      SizedBox(height: 12),
                      //User name
                      kTextbody('User name', size: 18),
                      EditText(
                        value: '',
                        hint: '',
                        updateFunc: (text) {
                          setState(() {
                            name = text;
                          });
                          print(text);
                        },
                        validateFunc: (text) {
                          if (text.toString().isEmpty || text.toString().length < 3) {
                            return "Enter Valid Name";
                          }
                        },
                        type: TextInputType.text,
                      ),
                      SizedBox(height: 12),

                      //User name
                      kTextbody('Email', size: 18),
                      EditText(
                        value: '',
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
                      //Mobile Number
                      kTextbody('Mobile Number', size: 18),
                      EditText(
                        value: '',
                        hint: '',
                        updateFunc: (text) {
                          setState(() {
                            phone = text;
                          });
                          print(text);
                        },
                        validateFunc: (text) {
                          if (text.toString().isEmpty || text.toString().length < 10) {
                            return "Enter Valid Mobile Number";
                          }
                        },
                        type: TextInputType.phone,
                      ),
                      SizedBox(height: 12),
                      //Birth date
                      kTextbody('Birth date', size: 18),
                      Container(
                        child: EditText(
                          value: "",
                          suffixIconData: Icons.date_range,
                          hint: '',
                          type: TextInputType.text,
                          enable: false,
                        ),
                      ),
                      SizedBox(height: 12),
                      //Gender
                      kTextbody('Gender', size: 18),
                      Row(
                        children: [
                          SizedBox(width: 4),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(64),
                            ),
                            child: Row(
                              children: [
                                Radio(
                                  value: '',
                                  groupValue: '1',
                                  onChanged: (value) {},
                                ),
                                kTextbody('Male', size: 16),
                                SizedBox(width: 16),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 8,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(64),
                            ),
                            child: Row(
                              children: [
                                Radio(
                                  value: '',
                                  groupValue: '1',
                                  onChanged: (value) {},
                                ),
                                kTextbody('Female', size: 16),
                                SizedBox(width: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      //Password
                      kTextbody('Password', size: 18),
                      EditTextPassword(
                        value: '',
                        hint: '',
                        updateFunc: (text) {
                          setState(() {
                            password_confirmation = text;
                          });
                          print(text);
                        },
                        validateFunc: (text) {
                          if (text.toString().isEmpty || text.toString().length < 6) {
                            return "Enter Valid Password";
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      kTextbody('Confirm password', size: 18),
                      EditTextPassword(
                        value: '',
                        hint: '',
                        updateFunc: (text) {
                          setState(() {
                            password_confirmation = text;
                          });
                          print(text);
                        },
                        validateFunc: (text) {
                          if (text.toString().isEmpty || text.toString().length < 6) {
                            return "Enter Valid Password";
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            kButtonDefault(
                              'Sign up',
                              marginH: MediaQuery.of(context).size.width / 4,
                              paddingV: 0,
                              func: () {
                                if (key.currentState!.validate()) {
                                  return;
                                } else {
                                  print("Done");
                                }
                              },
                              shadow: true,
                              paddingH: 16,
                            ),
                            SizedBox(height: MediaQuery.of(context).size.width / 14),
                            GestureDetector(
                                onTap: () {
                                  // Get.toNamed(Routes.LOGIN);
                                },
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: kTextHeader('Sign in', color: kColorAccent),
                                    ),
                                    Positioned(
                                        bottom: 8,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          width: double.infinity,
                                          height: 1,
                                          color: Colors.black87,
                                        ))
                                  ],
                                )),
                            SizedBox(height: MediaQuery.of(context).size.width / 14),
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
      ),
    ));
  }
}
