import 'package:app/core/resources/app_assets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/navigation/navigation_services.dart';
import '../../../../config/navigation/routes.dart';
import '../../../../core/enums/http_request_state.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/utils/const_strings.dart';
import '../../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../../core/view/widgets/default/app_buttons.dart';
import '../../../../core/view/widgets/default/edit_text.dart';
import '../../../../core/view/widgets/default/password_edit_text.dart';
import '../../../../core/view/widgets/default/text.dart';
import '../../../../core/view/widgets/status_bar.dart';
import '../../../sessions/cubits/session_cubit.dart';
import '../../../timeSleep/cubits/time_sleep_cubit.dart';
import '../../cubit/auth_cubit/auth_cubit.dart';
import '../../models/requests/login_body.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthCubit authCubit;
  late String pin;
  late String password;
  bool showLoader = false;

  GlobalKey<FormState> key = GlobalKey();
  @override
  void initState() {
    super.initState();
    authCubit = BlocProvider.of<AuthCubit>(context);
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
                  Image.asset(AppImages.kLogoRow, height: 54 * kPixelFactor),
                  SizedBox(height: 27 * kPixelFactor),
                  Container(
                    height: 50,
                    width: double.infinity,
                    color: AppColors.ACCENT_COLOR,
                    child: Center(
                      child: Text(
                        'Sign In',
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
                          child: kTextbody('ID', size: 18),
                        ),
                        EditText(
                          value: kDebugMode ? 'p30000' : '',
                          hint: '',
                          updateFunc: (text) {
                            setState(() {
                              pin = text;
                            });
                            print(text);
                          },
                          validateFunc: (text) {
                            if (text.toString().isEmpty) {
                              return "Enter Valid Id";
                            }
                          },
                          type: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 12),
                        //Password
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: kTextbody('Password', size: 18),
                        ),
                        EditTextPassword(
                          value: kDebugMode ? '123123' : '',
                          hint: '',
                          updateFunc: (text) {
                            setState(() {
                              password = text;
                            });
                            print(text);
                          },
                          validateFunc: (text) {
                            if (text.toString().length < 6) {
                              return "Enter Valid Password";
                            }
                          },
                        ),
                        SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(height: 4),
                            InkWell(
                              onTap: () {
                                NavigationService.push(context, Routes.forgetPasswordScreen);
                              },
                              child: Text(
                                "Forgot Password?",
                                textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),

                        SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height:
                                  MediaQuery.of(context).size.width / 14),
                              kButtonDefault(
                                '  Sign in  ',
                                marginH:
                                MediaQuery.of(context).size.width / 4.5,
                                paddingV: 0,
                                func: () {
                                  if (!key.currentState!.validate()) {
                                    return;
                                  } else {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    key.currentState!.save();
                                    authCubit.login(pin,password,context);
                                  }
                                },
                                shadow: true,
                                paddingH: 30,
                              ),
                              SizedBox(height: 16),
                              // Row(
                              //   children: [
                              //     kTextbody('Remeber Me', size: 16),
                              //     Checkbox(
                              //       value: true,
                              //       activeColor: kColorPrimary,
                              //       onChanged: (value) {},
                              //     )
                              //   ],
                              // ),
                              InkWell(
                                onTap: () {
                                  NavigationService.push(context,Routes.signupScreen);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't Have Account ? ",
                                        style: TextStyle(
                                            decoration:
                                            TextDecoration.underline,
                                            fontSize: 17),
                                      ),
                                      Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            decoration:
                                            TextDecoration.underline,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
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
    BlocConsumer<AuthCubit, AuthState>(
    listenWhen: (prevState, state) => state.authRequestType == AuthRequestType.login,
    listener: (context, state) {
    if (state.httpRequestState == HttpRequestState.failure) {
    Alerts.showToast(state.failure!.message);
    }
    if (state.httpRequestState == HttpRequestState.success) {

    NavigationService.pushReplacementAll(context, Routes.homeScreen);

    }
    },
    buildWhen: (prevState, state) => state.authRequestType == AuthRequestType.login,
    builder: (context, state) => state.httpRequestState == HttpRequestState.loading
    ? Container(
    child: Center(
    child: CircularLoadingWidget(),
    ),
    width: double.infinity,
    height: double.infinity,
    color: Colors.black.withOpacity(.9),
    )
        :SizedBox()),

        ],
      ),
    );
  }
}
