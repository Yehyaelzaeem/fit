import 'package:app/app/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

appDialog({
  required String title,
  required IconData iconData,
  Function? confirmAction,
  Function? cancelAction,
  String confirmText = '',
  String cancelText = '',
}) {
  return Get.dialog(
    Dialog(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded, size: 50, color: Colors.grey),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                // color: Color(0xffF6F6F6),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey[300]!,
                //     blurRadius: 3,
                //     spreadRadius: 1,
                //     offset: Offset(3, 3),
                //   ),
                // ],
              ),
              child: Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (cancelAction != null)
                  GestureDetector(
                    onTap: () => cancelAction(),
                    child: Container(
                      width: Get.width / 5,
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
                          Text(
                            cancelText,
                            style: GoogleFonts.cairo(fontSize: 14.0, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (cancelAction != null)
                  GestureDetector(
                    onTap: () => confirmAction!(),
                    child: Container(
                      width: Get.width / 5,
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: kColorPrimary),
                        borderRadius: BorderRadius.circular(200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            confirmText,
                            style: GoogleFonts.cairo(fontSize: 14.0, color: Colors.black),
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
    ),
  );
}
