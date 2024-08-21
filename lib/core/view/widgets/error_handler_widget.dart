
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/strings.dart';
import '../decorations/app_text_theme.dart';
import 'default/auth_error.dart';
import 'default/no_internet_conn.dart';
import 'default/server_error.dart';

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
