import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/navigation/navigation.dart';
import '../../../../core/enums/http_request_state.dart';
import '../../../../core/models/general_response.dart';
import '../../../../core/resources/resources.dart';
import '../../../../core/services/api_provider.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/utils/const_strings.dart';
import '../../../../core/view/views.dart';
import '../../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../../core/view/widgets/default/app_buttons.dart';
import '../../../../core/view/widgets/default/edit_text.dart';
import '../../../../core/view/widgets/default/password_edit_text.dart';
import '../../../../core/view/widgets/default/text.dart';
import '../../cubit/auth_cubit/auth_cubit.dart';
import '../../models/requests/registration_body.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final AuthCubit authCubit;
  late String id;
  late String password;
  late String name;
  late String lastName;
  late String email;
  String date = " Select Date";
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
        firstDate: DateTime(1950, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        date = picked.toString().substring(0, 10);
        date = '${picked.day}-${picked.month}-${picked.year}';
      });
  }

  void SendData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      showLoader = true;
    });
    await ApiProvider()
        .signUpApi(id, password, name, lastName, email, date, phone, gender,
        password_confirmation)
        .then((value) async {
      if (value.success == true) {
        setState(() {
          loginResponse = value;
          showLoader = false;
        });
        Fluttertoast.showToast(msg: "${value.message}");

        NavigationService.pushReplacementAll(context, Routes.authScreen);

        // SharedHelper _shared = SharedHelper();
        // await _shared.writeData(CachingKey.TOKEN, loginResponse.data!.accessToken);
        // await _shared.writeData(CachingKey.USER_NAME, loginResponse.data!.name);
        // await _shared.writeData(CachingKey.EMAIL, loginResponse.data!.email);
        // await _shared.writeData(CachingKey.USER_ID, loginResponse.data!.id);
        // await _shared.writeData(CachingKey.MOBILE_NUMBER, loginResponse.data!.phone);
        // await _shared.writeData(CachingKey.AVATAR, loginResponse.data!.image);
        // await _shared.writeData(CachingKey.IS_LOGGED, true);
      } else {
        Echo(value.message.toString());
        setState(() {
          loginResponse = value;
          showLoader = false;
        });
        Fluttertoast.showToast(msg: "${value.message}");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authCubit = BlocProvider.of<AuthCubit>(context);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SafeArea(
          child: Scaffold(
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Form(
                      key: key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 27 * kPixelFactor),
                          Image.asset(AppImages.kLogoRow, height: 54 * kPixelFactor),
                          SizedBox(height: 27 * kPixelFactor),
                          Container(
                            height: 50,
                            width: double.infinity,
                            color: AppColors.ACCENT_COLOR,
                            child: Center(
                              child: Text(
                                'Sign Up',
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
                                    if (text.toString().isEmpty) {
                                      return "Enter Valid Id";
                                    }
                                  },
                                  type: TextInputType.name,
                                ),
                                SizedBox(height: 12),
                                //User name
                                kTextbody('First name', size: 18),
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
                                    if (text.toString().isEmpty ||
                                        text.toString().length < 3) {
                                      return "Enter Valid Name";
                                    }
                                  },
                                  type: TextInputType.text,
                                ),
                                SizedBox(height: 12),
                                //last name
                                kTextbody('Last name', size: 18),
                                EditText(
                                  value: '',
                                  hint: '',
                                  updateFunc: (text) {
                                    setState(() {
                                      lastName = text;
                                    });
                                    print(text);
                                  },
                                  validateFunc: (text) {
                                    if (text.toString().isEmpty ||
                                        text.toString().length < 3) {
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
                                    if (text.toString().isEmpty ||
                                        !text.toString().contains("@")) {
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
                                    if (text.toString().isEmpty ||
                                        text.toString().length < 10) {
                                      return "Enter Valid Mobile Number";
                                    }
                                  },
                                  type: TextInputType.phone,
                                ),
                                SizedBox(height: 12),
                                //Birth date
                                kTextbody('Birth date', size: 18),
                                InkWell(
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  child: EditText(
                                    value: "",
                                    suffixIconData: Icons.date_range,
                                    hint: '${date}',
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
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          gender = "Female";
                                        });
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 3,
                                        decoration: BoxDecoration(
                                          border:
                                          Border.all(color: Colors.grey, width: 1),
                                          borderRadius: BorderRadius.circular(64),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              gender == "Female"
                                                  ? Icon(
                                                Icons.radio_button_checked,
                                                color: AppColors.PRIMART_COLOR,
                                              )
                                                  : Icon(
                                                Icons.radio_button_off,
                                                color: AppColors.PRIMART_COLOR,
                                              ),
                                              kTextbody('Female', size: 16),
                                              SizedBox(
                                                width: 16,
                                                height: 50,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 8,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          gender = "Male";
                                        });
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 3,
                                        decoration: BoxDecoration(
                                          border:
                                          Border.all(color: Colors.grey, width: 1),
                                          borderRadius: BorderRadius.circular(64),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              gender == "Male"
                                                  ? Icon(
                                                Icons.radio_button_checked,
                                                color: AppColors.PRIMART_COLOR,
                                              )
                                                  : Icon(
                                                Icons.radio_button_off,
                                                color: AppColors.PRIMART_COLOR,
                                              ),
                                              kTextbody('Male', size: 16),
                                              SizedBox(
                                                width: 16,
                                                height: 50,
                                              ),
                                            ],
                                          ),
                                        ),
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
                                      password = text;
                                    });
                                    print(text);
                                  },
                                  validateFunc: (text) {
                                    if (text.toString().isEmpty ||
                                        text.toString().length < 6) {
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
                                    if (text.toString().isEmpty ||
                                        text.toString().length < 6) {
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
                                          if (!key.currentState!.validate()) {
                                            return;
                                          } else {
                                            if (date == " Select Date") {
                                              Fluttertoast.showToast(
                                                  msg: "Please Enter Valid Date");
                                              return;
                                            }
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            key.currentState!.save();
                                            authCubit.register(id, password, name, lastName, email, date, phone, gender,
                                                password_confirmation);
                                          }
                                        },
                                        shadow: true,
                                        paddingH: 16,
                                      ),
                                      SizedBox(
                                          height:
                                          MediaQuery.of(context).size.width / 14),
                                      GestureDetector(
                                          onTap: () {
                                            NavigationService.push(context,Routes.loginScreen);
                                          },
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(bottom: 4),
                                                child: kTextHeader('Sign in',
                                                    color: AppColors.ACCENT_COLOR),
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
                                      SizedBox(
                                          height:
                                          MediaQuery.of(context).size.width / 14),
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

            BlocConsumer<AuthCubit, AuthState>(
              listenWhen: (prevState, state) => state.authRequestType == AuthRequestType.registration,
              listener: (context, state) {
                if (state.httpRequestState == HttpRequestState.failure) {
                  Alerts.showToast(state.failure!.message);
                }
                if (state.httpRequestState == HttpRequestState.success) {
                  Fluttertoast.showToast(msg: "${state.response?.message}");

                  NavigationService.pushReplacementAll(context, Routes.authScreen);
                }
              },
              buildWhen: (prevState, state) => state.authRequestType == AuthRequestType.registration,
              builder: (context, state) => state.httpRequestState != HttpRequestState.loading
                  ? SizedBox()
                      : Container(
                    child: Center(
                      child: CircularLoadingWidget(),
                    ),
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withOpacity(.9),
                  ))
                ],
              )),
        ));
  }
}
