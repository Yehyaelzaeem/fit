import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../resources/resources.dart';

class CustomText extends StatelessWidget {
  final bool autoSized;
  final String text;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final double? height;
  final int? maxLines;
  final TextDecoration? decoration;

  const CustomText(
    this.text, {
    this.autoSized = false,
    this.color,
    this.fontSize = FontSize.s14,
    this.fontWeight = FontWeightManager.medium,
    this.textAlign,
    this.height,
    this.overflow,
    this.maxLines,
    this.decoration,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      color: color ?? AppColors.black,
      fontSize: fontSize,
      fontFamily: FontConstants.arabicFontFamily,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
    );
    return autoSized
        ? AutoSizeText(
            text,
            textAlign: textAlign,
            overflow: overflow,
            maxLines: maxLines,
            style: textStyle,
          )
        : Text(
            text,
            textAlign: textAlign,
            overflow: overflow,
            maxLines: maxLines,
            style: textStyle,
          );
  }
}
