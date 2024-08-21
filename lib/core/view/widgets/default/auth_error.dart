
import 'package:app/core/view/widgets/default/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/navigation/routes.dart';
import '../../../utils/strings.dart';

class AuthErrorWidget extends StatelessWidget {
  final Function refresh;

  AuthErrorWidget({required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 8),
          Icon(
            Icons.warning,
            color: Colors.orange,
            size: 130,
          ),
          SizedBox(height: 8),
          Text(Strings().requireLoginMessage),
          SizedBox(height: 8),
          kButtonDefault(Strings().login, func: () {
            Get.toNamed(Routes.loginScreen);
          }),
        ],
      ),
    );
  }
}
