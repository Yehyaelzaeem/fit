import 'package:app/app/utils/translations/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class Echo {
  Echo(String text) {
    print('------> $text');
  }
}

class EchoC {
  EchoC(String text, BuildContext context) {
    print('------>${context.widget.toStringShort()} $text');
  }
}

class DebugSnackbar {
  DebugSnackbar(String message) {
    if (kDebugMode) Get.snackbar(Strings().notification, message);
  }
}
