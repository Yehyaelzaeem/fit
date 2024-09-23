import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/localization/l10n/l10n.dart';
import '../../../../core/resources/app_assets.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/const_strings.dart';
import '../../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../../core/view/widgets/default/app_buttons.dart';
import '../../../../core/view/widgets/default/edit_text.dart';
import '../../../../core/view/widgets/default/text.dart';
import '../../cubit/auth_cubit/auth_cubit.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late final AuthCubit authCubit;
  late String pin;
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
                        'Forgot Password',
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
                              SizedBox(
                                  height:
                                  MediaQuery.of(context).size.width / 14),
                              kButtonDefault(
                                '  SEND  ',
                                marginH:
                                MediaQuery.of(context).size.width / 4.5,
                                paddingV: 0,
                                func: () {
                                  if (!key.currentState!.validate()) {
                                    print("Ererer");
                                    return;
                                  } else {
                                    authCubit.sendDataForgetPassword(pin,context);
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
