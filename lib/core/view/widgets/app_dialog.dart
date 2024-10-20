import 'package:app/core/resources/app_colors.dart';
import 'package:app/core/view/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../resources/resources.dart';

appDialog({
  required String title,
  Widget? image,
  Widget? child,
  bool barrierDismissible = true,
  bool isList = false,
  String? body,
  Function? confirmAction,
  Function? cancelAction,
  String confirmText = '',
  String cancelText = '',
  required BuildContext context,
}) {
   showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.only(top: image != null ? 6 : 10, bottom: 12),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
            child: isList == false
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (image != null) image,
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: FontSize.s18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (child != null) child,
                if (body != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                    ),
                    child: Text(
                      body,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: AppSize.s12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (cancelAction != null)
                        GestureDetector(
                          onTap: () => cancelAction(),
                          child: Container(
                            width: deviceWidth / 4,
                            height: AppSize.s40,
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: Color(0xFF7FC902),
                              border: Border.all(color: Color(0xFF7FC902)),
                              borderRadius: BorderRadius.circular(200),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CustomText(
                                  cancelText,
                                      fontSize: 14.0,
                                    color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (confirmAction != null)
                        GestureDetector(
                          onTap: () => confirmAction(),
                          child: Container(
                            width: deviceWidth / 4,
                            height: AppSize.s40,
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: AppColors.PRIMART_COLOR),
                              borderRadius: BorderRadius.circular(200),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  confirmText,
                                  style: GoogleFonts.cairo(
                                      fontSize: 14.0, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            )
                : ListView(
              shrinkWrap: true,
              children: [
                if (image != null) image,
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (child != null) child,
                if (body != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                    ),
                    child: Text(
                      body,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (cancelAction != null)
                      GestureDetector(
                        onTap: () => cancelAction(),
                        child: Container(
                          width: deviceWidth / 5,
                          margin: EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Color(0xFF7FC902),
                            border: Border.all(color: Color(0xFF7FC902)),
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CustomText(
                                cancelText,
                                    fontSize: AppSize.s16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),

                            ],
                          ),
                        ),
                      ),
                    if (confirmAction != null)
                      GestureDetector(
                        onTap: () => confirmAction(),
                        child: Container(
                          width: deviceWidth / 5,
                          margin: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.PRIMART_COLOR),
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CustomText(
                                confirmText,
                                    fontSize: AppSize.s16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,

                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        );
      }
      );
}
