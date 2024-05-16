import 'package:app/app/models/user_response.dart';
import 'package:app/app/modules/diary/controllers/diary_controller.dart';
import 'package:app/app/modules/forget_password/views/forget_password_view.dart';
import 'package:app/app/modules/home/controllers/home_controller.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/helper/const_strings.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/password_edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late String pin;
  late String password;
  bool showLoader = false;

  GlobalKey<FormState> key = GlobalKey();
  UserResponse loginResponse = UserResponse();

  void sendData() async {
    setState(() {
      showLoader = true;
      if (kDebugMode) {
        pin = 'p30000';
        password = '123123';
      }
    });
    await ApiProvider().login(pin, password).then((value) async {
      if (value.success == true) {
        setState(() {
          loginResponse = value;
          showLoader = false;
        });
        SharedHelper _shared = SharedHelper();
        await _shared.writeData(
            CachingKey.TOKEN, loginResponse.data!.accessToken);
        await _shared.writeData(CachingKey.USER_NAME, loginResponse.data!.name);
        await _shared.writeData(
            CachingKey.USER_ID, loginResponse.data!.patientId);
        await _shared.writeData(CachingKey.EMAIL, loginResponse.data!.email);
        await _shared.writeData(CachingKey.PHONE, loginResponse.data!.phone);
        await _shared.writeData(
            CachingKey.MOBILE_NUMBER, loginResponse.data!.phone);
        await _shared.writeData(CachingKey.AVATAR, loginResponse.data!.image);
        await _shared.writeData(CachingKey.IS_LOGGED, true);
        await _shared.writeData(
            CachingKey.USER_LAST_NAME, loginResponse.data!.lastName);
        await _shared.writeData(CachingKey.IS_GUEST_SAVED, false);
        await _shared.writeData(CachingKey.IS_GUEST, false);
        bool isReggisterd = Get.isRegistered<DiaryController>(tag: 'diary');
        if (isReggisterd) {
          DiaryController controller = Get.find<DiaryController>(tag: 'diary');
          print("objectDairy");
          // await ApiProvider().getDiaryView(DateTime.now().toString().substring(0, 10));
          controller.onInit();

        }
        bool isReggisterd2 = Get.isRegistered<HomeController>(tag: 'diary');
        if (isReggisterd2) {
          HomeController textEditController =
              Get.find<HomeController>(tag: 'home');
          textEditController.refreshController(true);
          textEditController.isLogggd.value = true;

        }

        // bool isReggisterd = Get.isRegistered<HomeC>(tag: 'diary');
        // if (isReggisterd) {
        //   DiaryController controller = Get.find<DiaryController>(tag: 'diary');
        //   controller.onInit();
        // }
        // await Get.put(UsualController(), tag: "usual").getUserUsualMeals();
        // await Get.put(UsualController(), tag: "usual").usualMealsData();
        Get.offAndToNamed(Routes.HOME);
      } else {
        setState(() {
          loginResponse = value;
          showLoader = false;
        });

        Fluttertoast.showToast(msg: " ${value.message} ");
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
                          value: kDebugMode ? '123456' : '',
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgetPassword()));
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
                                    sendData();
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
                                  Get.toNamed(Routes.REGISTER);
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
