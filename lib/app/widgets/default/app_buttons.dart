import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';

Widget kButton(
  String message, {
  Color? color,
  Widget? child,
  Color? textColor,
  double paddingV = 6,
  double paddingH = 6,
  double marginV = 6,
  double marginH = 6,
  double textSize = 16,
  bool bold = true,
  double? hight,
  bool loading = false,
  var func,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: func,
      child: Container(
        height: hight ?? 45,
        // padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
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
                child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: child==null?Text(
                  message,
                  style: TextStyle(
                      fontSize: textSize,
                      fontWeight:
                          bold == true ? FontWeight.bold : FontWeight.normal,
                      color: textColor ?? Colors.white),
                ):child,
              )),
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
  Border? border = null,
  var func,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: func,
      child: Container(
        height: 45,
        // padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        decoration: BoxDecoration(
            color: color == null ? kColorPrimary : color,
            borderRadius: BorderRadius.circular(250),
            border: border),
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
                child: Text(
                message,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        bold == true ? FontWeight.bold : FontWeight.normal,
                    color: textColor ?? Colors.white),
              )),
      ),
    ),
  );
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
                    color: textColor == null ? Colors.white : textColor,
                    bold: bold)),
      ),
    ),
  );
}
