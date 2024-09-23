import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../resources/resources.dart';
import '../view/views.dart';

class Alerts {
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool forError = true,
    Duration duration = Time.t2s,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: forError ? AppColors.red : AppColors.dracula,
        content: CustomText(message, color: AppColors.white),
      ),
    );
  }

  static void showActionSnackBar(
    BuildContext context, {
    required String message,
    required String actionLabel,
    required VoidCallback onActionPressed,
    Duration duration = Time.longTime,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: AppColors.dracula,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppPadding.p16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s8)),
        action: SnackBarAction(label: actionLabel, onPressed: onActionPressed, textColor: AppColors.white),
        content: CustomText(message, color: AppColors.white),
      ),
    );
  }

  static void showToast(
    String message, [
    Toast length = Toast.LENGTH_SHORT,
    ToastGravity toastGravity = ToastGravity.BOTTOM,
  ]) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: toastGravity,
      timeInSecForIosWeb: 3,
      fontSize: FontSize.s14,
    );
  }

  static void closeAllSnackBars(BuildContext context) => ScaffoldMessenger.of(context).clearSnackBars();

}
