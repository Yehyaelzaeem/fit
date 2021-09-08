import 'package:flutter/material.dart';

Widget kTextfooter(String message,
    {double size = 12,
    TextAlign align = TextAlign.center,
    double paddingV = 4,
    double paddingH = 4,
    bool bold = false,
    bool white = false,
    Color color = Colors.grey}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
    child: Text(
      message,
      style: TextStyle(
        color: white ? Colors.white : color,
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
      textAlign: align,
    ),
  );
}

Widget kTextbody(String message,
    {double size = 14,
    TextAlign align = TextAlign.center,
    double paddingV = 4,
    double paddingH = 4,
    bool bold = false,
    int? maxLines,
    bool white = false,
    Color color = Colors.black87}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
    child: Text(
      message,
      style: TextStyle(
        color: white ? Colors.white : color,
        fontSize: size,
        fontWeight: bold ==true? FontWeight.bold : FontWeight.normal,
      ),
      textAlign: align,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
    ),
  );
}

Widget kTextHeader(String message,
    {double size = 16,
    TextAlign align = TextAlign.center,
    double paddingV = 4,
    double paddingH = 4,
    bool bold = false,
    bool white = false,
    int? maxLines,
    Color color = Colors.black87}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
    child: Text(
      message,
      style: TextStyle(
        color: white ? Colors.white : color,
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
      textAlign: align,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
    ),
  );
}
