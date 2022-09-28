import 'package:app/app/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditText extends StatelessWidget {
  final String? suffixText;
  final String? hint;
  final String? value;
  final bool enable;
  final bool label;
  final bool autoValidate;
  final bool noBorder;
  final int lines;
  final Function? updateFunc;
  final Function? validateFunc;
  final Function? onSubmit;
  final IconData? iconData;
  final IconData? suffixIconData;
  final Widget? suffixData;
  final double fontSize;
  final double radius;
  final double contentPaddingH;
  final double contentPaddingV;
  final double padding;
  final TextInputType type;
  final List<TextInputFormatter>? formatter;
  final Color? background;
  final Color hintColor;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  EditText({
    this.hintColor = Colors.black,
    this.background,
    this.focusNode,
    this.autofocus = false,
    this.iconData,
    this.value,
    this.hint,
    this.autoValidate = false,
    this.enable = true,
    this.noBorder = false,
    this.label = false,
    this.contentPaddingH = 16,
    this.contentPaddingV = 8,
    this.padding = 4,
    this.lines = 1,
    this.fontSize = 14,
    this.radius = 64,
    this.updateFunc,
    this.suffixIconData,
    this.validateFunc,
    this.suffixText,
    this.formatter,
    this.type = TextInputType.text,
    this.controller,
    this.suffixData,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(radius)),
      padding: EdgeInsets.all(padding),
      child: TextFormField(
        initialValue: value,
        focusNode: focusNode,
        autofocus: autofocus,
        controller: controller,
        autovalidateMode: autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        decoration: InputDecoration(
            border: noBorder
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius),
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
            disabledBorder: noBorder
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius),
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
            focusedBorder: noBorder
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius),
                    borderSide: BorderSide(color: kColorPrimary, width: 2),
                  ),
            enabledBorder: !noBorder ? null : InputBorder.none,
            errorStyle: TextStyle(fontSize: 10),
            labelStyle: TextStyle(fontSize: fontSize, color: kColorAccent),
            hintStyle: TextStyle(fontSize: fontSize, color: hintColor, fontWeight: FontWeight.w300),
            labelText: label ? hint : null,
            hintText: hint,
            counterStyle: TextStyle(color: Colors.green),
            suffixText: suffixText ?? null,
            suffixIcon: suffixData != null
                ? suffixData
                : suffixIconData == null
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
            contentPadding: EdgeInsets.symmetric(horizontal: contentPaddingH, vertical: contentPaddingV)),
        keyboardType: type,
        validator: (text) {
          if (validateFunc != null) return validateFunc!(text);
          return null;
        },
        enabled: enable,
        maxLines: lines == 0 ? null : lines,
        inputFormatters: formatter,
        onChanged: (newValue) {
          if (updateFunc != null) return updateFunc!(newValue);
          return null;
        },
        onFieldSubmitted: (newValue) {
          if (onSubmit != null) return onSubmit!(newValue);
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
