import 'package:app/app/utils/styles/app_text_theme.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/auth_error.dart';
import 'package:app/app/widgets/default/no_internet_conn.dart';
import 'package:app/app/widgets/default/server_error.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget errorHandler(String error, dynamic controller) {
  if (error == 'server') {
    return ServerErrorWidget(refresh: () {
      controller.getNetworkData();
    });
  } else if (error == 'network') {
    return NoInternetConnection(refresh: () {
      controller.getNetworkData();
    });
  } else if (error == 'auth') {
    return AuthErrorWidget(refresh: () {
      controller.getNetworkData();
    });
  } else {
    return Container(
      width: Get.width,
      child: Center(
        child: Column(
          children: [
            Text(error),
            Container(
              margin: EdgeInsets.all(8),
              width: Get.width / 3,
              decoration: kRetryButtonAccentStyle,
              child: TextButton(
                  onPressed: () {
                    controller.getNetworkData();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Strings().retry,
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
