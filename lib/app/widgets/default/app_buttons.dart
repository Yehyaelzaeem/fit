import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';

Widget kButton(
  String message, {
  Color? color,
  Color? textColor,
  double paddingV = 6,
  double paddingH = 6,
  double marginV = 6,
  double marginH = 6,
  double textSize = 16,
  bool bold = true,
  bool loading = false,
  var func,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: marginH, vertical: marginV),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: func,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        decoration: BoxDecoration(
          color: color == null ? kColorPrimary : color,
          borderRadius: BorderRadius.circular(250),
        ),
        child: loading
            ? Center(
                child: Container(
                  width: 30,
                  height: 30,
                  padding: EdgeInsets.all(4),
                  child: CircularProgressIndicator(
                    color: textColor == null ? Colors.white : textColor,
                    strokeWidth: 1.2,
                  ),
                ),
              )
            : Center(
                child: kTextHeader(message,
                    size: textSize,
                    color: textColor == null ? Colors.white : textColor,
                    bold: bold)),
      ),
    ),
  );
}

Widget kButtonDefault(
  String message, {
  Color? color,
  Color? textColor,
  double paddingV = 6,
  double paddingH = 6,
  double marginV = 6,
  double marginH = 6,
  bool bold = true,
  bool loading = false,
  bool fullWidth = false,
  bool shadow = false,
  var func,
}) {
  return Container(
      margin: EdgeInsets.symmetric(horizontal: marginH, vertical: marginV),
      width: fullWidth ? double.infinity : null,
      child: TextButton(
        onPressed: func,
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) => kColorPrimary),
          // foregroundColor: MaterialStateColor.resolveWith((states) => kColorAccent),
          // overlayColor:  MaterialStateColor.resolveWith((states) => kColorAccent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(64.0),
              // side: BorderSide(color: Colors.red),
            ),
          ),
          shadowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade300),
          elevation: !shadow ? null : MaterialStateProperty.resolveWith((states) => 4),
        ),
        child: loading
            ? Center(
                child: Container(
                  width: 30,
                  height: 30,
                  padding: EdgeInsets.all(4),
                  child: CircularProgressIndicator(
                    color: textColor == null ? Colors.white : textColor,
                    strokeWidth: 1.2,
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
                child: kTextHeader(message,
                    color: textColor == null ? Colors.white : textColor, bold: bold)),
      ));
}

Widget kButtonWithIcon(
  String message, {
  Color? color,
  Color? textColor,
  double paddingV = 6,
  double paddingH = 6,
  double marginV = 6,
  double marginH = 6,
  bool bold = true,
  bool loading = false,
  var func,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: marginH, vertical: marginV),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: func,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        decoration: BoxDecoration(
          color: color == null ? kColorPrimary : color,
          borderRadius: BorderRadius.circular(250),
        ),
        child: loading
            ? Center(
                child: Container(
                  width: 30,
                  height: 30,
                  padding: EdgeInsets.all(4),
                  child: CircularProgressIndicator(
                    color: textColor == null ? Colors.white : textColor,
                    strokeWidth: 1.2,
                  ),
                ),
              )
            : Center(
                child: kTextHeader(message,
                    color: textColor == null ? Colors.white : textColor, bold: bold)),
      ),
    ),
  );
}
