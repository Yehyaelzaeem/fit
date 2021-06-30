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
  final int lines;
  final Function? updateFunc;
  final Function? validateFunc;
  final IconData? iconData;
  final IconData? suffixIconData;
  final double fontSize;
  final TextInputType type;
  final List<TextInputFormatter>? formatter;

  EditText({
    this.iconData,
    required this.value,
    required this.hint,
    this.autoValidate = false,
    this.enable = true,
    this.label = false,
    this.lines = 1,
    this.fontSize = 14,
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
      padding: EdgeInsets.all(4),
      child: TextFormField(
        autovalidateMode: autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        initialValue: value,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(64),
              borderSide: BorderSide(color: Colors.grey, width: 1.5),
    
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(64),
              borderSide: BorderSide(color: Colors.grey, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(64),
              borderSide: BorderSide(color: kColorPrimary, width: 2),
            ),
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
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0)),
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
