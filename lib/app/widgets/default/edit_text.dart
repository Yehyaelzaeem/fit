import 'package:app/app/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditText extends StatelessWidget {
  final String? suffixText;
  final String hint;
  final String value;
  final bool enable;
  final bool label;
  final bool autoValidate;
  final bool noBorder;
  final int lines;
  final Function? updateFunc;
  final Function? validateFunc;
  final IconData? iconData;
  final IconData? suffixIconData;
  final double fontSize;
  final double radius;
  final double contentPaddingH;
  final TextInputType type;
  final List<TextInputFormatter>? formatter;
  final Color? background;

  EditText({
    this.background,
    this.iconData,
    required this.value,
    required this.hint,
    this.autoValidate = false,
    this.enable = true,
    this.noBorder = false,
    this.label = false,
    this.contentPaddingH = 16,
    this.lines = 1,
    this.fontSize = 14,
    this.radius = 64,
    this.updateFunc,
    this.suffixIconData,
    this.validateFunc,
    this.suffixText,
    this.formatter,
    this.type = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      padding: EdgeInsets.all(4),
      child: TextFormField(
        autovalidateMode: autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        initialValue: value,
        decoration: InputDecoration(
            border: noBorder?InputBorder.none:OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: Colors.grey, width: 1.5),
    
            ),
            disabledBorder: noBorder?InputBorder.none:OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: Colors.grey, width: 1.5),
            ),
            focusedBorder: noBorder?InputBorder.none:OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: kColorPrimary, width: 2),
            ),enabledBorder: !noBorder?null:InputBorder.none,
            errorStyle: TextStyle(fontSize: 10),
            labelStyle: TextStyle(fontSize: fontSize,color: kColorAccent),
            hintStyle: TextStyle(fontSize: fontSize, color: Colors.black, fontWeight: FontWeight.w300),
            labelText: label ? hint : null,
            hintText: hint,
            counterStyle: TextStyle(color: Colors.green),
            suffixText: suffixText,
            suffixIcon:suffixIconData == null
                ? null
                : Icon(
                    suffixIconData,
                    color: Colors.grey,
                  ),
            suffixStyle: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            prefixIcon: iconData == null
                ? null
                : Icon(
                    iconData,
                    color: Colors.grey,
                  ),
            contentPadding: EdgeInsets.symmetric(horizontal: contentPaddingH, vertical: 0)),
        keyboardType: type,
        validator: (text) {
          if (validateFunc != null) return validateFunc!(text);
          return null;
        },
        enabled: enable,
        maxLines: lines,
        inputFormatters: formatter,
        onChanged: (newValue) {
          if (updateFunc != null) return updateFunc!(newValue);
          return null;
        },
        onSaved: (newValue) {
          if (updateFunc != null) return updateFunc!(newValue);
          return null;
        },
      ),
    );
  }
}
